import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { setCookie } from 'hono/cookie';
import { serve } from '@hono/node-server';
import initSqlJs from 'sql.js';
import fs from 'fs';
import path from 'path';

const dbPath = path.resolve(process.cwd(), 'data.sqlite');
const schemaPath = path.resolve(process.cwd(), 'schema.sql');
const publicDir = path.resolve(process.cwd(), 'public');

const SQL = await initSqlJs({
  locateFile: (file) => path.resolve(process.cwd(), 'node_modules', 'sql.js', 'dist', file),
});

const initializeDatabase = () => {
  const exists = fs.existsSync(dbPath);
  const fileData = exists ? fs.readFileSync(dbPath) : null;
  const db = fileData ? new SQL.Database(fileData) : new SQL.Database();

  if (!exists) {
    const schema = fs.readFileSync(schemaPath, 'utf-8');
    db.exec(schema);
    fs.writeFileSync(dbPath, Buffer.from(db.export()));
  }

  return db;
};

const db = initializeDatabase();

const persist = () => {
  fs.writeFileSync(dbPath, Buffer.from(db.export()));
};

const all = (sql: string, params: any[] = []) => {
  const stmt = db.prepare(sql);
  stmt.bind(params);
  const rows: any[] = [];
  while (stmt.step()) {
    rows.push(stmt.getAsObject());
  }
  stmt.free();
  return rows;
};

const getOne = (sql: string, params: any[] = []) => {
  const stmt = db.prepare(sql);
  stmt.bind(params);
  const row = stmt.step() ? stmt.getAsObject() : null;
  stmt.free();
  return row;
};

const run = (sql: string, params: any[] = []) => {
  db.run(sql, params);
  persist();
};

const runAndGetId = (sql: string, params: any[] = []) => {
  run(sql, params);
  const row = getOne('SELECT last_insert_rowid() AS id');
  return row?.id ?? null;
};

const app = new Hono();
app.use('/*', cors());

app.get('/api/inicializar', (c) => {
  const productos = all('SELECT * FROM productos');
  const tramos = all('SELECT * FROM tramos_delivery');
  return c.json({ productos, tramos });
});

app.get('/api/clientes/:telefono', (c) => {
  const telefono = c.req.param('telefono');
  const cliente = getOne('SELECT * FROM clientes WHERE telefono = ?', [telefono]);
  return cliente ? c.json(cliente) : c.json({ error: 'No encontrado' }, 404);
});

app.post('/api/clientes', async (c) => {
  const body = await c.req.json();
  const telefono = String(body.telefono || body.telephone || '').trim();
  const nombre = String(body.nombre || body.name || '').trim();
  const direccion = String(body.direccion || body.address || '').trim();
  const indicaciones_entrega = String(body.indicaciones || body.indicaciones_entrega || '');
  const tramo_delivery_id = body.tramo_delivery_id ?? body.tramo_id ?? null;

  if (!telefono || !nombre) {
    return c.json({ success: false, error: 'telefono y nombre son requeridos' }, 400);
  }

  run(
    `INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id)
     VALUES (?, ?, ?, ?, ?)
     ON CONFLICT(telefono) DO UPDATE SET
       nombre = excluded.nombre,
       direccion = excluded.direccion,
       indicaciones_entrega = excluded.indicaciones_entrega,
       tramo_delivery_id = excluded.tramo_delivery_id`,
    [telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id]
  );

  return c.json({ success: true });
});

app.post('/api/pedidos', async (c) => {
  try {
    const body = await c.req.json();
    const telefono = body.telefono ? String(body.telefono).trim() : (String(body.telephone || '').trim() || null);
    const nombre = body.nombre ? String(body.nombre).trim() : String(body.name || 'Cliente Nuevo').trim();
    const tipo_pedido = String(body.tipo_pedido || 'delivery').toLowerCase();
    const costo_delivery = Number(body.costo_delivery ?? 0);
    const total_cobrado = Number(body.total_cobrado ?? 0);
    const metodo_pago = String(body.metodo_pago || 'efectivo').toLowerCase();
    const descuento_porcentaje = Number((body.descuento_porcentaje ?? body.descuento) ?? 0);
    const direccion = String(body.direccion || body.address || 'Sin dirección');
    const indicaciones = String(body.indicaciones || body.indicaciones_entrega || '');
    const tramo_delivery_id = body.tramo_delivery_id ?? body.tramo_id ?? null;

    if (telefono) {
      run(
        `INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id)
         VALUES (?, ?, ?, ?, ?)
         ON CONFLICT(telefono) DO UPDATE SET
           nombre = COALESCE(excluded.nombre, clientes.nombre),
           direccion = COALESCE(excluded.direccion, clientes.direccion),
           indicaciones_entrega = COALESCE(excluded.indicaciones_entrega, clientes.indicaciones_entrega),
           tramo_delivery_id = COALESCE(excluded.tramo_delivery_id, clientes.tramo_delivery_id)`,
        [telefono, nombre, direccion, indicaciones, tramo_delivery_id]
      );
    }

    run(
      `INSERT INTO pedidos (cliente_telefono, tipo_pedido, costo_delivery, total_cobrado, metodo_pago, descuento_porcentaje, direccion_entrega, fecha, estado)
       VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now', 'localtime'), 'pendiente')`,
      [telefono, tipo_pedido, costo_delivery, total_cobrado, metodo_pago, descuento_porcentaje, direccion]
    );

    // Obtener el ID del último pedido insertado usando MAX
    const pedidoIdData = getOne('SELECT MAX(id) AS id FROM pedidos');
    const pedidoId = pedidoIdData?.id ?? null;
    
    if (!pedidoId) {
      return c.json({ success: false, error: 'No se pudo obtener el ID del pedido' }, 500);
    }

    const items = body.items || [];

    const itemStmt = db.prepare(`
      INSERT INTO items_pedido (pedido_id, producto_id, nombre_producto, cantidad, precio_unitario)
      VALUES (?, ?, ?, ?, ?)
    `);

    for (const item of items) {
      const pId = Number(item.producto_id ?? item.id ?? 0);
      const cant = Number(item.cantidad || 1);
      const precio = Number(item.precio_unitario ?? item.precio_venta ?? item.precio ?? 0);
      const nombreProducto = String(item.nombre || item.alias || 'Producto sin nombre');

      itemStmt.bind([pedidoId, pId, nombreProducto, cant, precio]);
      itemStmt.step();
      itemStmt.reset();
    }

    itemStmt.free();
    persist();

    const nuevoPedido = getOne('SELECT * FROM pedidos WHERE id = ?', [pedidoId]);
    const itemsPedido = all('SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre FROM items_pedido i LEFT JOIN productos p ON i.producto_id = p.id WHERE i.pedido_id = ?', [pedidoId]);
    return c.json({ success: true, pedido: { ...nuevoPedido, items: itemsPedido } });
  } catch (err: any) {
    return c.json({ success: false, error: err.message }, 500);
  }
});

app.get('/api/pedidos', (c) => {
  const pedidos = all(`
    SELECT p.*, c.nombre as cliente_nombre
    FROM pedidos p
    LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
    ORDER BY p.fecha DESC LIMIT 200
  `);
  const items = all(`
    SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre
    FROM items_pedido i
    LEFT JOIN productos p ON i.producto_id = p.id
  `);
  const resultados = pedidos.map((p: any) => ({
    ...p,
    items: items.filter((i: any) => i.pedido_id === p.id)
  }));
  return c.json(resultados);
});

app.get('/api/pedidos/ultimo/:telefono', (c) => {
  const telefono = c.req.param('telefono');
  const pedido = getOne(`
    SELECT p.*, p.direccion_entrega AS direccion, c.nombre as cliente_nombre
    FROM pedidos p
    LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
    WHERE p.cliente_telefono = ?
    ORDER BY p.fecha DESC LIMIT 1
  `, [telefono]);

  if (!pedido) return c.json({ error: 'No encontrado' }, 404);

  const items = all(`
    SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre, p.precio_venta
    FROM items_pedido i
    LEFT JOIN productos p ON i.producto_id = p.id
    WHERE i.pedido_id = ?
  `, [pedido.id]);

  return c.json({ ...pedido, items });
});

app.get('/api/pedidos/pendientes', (c) => {
  const pedidos = all(`
    SELECT p.*, c.nombre as cliente_nombre
    FROM pedidos p
    LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
    WHERE p.estado != 'finalizado' OR p.estado IS NULL
    ORDER BY p.fecha DESC
  `);
  const items = all('SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre FROM items_pedido i LEFT JOIN productos p ON i.producto_id = p.id');
  const resultados = pedidos.map((p: any) => ({ ...p, items: items.filter((i: any) => i.pedido_id === p.id) }));
  return c.json(resultados);
});

app.post('/api/pedidos/:id/finalizar', (c) => {
  const id = c.req.param('id');
  run("UPDATE pedidos SET estado = 'finalizado' WHERE id = ?", [id]);
  return c.json({ success: true });
});

app.post('/api/productos', async (c) => {
  const { nombre, precio_venta, categoria } = await c.req.json();
  run('INSERT INTO productos (nombre, precio_venta, categoria) VALUES (?, ?, ?)', [nombre, precio_venta, categoria]);
  return c.json({ success: true });
});

app.post('/api/tramos', async (c) => {
  const { zona, precio_envio } = await c.req.json();
  run('INSERT INTO tramos_delivery (zona, precio_envio) VALUES (?, ?)', [zona, precio_envio]);
  return c.json({ success: true });
});

app.get('/api/arqueo/estado', (c) => {
  const openArqueo = getOne("SELECT * FROM arqueos_caja WHERE estado = 'abierto'");
  if (!openArqueo) return c.json({ abierto: false });
  const ingresos = all(`
    SELECT metodo_pago, SUM(total_cobrado) as total
    FROM pedidos
    WHERE fecha >= ? AND estado = 'finalizado'
    GROUP BY metodo_pago
  `, [openArqueo.fecha_apertura]);
  return c.json({ abierto: true, arqueo: openArqueo, ingresos });
});

app.post('/api/arqueo/abrir', async (c) => {
  const { monto_inicial } = await c.req.json();
  const existe = getOne("SELECT id FROM arqueos_caja WHERE estado = 'abierto'");
  if (existe) return c.json({ success: false, error: 'Caja ya abierta' }, 400);
  run("INSERT INTO arqueos_caja (monto_inicial, estado, fecha_apertura) VALUES (?, 'abierto', datetime('now', 'localtime'))", [monto_inicial]);
  return c.json({ success: true });
});

app.post('/api/arqueo/cerrar', async (c) => {
  const body = await c.req.json();
  run(`
    UPDATE arqueos_caja SET fecha_cierre = datetime('now', 'localtime'), usuario_efectivo = ?, usuario_tarjeta = ?, usuario_transferencia = ?, total_sistema_efectivo = ?, total_sistema_tarjeta = ?, total_sistema_transferencia = ?, total_egresos = ?, diferencia = ?, estado = 'cerrado' WHERE estado = 'abierto'
  `, [body.usuario_efectivo, body.usuario_tarjeta, body.usuario_transferencia, body.total_sistema_efectivo, body.total_sistema_tarjeta, body.total_sistema_transferencia, body.total_egresos, body.diferencia]);
  return c.json({ success: true });
});

app.post('/api/login', async (c) => {
  const { usuario, contrasena } = await c.req.json();
  if (usuario === 'admin' && contrasena === 'sushi2026') {
    setCookie(c, 'sesion_activa', 'true', {
      path: '/',
      secure: false,
      httpOnly: false,
      maxAge: 86400 * 7 // 7 days
    });
    return c.json({ success: true });
  }
  return c.json({ success: false }, 401);
});

// Serve static files
app.get('/*', async (c) => {
  const filePath = path.join(publicDir, c.req.path === '/' ? 'index.html' : c.req.path);
  try {
    if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
      const content = fs.readFileSync(filePath);
      const ext = path.extname(filePath);
      const mimeTypes: Record<string, string> = {
        '.html': 'text/html',
        '.js': 'application/javascript',
        '.css': 'text/css',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.gif': 'image/gif',
        '.svg': 'image/svg+xml',
        '.json': 'application/json',
      };
      const mimeType = mimeTypes[ext] || 'application/octet-stream';
      return c.body(content, { headers: { 'Content-Type': mimeType } });
    }
    // For routes, serve index.html to support client-side routing
    if (c.req.path.startsWith('/api')) {
      return c.json({ error: 'Not found' }, 404);
    }
    return c.body(fs.readFileSync(path.join(publicDir, 'index.html')), {
      headers: { 'Content-Type': 'text/html' }
    });
  } catch (err) {
    return c.json({ error: 'Internal server error' }, 500);
  }
});

const port = Number(process.env.PORT || 3000);
serve({ fetch: app.fetch, port }, () => {
  console.log(`✅ Server running on http://localhost:${port}`);
  console.log(`📁 Static files served from: public/`);
  console.log(`🗄️ Database: data.sqlite`);
});

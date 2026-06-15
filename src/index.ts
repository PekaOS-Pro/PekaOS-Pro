import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { setCookie } from 'hono/cookie';
import { serveStatic } from 'hono/cloudflare-workers';

// Type for Cloudflare Bindings
interface Env {
  DB: D1Database;
  ASSETS: any;
}

// Extend Hono context to include env
declare global {
  interface HonoRequest {
    env?: Env;
  }
}

const app = new Hono<{ Bindings: Env }>();
app.use('/*', cors());

// Endpoint de inicialización
app.get('/api/inicializar', async (c) => {
  const db = c.env.DB;
  const productos = await db.prepare('SELECT * FROM productos').all();
  const tramos = await db.prepare('SELECT * FROM tramos_delivery').all();
  return c.json({ 
    productos: productos.results || [], 
    tramos: tramos.results || [] 
  });
});

// Obtener cliente por teléfono
app.get('/api/clientes/:telefono', async (c) => {
  const telefono = c.req.param('telefono');
  const db = c.env.DB;
  const cliente = await db
    .prepare('SELECT * FROM clientes WHERE telefono = ?')
    .bind(telefono)
    .first();
  
  return cliente ? c.json(cliente) : c.json({ error: 'No encontrado' }, 404);
});

// Crear o actualizar cliente
app.post('/api/clientes', async (c) => {
  const body = await c.req.json() as any;
  const db = c.env.DB;
  const telefono = String(body.telefono || body.telephone || '').trim();
  const nombre = String(body.nombre || body.name || '').trim();
  const direccion = String(body.direccion || body.address || '').trim();
  const indicaciones_entrega = String(body.indicaciones || body.indicaciones_entrega || '');
  const tramo_delivery_id = body.tramo_delivery_id ?? body.tramo_id ?? null;

  if (!telefono || !nombre) {
    return c.json({ success: false, error: 'telefono y nombre son requeridos' }, 400);
  }

  await db
    .prepare(`
      INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(telefono) DO UPDATE SET
        nombre = excluded.nombre,
        direccion = excluded.direccion,
        indicaciones_entrega = excluded.indicaciones_entrega,
        tramo_delivery_id = excluded.tramo_delivery_id
    `)
    .bind([telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id])
    .run();

  return c.json({ success: true });
});

// Crear pedido
app.post('/api/pedidos', async (c) => {
  try {
    const body = await c.req.json() as any;
    const db = c.env.DB;
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

    // Guardar/actualizar cliente
    if (telefono) {
      await db
        .prepare(`
          INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id)
          VALUES (?, ?, ?, ?, ?)
          ON CONFLICT(telefono) DO UPDATE SET
            nombre = COALESCE(excluded.nombre, clientes.nombre),
            direccion = COALESCE(excluded.direccion, clientes.direccion),
            indicaciones_entrega = COALESCE(excluded.indicaciones_entrega, clientes.indicaciones_entrega),
            tramo_delivery_id = COALESCE(excluded.tramo_delivery_id, clientes.tramo_delivery_id)
        `)
        .bind([telefono, nombre, direccion, indicaciones, tramo_delivery_id])
        .run();
    }

    // Insertar pedido
    const pedidoResult = await db
      .prepare(`
        INSERT INTO pedidos (cliente_telefono, tipo_pedido, costo_delivery, total_cobrado, metodo_pago, descuento_porcentaje, direccion_entrega, fecha, estado)
        VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now'), 'pendiente')
      `)
      .bind([telefono, tipo_pedido, costo_delivery, total_cobrado, metodo_pago, descuento_porcentaje, direccion])
      .run();

    // Obtener el ID del pedido insertado
    const pedidoIdResult = await db
      .prepare('SELECT MAX(id) AS id FROM pedidos')
      .first() as any;
    
    const pedidoId = pedidoIdResult?.id;
    
    if (!pedidoId) {
      return c.json({ success: false, error: 'No se pudo obtener el ID del pedido' }, 500);
    }

    // Insertar items del pedido
    const items = body.items || [];
    for (const item of items) {
      const pId = Number(item.producto_id ?? item.id ?? 0);
      const cant = Number(item.cantidad || 1);
      const precio = Number(item.precio_unitario ?? item.precio_venta ?? item.precio ?? 0);
      const nombreProducto = String(item.nombre || item.alias || 'Producto sin nombre');

      await db
        .prepare(`
          INSERT INTO items_pedido (pedido_id, producto_id, nombre_producto, cantidad, precio_unitario)
          VALUES (?, ?, ?, ?, ?)
        `)
        .bind([pedidoId, pId, nombreProducto, cant, precio])
        .run();
    }

    // Obtener el pedido completo creado
    const nuevoPedido = await db
      .prepare('SELECT * FROM pedidos WHERE id = ?')
      .bind(pedidoId)
      .first();

    const itemsPedido = await db
      .prepare(`
        SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre 
        FROM items_pedido i 
        LEFT JOIN productos p ON i.producto_id = p.id 
        WHERE i.pedido_id = ?
      `)
      .bind(pedidoId)
      .all();

    return c.json({ 
      success: true, 
      pedido: { 
        ...nuevoPedido, 
        items: itemsPedido.results || [] 
      } 
    });
  } catch (err: any) {
    return c.json({ success: false, error: err.message }, 500);
  }
});

// Obtener todos los pedidos
app.get('/api/pedidos', async (c) => {
  const db = c.env.DB;
  const pedidos = await db
    .prepare(`
      SELECT p.*, c.nombre as cliente_nombre
      FROM pedidos p
      LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
      ORDER BY p.fecha DESC LIMIT 200
    `)
    .all();

  const items = await db
    .prepare(`
      SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre
      FROM items_pedido i
      LEFT JOIN productos p ON i.producto_id = p.id
    `)
    .all();

  const resultados = (pedidos.results || []).map((p: any) => ({
    ...p,
    items: (items.results || []).filter((i: any) => i.pedido_id === p.id)
  }));

  return c.json(resultados);
});

// Obtener último pedido de un cliente
app.get('/api/pedidos/ultimo/:telefono', async (c) => {
  const telefono = c.req.param('telefono');
  const db = c.env.DB;
  
  const pedido = await db
    .prepare(`
      SELECT p.*, p.direccion_entrega AS direccion, c.nombre as cliente_nombre
      FROM pedidos p
      LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
      WHERE p.cliente_telefono = ?
      ORDER BY p.fecha DESC LIMIT 1
    `)
    .bind(telefono)
    .first();

  if (!pedido) return c.json({ error: 'No encontrado' }, 404);

  const items = await db
    .prepare(`
      SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre, p.precio_venta
      FROM items_pedido i
      LEFT JOIN productos p ON i.producto_id = p.id
      WHERE i.pedido_id = ?
    `)
    .bind(pedido.id)
    .all();

  return c.json({ ...pedido, items: items.results || [] });
});

// Obtener pedidos pendientes
app.get('/api/pedidos/pendientes', async (c) => {
  const db = c.env.DB;
  const pedidos = await db
    .prepare(`
      SELECT p.*, c.nombre as cliente_nombre
      FROM pedidos p
      LEFT JOIN clientes c ON p.cliente_telefono = c.telefono
      WHERE p.estado != 'finalizado' OR p.estado IS NULL
      ORDER BY p.fecha DESC
    `)
    .all();

  const items = await db
    .prepare('SELECT i.*, COALESCE(i.nombre_producto, p.nombre) as nombre FROM items_pedido i LEFT JOIN productos p ON i.producto_id = p.id')
    .all();

  const resultados = (pedidos.results || []).map((p: any) => ({ 
    ...p, 
    items: (items.results || []).filter((i: any) => i.pedido_id === p.id) 
  }));

  return c.json(resultados);
});

// Finalizar pedido
app.post('/api/pedidos/:id/finalizar', async (c) => {
  const id = c.req.param('id');
  const db = c.env.DB;
  await db
    .prepare("UPDATE pedidos SET estado = 'finalizado' WHERE id = ?")
    .bind(id)
    .run();
  return c.json({ success: true });
});

// Crear producto
app.post('/api/productos', async (c) => {
  const { nombre, precio_venta, categoria } = await c.req.json() as any;
  const db = c.env.DB;
  await db
    .prepare('INSERT INTO productos (nombre, precio_venta, categoria) VALUES (?, ?, ?)')
    .bind([nombre, precio_venta, categoria])
    .run();
  return c.json({ success: true });
});

// Crear tramo de delivery
app.post('/api/tramos', async (c) => {
  const { zona, precio_envio } = await c.req.json() as any;
  const db = c.env.DB;
  await db
    .prepare('INSERT INTO tramos_delivery (zona, precio_envio) VALUES (?, ?)')
    .bind([zona, precio_envio])
    .run();
  return c.json({ success: true });
});

// Obtener estado del arqueo
app.get('/api/arqueo/estado', async (c) => {
  const db = c.env.DB;
  const openArqueo = await db
    .prepare("SELECT * FROM arqueos_caja WHERE estado = 'abierto'")
    .first();

  if (!openArqueo) return c.json({ abierto: false });

  const ingresos = await db
    .prepare(`
      SELECT metodo_pago, SUM(total_cobrado) as total
      FROM pedidos
      WHERE fecha >= ? AND estado = 'finalizado'
      GROUP BY metodo_pago
    `)
    .bind(openArqueo.fecha_apertura)
    .all();

  return c.json({ abierto: true, arqueo: openArqueo, ingresos: ingresos.results || [] });
});

// Abrir arqueo/caja
app.post('/api/arqueo/abrir', async (c) => {
  const { monto_inicial } = await c.req.json() as any;
  const db = c.env.DB;
  
  const existe = await db
    .prepare("SELECT id FROM arqueos_caja WHERE estado = 'abierto'")
    .first();

  if (existe) return c.json({ success: false, error: 'Caja ya abierta' }, 400);

  await db
    .prepare("INSERT INTO arqueos_caja (monto_inicial, estado, fecha_apertura) VALUES (?, 'abierto', datetime('now'))")
    .bind(monto_inicial)
    .run();

  return c.json({ success: true });
});

// Cerrar arqueo/caja
app.post('/api/arqueo/cerrar', async (c) => {
  const body = await c.req.json() as any;
  const db = c.env.DB;
  
  await db
    .prepare(`
      UPDATE arqueos_caja SET 
        fecha_cierre = datetime('now'), 
        usuario_efectivo = ?, 
        usuario_tarjeta = ?, 
        usuario_transferencia = ?, 
        total_sistema_efectivo = ?, 
        total_sistema_tarjeta = ?, 
        total_sistema_transferencia = ?, 
        total_egresos = ?, 
        diferencia = ?, 
        estado = 'cerrado' 
      WHERE estado = 'abierto'
    `)
    .bind([
      body.usuario_efectivo, 
      body.usuario_tarjeta, 
      body.usuario_transferencia, 
      body.total_sistema_efectivo, 
      body.total_sistema_tarjeta, 
      body.total_sistema_transferencia, 
      body.total_egresos, 
      body.diferencia
    ])
    .run();

  return c.json({ success: true });
});

// Login
app.post('/api/login', async (c) => {
  const { usuario, contrasena } = await c.req.json() as any;
  if (usuario === 'admin' && contrasena === 'sushi2026') {
    setCookie(c, 'sesion_activa', 'true', {
      path: '/',
      secure: true,
      httpOnly: true,
      maxAge: 86400 * 7 // 7 days
    });
    return c.json({ success: true });
  }
  return c.json({ success: false }, 401);
});

// Servir archivos estáticos (HTML, CSS, JS, PNG, etc.)
app.use('/public/*', serveStatic({ root: './' }));
app.use('/', serveStatic({ path: './public/index.html' }));
app.get('/', serveStatic({ path: './public/index.html' }));

export default app;

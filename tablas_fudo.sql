-- 1. Tabla de Tramos de Delivery
CREATE TABLE IF NOT EXISTS tramos_delivery (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    zona TEXT NOT NULL,
    precio_envio INTEGER NOT NULL
);

-- 2. Tabla de Insumos/Ingredientes (NUEVA)
CREATE TABLE IF NOT EXISTS ingredientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    stock_actual REAL DEFAULT 0,
    unidad TEXT,
    costo_por_unidad REAL DEFAULT 0
);

-- 3. Tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio_venta INTEGER NOT NULL,
    categoria TEXT
);

-- 4. Tabla de Recetas / Relación Plato-Insumo (NUEVA)
CREATE TABLE IF NOT EXISTS recetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    producto_id INTEGER,
    ingrediente_id INTEGER,
    cantidad_usada REAL NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id)
);

-- 5. Tabla de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    telefono TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    direccion TEXT,
    indicaciones_entrega TEXT,
    tramo_delivery_id INTEGER,
    FOREIGN KEY (tramo_delivery_id) REFERENCES tramos_delivery(id)
);

-- 6. Tabla de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_telefono TEXT,
    tipo_pedido TEXT DEFAULT 'delivery',
    costo_delivery INTEGER DEFAULT 0,
    total_cobrado INTEGER DEFAULT 0,
    metodo_pago TEXT DEFAULT 'efectivo',
    descuento_porcentaje INTEGER DEFAULT 0,
    direccion_entrega TEXT,
    fecha TEXT,
    estado TEXT DEFAULT 'pendiente',
    FOREIGN KEY (cliente_telefono) REFERENCES clientes(telefono)
);

-- 7. Tabla de Items por Pedido (ACTUALIZADA)
CREATE TABLE IF NOT EXISTS items_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER,
    producto_id INTEGER,
    nombre_producto TEXT, -- <-- NUEVA COLUMNA AÑADIDA
    cantidad INTEGER NOT NULL,
    precio_unitario INTEGER NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 8. Tabla de Arqueos de Caja
CREATE TABLE IF NOT EXISTS arqueos_caja (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    monto_inicial INTEGER NOT NULL,
    estado TEXT DEFAULT 'abierto',
    fecha_apertura TEXT,
    fecha_cierre TEXT,
    usuario_efectivo INTEGER DEFAULT 0,
    usuario_tarjeta INTEGER DEFAULT 0,
    usuario_transferencia INTEGER DEFAULT 0,
    total_sistema_efectivo INTEGER DEFAULT 0,
    total_sistema_tarjeta INTEGER DEFAULT 0,
    total_sistema_transferencia INTEGER DEFAULT 0,
    total_egresos INTEGER DEFAULT 0,
    diferencia INTEGER DEFAULT 0
);
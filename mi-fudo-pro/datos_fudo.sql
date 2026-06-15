-- ==========================================================================
-- 1. ELIMINACIÓN DE TABLAS PREVIAS (Para evitar conflictos al reiniciar)
-- ==========================================================================
DROP TABLE IF EXISTS recetas;
DROP TABLE IF EXISTS ingredientes;
DROP TABLE IF EXISTS items_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS tramos_delivery;
DROP TABLE IF EXISTS productos;

-- ==========================================================================
-- 2. CREACIÓN DE TABLAS (Estructura con Llaves Foráneas correctas)
-- ==========================================================================

CREATE TABLE tramos_delivery (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    zona TEXT NOT NULL,
    precio_envio INTEGER NOT NULL
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio_venta INTEGER NOT NULL,
    categoria TEXT NOT NULL
);

CREATE TABLE clientes (
    telefono TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    direccion TEXT,
    indicaciones_entrega TEXT,
    tramo_delivery_id INTEGER,
    FOREIGN KEY (tramo_delivery_id) REFERENCES tramos_delivery(id)
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_telefono TEXT,
    tipo_pedido TEXT NOT NULL, -- 'delivery' o 'retiro'
    costo_delivery INTEGER DEFAULT 0,
    total_cobrado INTEGER NOT NULL,
    metodo_pago TEXT NOT NULL,
    descuento_porcentaje INTEGER DEFAULT 0,
    direccion_entrega TEXT,
    fecha TEXT NOT NULL,
    estado TEXT DEFAULT 'pendiente',
    FOREIGN KEY (cliente_telefono) REFERENCES clientes(telefono)
);

CREATE TABLE items_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario INTEGER NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE ingredientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    stock_actual REAL NOT NULL,
    unidad TEXT NOT NULL, -- 'gr', 'unidades', etc.
    costo_por_unidad REAL NOT NULL
);

CREATE TABLE recetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    producto_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    cantidad_usada REAL NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id) ON DELETE CASCADE
);

CREATE TABLE arqueos_caja (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    monto_inicial INTEGER NOT NULL,
    fecha_apertura TEXT NOT NULL,
    fecha_cierre TEXT,
    usuario_efectivo INTEGER DEFAULT 0,
    usuario_tarjeta INTEGER DEFAULT 0,
    usuario_transferencia INTEGER DEFAULT 0,
    total_sistema_efectivo INTEGER DEFAULT 0,
    total_sistema_tarjeta INTEGER DEFAULT 0,
    total_sistema_transferencia INTEGER DEFAULT 0,
    total_egresos INTEGER DEFAULT 0,
    diferencia INTEGER DEFAULT 0,
    estado TEXT DEFAULT 'abierto'
);

-- ==========================================================================
-- 3. INSERCIÓN DE DATOS INICIALES (Mapeo de Sushi y Configuración)
-- ==========================================================================

-- 3.1 Tramos de Delivery
INSERT INTO tramos_delivery (id, zona, precio_envio) VALUES (1, 'Radio Urbano (Cerca)', 1500);
INSERT INTO tramos_delivery (id, zona, precio_envio) VALUES (2, 'Periferia / Rural', 3000);

-- 3.2 Productos de Sushi Reales (Mapeado exacto con IDs estables)
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (1, 'Avo Sake (8 cortes)', 4500, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (2, 'Maki Kani (8 cortes)', 4000, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (3, 'Hoso Ebi (6 cortes)', 3500, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (4, 'Chicken Panko (8 cortes)', 5000, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (5, 'Pollo Panko (4 Unidades)', 3000, 'Picoteos');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (6, 'Salmón Panko (4 Unidades)', 3500, 'Picoteos');

-- 3.3 Ingredientes en Stock Base (Para costeo y recetas de Sushi)
INSERT INTO ingredientes (id, nombre, stock_actual, unidad, costo_por_unidad) VALUES (1, 'Arroz de Sushi', 10000, 'gr', 0.002);
INSERT INTO ingredientes (id, nombre, stock_actual, unidad, costo_por_unidad) VALUES (2, 'Salmón Fresco', 2000, 'gr', 0.015);
INSERT INTO ingredientes (id, nombre, stock_actual, unidad, costo_por_unidad) VALUES (3, 'Pollo (Pechuga)', 5000, 'gr', 0.005);
INSERT INTO ingredientes (id, nombre, stock_actual, unidad, costo_por_unidad) VALUES (4, 'Queso Crema', 4000, 'gr', 0.006);

-- 3.4 Recetas Base de Ejemplo (Descuentan insumos automáticamente por producto)
-- El producto 1 (Avo Sake) usa 120gr de Arroz y 40gr de Salmón
INSERT INTO recetas (producto_id, ingrediente_id, cantidad_usada) VALUES (1, 1, 120);
INSERT INTO recetas (producto_id, ingrediente_id, cantidad_usada) VALUES (1, 2, 40);
-- El producto 4 (Chicken Panko) usa 120gr de Arroz y 50gr de Pollo
INSERT INTO recetas (producto_id, ingrediente_id, cantidad_usada) VALUES (4, 1, 120);
INSERT INTO recetas (producto_id, ingrediente_id, cantidad_usada) VALUES (4, 3, 50);

-- 3.5 Cliente Base de Prueba (Correctamente asociado al Tramo ID 1 existente)
INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id) 
VALUES ('912345678', 'Patricio Test', 'Av. Central 123', 'Casa con portón negro', 1);
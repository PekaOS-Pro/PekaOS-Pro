-- 1. ELIMINAR TABLAS EXISTENTES PARA EVITAR CONFLICTOS
DROP TABLE IF EXISTS recetas;
DROP TABLE IF EXISTS ingredientes;
DROP TABLE IF EXISTS items_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS tramos_delivery;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS arqueos_caja;

-- 2. CREAR ESTRUCTURA DE TABLAS
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
    tipo_pedido TEXT NOT NULL,
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
    nombre_producto TEXT,
    cantidad INTEGER NOT NULL,
    precio_unitario INTEGER NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE ingredientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    stock_actual REAL NOT NULL,
    unidad TEXT NOT NULL,
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

-- 3. INSERTAR DATOS INICIALES (Tramos y Productos)
INSERT INTO tramos_delivery (id, zona, precio_envio) VALUES (1, 'Radio Urbano (Cerca)', 1500);
INSERT INTO tramos_delivery (id, zona, precio_envio) VALUES (2, 'Periferia / Rural', 3000);

INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (1, 'Avo Sake (8 cortes)', 4500, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (2, 'Maki Kani (8 cortes)', 4000, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (3, 'Hoso Ebi (6 cortes)', 3500, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (4, 'Chicken Panko (8 cortes)', 5000, 'Rolls');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (5, 'Pollo Panko (4 Unidades)', 3000, 'Picoteos');
INSERT INTO productos (id, nombre, precio_venta, categoria) VALUES (6, 'Salmón Panko (4 Unidades)', 3500, 'Picoteos');

INSERT INTO clientes (telefono, nombre, direccion, indicaciones_entrega, tramo_delivery_id) 
VALUES ('912345678', 'Patricio Test', 'Av. Central 123', 'Casa con portón negro', 1);
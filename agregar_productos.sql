-- 1. Limpieza total de la tabla para evitar errores
DELETE FROM productos;

-- 2. Inserción de todos los productos
INSERT INTO productos (nombre, precio_venta, categoria, descripcion) VALUES 
-- TABLAS
('FULL CHICKEN (40 Piezas)', 20990, 'Tablas', 'Pollo, Queso Cream, Cebollín, Palta, Panko, Niguiri Crispy'),
('TABLA 2 (38 Piezas)', 18990, 'Tablas', 'Avo Sake, Maki Kani, Hoso Ebi, Chicken Panko, Pollo Panko, Salmon Panko'),
('TABLA 3 (72 Piezas)', 30990, 'Tablas', 'Avo Sake, Maki Kani, Cream Chicken, Futo Sake, Hoso Ebi, Chicken Panko, Vegetal Panko, Pollo Panko, Salmon Panko'),
('TABLA LIKE (50 Piezas)', 21990, 'Tablas', 'California Kani, Avo Chicken, Hoso Chicken Panko, Cream Vegetal, Vegetal Panko, Pollo Panko'),
('TABLA HOT (34 Piezas)', 19990, 'Tablas', 'Ebi Panko, Vegetal Panko, Hoso Chicken Panko, Pollo Panko'),
('TABLA VEGAN (32 Piezas)', 16990, 'Tablas', 'California Vegetal, Vegan Panko, Avo Fresh, Ura Vegan'),

-- SUPER PROMOS
('SUPER 1 (30 piezas)', 14990, 'Super Promos', 'Pollo Teriyaki, Kanikama, Camarón. Incluye soya, unagui y palitos.'),
('SUPER 2 (50 piezas)', 19990, 'Super Promos', 'Pollo Teriyaki, Kanikama, Camarón, Palta. Incluye soya, unagui y palitos.'),
('SUPER 3 (70 piezas)', 27990, 'Super Promos', 'Pollo Teriyaki, Kanikama, Palmito, Camarón, Palta. Incluye soya, unagui y palitos.'),

-- ROLLS TEMPURAS / PANKO
('KANI PANKO', 5300, 'Rolls - Tempura/Panko', 'Kanikama - Queso Cream - Pimentón'),
('CHICKEN PANKO', 5800, 'Rolls - Tempura/Panko', 'Pollo Teriyaki - Queso Cream - Cebollín'),
('SAKE PANKO', 6300, 'Rolls - Tempura/Panko', 'Salmón - Queso Cream - Ciboulette'),
('EBI PANKO', 5900, 'Rolls - Tempura/Panko', 'Camarón - Queso Cream - Cebollín'),
('TAKO PANKO', 6500, 'Rolls - Tempura/Panko', 'Pulpo - Queso Cream - Ciboulette'),
('VEGETAL PANKO', 5400, 'Rolls - Tempura/Panko', 'Espárrago - Pimentón - Palta'),
('SMOKE PANKO', 5900, 'Rolls - Tempura/Panko', 'Salmón Ahumado - Queso Cream - Cebollín'),
('MIX PANKO', 6500, 'Rolls - Tempura/Panko', 'Camarón - Salmón - Queso Cream - Cebollín'),
('VEGAN PANKO', 5500, 'Rolls - Tempura/Panko', 'Palta - Tomate Cherry - Choclo Baby'),
('CHICKEN NUSS PANKO', 6100, 'Rolls - Tempura/Panko', 'Pollo Teriyaki - Queso Cream - Nueces/Almendras'),
('EBI PANKO 2.0', 6300, 'Rolls - Tempura/Panko', 'Camarón - Queso Cream - Palta'),
('SEA BOMB', 7400, 'Rolls - Tempura/Panko', 'Camarón - Salmón - Pulpo - Queso Cream - Ciboulette'),
('CHICKEN PANKO 2.0', 6200, 'Rolls - Tempura/Panko', 'Pollo Teriyaki - Queso Cream - Palta'),
('MAGURO PANKO', 6400, 'Rolls - Tempura/Panko', 'Atún - Queso Cream - Cebollín'),
('PANKO ACEVICHADO', 9500, 'Rolls - Tempura/Panko', 'Queso Cream - Palta'),

-- AVOCADO ROLLS
('AVO KANI', 5400, 'Rolls - Avocado', 'Kanikama - Queso Cream - Cebollín'),
('AVO CHICKEN', 6200, 'Rolls - Avocado', 'Pollo Teriyaki - Queso Cream - Cebollín'),
('AVO SAKE', 6500, 'Rolls - Avocado', 'Salmón - Queso Cream - Ciboulette'),
('AVO EBI', 6400, 'Rolls - Avocado', 'Camarón - Queso Cream - Cebollín'),
('TAKO ROLL', 6600, 'Rolls - Avocado', 'Pulpo - Queso Cream - Cebollín'),
('AVO FRESH', 5200, 'Rolls - Avocado', 'Palmito - Espárrago - Cebollín'),
('TERI PANKO', 6500, 'Rolls - Avocado', 'Pollo Panko - Queso Cream - Cebollín'),
('AVO SAKE PANKO', 6900, 'Rolls - Avocado', 'Salmón Panko - Queso Cream - Cebollín'),
('AVO EBI TEMPURA', 6700, 'Rolls - Avocado', 'Camarón Tempura - Queso Cream - Ciboulette'),
('AVO SMOKE ROLL', 6200, 'Rolls - Avocado', 'Salmón Ahumado - Queso Cream - Cebollín'),
('AVO MIX', 7200, 'Rolls - Avocado', 'Salmón - Camarón - Queso Cream - Cebollín'),
('AVO TROPICAL', 6600, 'Rolls - Avocado', 'Salmón - Mango'),
('EBI LIKE', 6200, 'Rolls - Avocado', 'Camarón - Queso Cream - Masago'),
('AVO TONNO', 6400, 'Rolls - Avocado', 'Atún - Queso Cream - Cebollín'),
('AVO LIKE ROLL', 6300, 'Rolls - Avocado', 'Salmón - Palmito - Espárrago'),
('AVO VEGETAL PANKO', 5400, 'Rolls - Avocado', 'Cebollín Panko - Queso Cream - Pimentón'),
('AVO ACEVICHADO', 9100, 'Rolls - Avocado', 'Queso Cream - Espárrago - Palmito'),

-- URAMAKI ROLLS
('CALIFORNIA KANI', 4400, 'Rolls - Uramaki', 'Kanikama - Palta'),
('CALIFORNIA CHICKEN', 4800, 'Rolls - Uramaki', 'Pollo Teriyaki - Palta'),
('CALIFORNIA SAKE', 5300, 'Rolls - Uramaki', 'Salmón - Palta'),
('CALIFORNIA EBI', 4900, 'Rolls - Uramaki', 'Camarón - Palta'),
('CALIFORNIA VEGETAL', 4700, 'Rolls - Uramaki', 'Palmito - Palta - Ciboulette - Espárrago'),
('MAKI EBI TEMPURA', 5900, 'Rolls - Uramaki', 'Camarón Tempura - Queso Cream - Ciboulette'),
('MAKI YAKI PANKO', 5500, 'Rolls - Uramaki', 'Pollo Panko - Queso Cream - Cebollín'),
('MAKI SAKE PANKO', 5900, 'Rolls - Uramaki', 'Salmón Panko - Queso Cream - Cebollín'),
('SMOKE MAKI', 5200, 'Rolls - Uramaki', 'Salmón Ahumado - Queso Cream - Cebollín'),
('MAKI KANI', 4700, 'Rolls - Uramaki', 'Kanikama - Queso Cream - Palta'),
('MAKI YAKI', 5300, 'Rolls - Uramaki', 'Pollo Teriyaki - Queso Cream - Palta'),
('SAKE MAKI', 5700, 'Rolls - Uramaki', 'Salmón - Queso Cream - Palta'),
('EBI MAKI', 5400, 'Rolls - Uramaki', 'Camarón - Queso Cream - Palta - Ciboulette'),
('TAKO MAKI ROLL', 5900, 'Rolls - Uramaki', 'Pulpo - Palta - Ciboulette'),
('EBI SPICY', 5000, 'Rolls - Uramaki', 'Camarón - Palta - Ciboulette - Sriracha'),
('MAGURO MAKI', 5500, 'Rolls - Uramaki', 'Atún - Palta - Ciboulette'),
('URA VEGAN', 4400, 'Rolls - Uramaki', 'Palta - Pepino - Cebollín'),
('URA ACEVICHADO', 8500, 'Rolls - Uramaki', 'Queso Cream - Palmito - Palta'),

-- CREAM ROLLS
('CREAM KANI', 5000, 'Rolls - Cream', 'Kanikama - Palta'),
('CREAM CHICKEN', 5600, 'Rolls - Cream', 'Pollo Teriyaki - Palta - Cebollín'),
('CREAM SAKE', 6200, 'Rolls - Cream', 'Salmón - Palta - Ciboulette'),
('CREAM EBI', 5800, 'Rolls - Cream', 'Camarón - Ciboulette - Palta'),
('TAKO SNOW', 6300, 'Rolls - Cream', 'Pulpo - Palta - Pimentón'),
('SNOW EBI PANKO', 6300, 'Rolls - Cream', 'Camarón Panko - Palta - Cebollín'),
('SNOW SAKE TEMPURA', 6400, 'Rolls - Cream', 'Salmón Tempura - Espárrago - Pimentón'),
('SNOW YAKI PANKO', 6100, 'Rolls - Cream', 'Pollo Panko - Palta - Cebollín'),
('SNOW TROPICAL', 6400, 'Rolls - Cream', 'Camarón Panko - Mango'),
('CREAM CHILI', 6000, 'Rolls - Cream', 'Salmón - Coco/Merken - Pimentón - Cebollín'),
('SNOW MIX', 6000, 'Rolls - Cream', 'Camarón - Salmón - Palta - Cebollín'),
('CREAM SMOKE', 5700, 'Rolls - Cream', 'Salmón Ahumado - Palta - Cebollín'),
('CREAM LIKE', 5500, 'Rolls - Cream', 'Masago - Palmito - Palta'),
('CREAM VEGETAL', 5000, 'Rolls - Cream', 'Palmito - Espárrago - Cebollín'),
('CREAM VEGETAL PANKO', 5100, 'Rolls - Cream', 'Cebollín Panko - Palta - Pimentón'),
('TUNA CREAM', 6100, 'Rolls - Cream', 'Atún - Palta - Palmito'),
('CREAM ACEVICHADO', 8900, 'Rolls - Cream', 'Palta - Espárrago - Palmito'),

-- SAKE ROLLS
('SAKE KANI', 5900, 'Rolls - Sake', 'Kanikama - Palta - Ciboulette'),
('SAKE EBI ROLL', 6400, 'Rolls - Sake', 'Camarón - Queso Cream - Masago'),
('SAKE TAKO', 7000, 'Rolls - Sake', 'Pulpo - Queso Cream - Cebollín'),
('GARDEN SAKE', 5800, 'Rolls - Sake', 'Palmito - Espárrago - Palta'),
('SAKE SMOKE', 6500, 'Rolls - Sake', 'Salmón Ahumado - Queso Cream - Palta'),
('SAKE EBI PANKO', 6900, 'Rolls - Sake', 'Camarón Panko - Queso Cream - Cebollín'),
('SAKE ACEVICHADO', 9200, 'Rolls - Sake', 'Queso Cream - Palta - Palmito'),
('SAKE VEGETAL PANKO', 5900, 'Rolls - Sake', 'Cebollín Panko - Queso Cream - Espárrago'),

-- SIN ARROZ
('Sin Arroz Opción 1', 7900, 'Sin Arroz', 'Salmón - Camarón - Queso Cream - Cebollín - Choclo Baby Panko'),
('Sin Arroz Opción 2', 7500, 'Sin Arroz', 'Pollo Panko - Palta - Palmito - Cebollín - Pimentón'),
('Sin Arroz Opción 3', 8000, 'Sin Arroz', 'Camarón Panko - Queso Cream - Masago - Palta - Cebollín'),
('Sin Arroz Opción 4', 7600, 'Sin Arroz', 'Pollo Teriyaki - Palta - Nueces - Almendras - Queso Cream - Cebollín'),
('Sin Arroz Opción 5', 8100, 'Sin Arroz', 'Camarón - Salmón - Queso Cream - Palta - Cebollín'),

-- HOSOMAKI
('HOSO KANI', 3200, 'Hosomaki', 'Kanikama - Palta'),
('HOSO CHICKEN', 3600, 'Hosomaki', 'Pollo Teriyaki - Queso Cream - Cebollín'),
('HOSO SAKE', 3900, 'Hosomaki', 'Salmón - Queso Cream'),
('HOSO EBI', 3700, 'Hosomaki', 'Camarón - Queso Cream - Ciboulette'),
('HOSO TAKO', 4400, 'Hosomaki', 'Pulpo - Queso Cream - Cebollín'),
('HOSO SMOKE', 3800, 'Hosomaki', 'Salmón Ahumado - Palta - Ciboulette'),
('HOSO VEGETAL', 3100, 'Hosomaki', 'Palmito - Espárrago'),
('HOSO TON', 4100, 'Hosomaki', 'Atún - Palta'),

-- FUTOMAKI
('FUTO KANI', 5800, 'Futomaki', 'Kanikama - Palta - Pepino - Masago - Cebollín'),
('FUTO CHICKEN', 6500, 'Futomaki', 'Pollo Teriyaki - Queso Cream - Palta - Pimentón - Ciboulette'),
('FUTO SAKE', 6800, 'Futomaki', 'Salmón - Palmito - Palta - Cebollín - Pimentón'),
('FUTO EBI', 6600, 'Futomaki', 'Camarón - Queso Cream - Masago - Palta - Ciboulette'),
('FUTO TAKO', 6900, 'Futomaki', 'Pulpo - Queso Cream - Palta - Cebollín - Pimentón'),
('FUTO MIX', 7000, 'Futomaki', 'Salmón - Camarón - Palta - Queso Cream - Cebollín'),
('FUTO ACEVICHADO', 9000, 'Futomaki', 'Queso Cream - Masago - Palta - Palmito'),
('FUTO SMOKE', 6400, 'Futomaki', 'Salmón Ahumado - Palta - Pimentón - Ciboulette - Espárrago'),
('FUTO VEGETAL PANKO', 5700, 'Futomaki', 'Cebollín Panko - Queso Cream - Espárrago - Pimentón - Ciboulette'),

-- SPECIAL ROLLS
('LIKE EBI TEMPURA', 5800, 'Special Rolls', 'Camarón - Queso Cream - Ciboulette'),
('LIKE URA EBI', 6300, 'Special Rolls', 'Camarón Tempura - Queso Cream - Pimentón'),
('HOSO CHICKEN PANKO', 6000, 'Special Rolls', 'Pollo Teriyaki - Queso Cream - Cebollín'),
('MAKI GRAY ROLL', 4500, 'Special Rolls', 'Queso Cream - Palta - Pepino'),
('ARMY SMOKE ROLL', 5300, 'Special Rolls', 'Salmón Ahumado - Queso Cream - Palta'),
('LIKE EBI AVO', 6200, 'Special Rolls', 'Camarón - Queso Cream - Palmito'),
('HOSO NUSS', 4000, 'Special Rolls', 'Queso Cream - Nueces/Almendra'),
('LIKE AVO CHICKEN', 6500, 'Special Rolls', 'Pollo Teriyaki - Queso Cream - Palmito'),
('GREEN TONNO FURAI', 6200, 'Special Rolls', 'Atún Panko - Queso Cream'),
('EBI RAINBOW', 8000, 'Special Rolls', 'Camarón Panko - Queso Cream - Cebollín'),
('SAKE EBI GRILL', 6500, 'Special Rolls', 'Camarón - Queso Cream - Cebollín'),
('COCO TEMPURA', 6500, 'Special Rolls', 'Salmón - Queso Cream - Pimentón'),
('GREEN MIX', 6400, 'Special Rolls', 'Salmón - Camarón - Queso Cream'),
('CHICKEN CRISPY NUSS', 7400, 'Special Rolls', 'Pollo Teriyaki - Queso Cream Panko - Ciboulette'),

-- ARROZ GOHAN
('Gohan Mixto', 6990, 'Arroz Gohan', NULL),
('Gohan Mixto Panko', 7990, 'Arroz Gohan', NULL),
('Gohan Pollo', 6990, 'Arroz Gohan', NULL),
('Gohan Pollo Panko', 7990, 'Arroz Gohan', NULL),
('Gohan Vegetal', 5490, 'Arroz Gohan', NULL),

-- HANDROLL
('Handroll Pollo', 4500, 'Handroll', 'Pollo - Queso - Cebolllín'),
('Handroll Camarón', 4800, 'Handroll', 'Camarón - Queso - Cebolllín'),
('Handroll Vegetal', 4300, 'Handroll', 'Verduras - Palmito - Palta - Cebollín'),

-- SUSHI BURGER
('Burger Pollo', 7490, 'Sushi Burger', 'Pollo - Queso - Palta - Cebolllín - Panko'),
('Burger Camarón', 7990, 'Sushi Burger', 'Camarón - Queso - Palta - Cebolllín - Panko'),
('Burger Salmón', 8490, 'Sushi Burger', 'Salmón - Queso - Palta - Cebolllín - Panko'),

-- SASHIMIS
('Sashimi de Salmón (3 Cortes)', 2800, 'Sashimis', NULL),
('Sashimi de Salmón (6 Cortes)', 5000, 'Sashimis', NULL),
('Sashimi de Salmón (12 Cortes)', 9000, 'Sashimis', NULL),
('Sashimi de Pulpo (3 Cortes)', 3400, 'Sashimis', NULL),
('Sashimi de Pulpo (6 Cortes)', 6000, 'Sashimis', NULL),
('Sashimi de Pulpo (12 Cortes)', 10500, 'Sashimis', NULL),

-- NIGIRIS
('Nigiri de Salmón (1 Unidad)', 1000, 'Nigiris', NULL),
('Nigiri de Camarón (1 Unidad)', 1000, 'Nigiris', NULL),
('Nigiri de Kanikama (1 Unidad)', 900, 'Nigiris', NULL),

-- NIGIRIS CRISPY
('Nigiris Crispy Pollo (4 Unidades)', 4790, 'Nigiris Crispy', 'Arroz - Pollo - Queso Cream - Cebollín'),
('Nigiris Crispy Camarón (4 Unidades)', 4990, 'Nigiris Crispy', 'Arroz - Camarón - Queso Cream - Cebollín'),

-- SNACKS
('Salmón Panko (3 Unidades)', 3000, 'Snack Tempurizados', NULL),
('Salmón Panko (6 Unidades)', 5500, 'Snack Tempurizados', NULL),
('Salmón Panko (12 Unidades)', 9900, 'Snack Tempurizados', NULL),
('Ebi Temp. (3 Unidades)', 2900, 'Snack Tempurizados', NULL),
('Ebi Temp. (6 Unidades)', 5400, 'Snack Tempurizados', NULL),
('Ebi Temp. (12 Unidades)', 9800, 'Snack Tempurizados', NULL),
('Pollo Panko (3 Unidades)', 2800, 'Snack Tempurizados', NULL),
('Pollo Panko (6 Unidades)', 4900, 'Snack Tempurizados', NULL),
('Pollo Panko (12 Unidades)', 9000, 'Snack Tempurizados', NULL),
('Verduras Temp. (3 Unidades)', 2000, 'Snack Tempurizados', NULL),
('Verduras Temp. (6 Unidades)', 3600, 'Snack Tempurizados', NULL),
('Verduras Temp. (12 Unidades)', 6800, 'Snack Tempurizados', NULL),

-- SALSAS Y EXTRAS
('Envoltura Ciboulette', 500, 'Salsas y Extras', NULL),
('Palitos', 150, 'Salsas y Extras', NULL),
('Wasabi', 400, 'Salsas y Extras', NULL),
('Sriracha', 500, 'Salsas y Extras', NULL),
('Hoja de arroz', 500, 'Salsas y Extras', NULL),
('Ayuda Palitos', 400, 'Salsas y Extras', NULL),
('Jengibre', 400, 'Salsas y Extras', NULL),
('Salsa Unagui', 900, 'Salsas y Extras', NULL),
('Salsa Soya', 500, 'Salsas y Extras', NULL),

-- BEBIDAS
('Coca-Cola Original 1.5L', 3000, 'Bebidas', '1.5 Litros'),
('Coca-Cola Zero 1.5L', 3000, 'Bebidas', '1.5 Litros');
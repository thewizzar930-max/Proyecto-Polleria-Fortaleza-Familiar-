--SELECT * FROM [dbo].[Productos]
--SELECT * FROM [dbo].[Categorias]
--SELECT * FROM [dbo].[Proveedores]
--SELECT * FROM [dbo].[Ventas]
--SELECT * FROM [dbo].[DetalleVenta]
--SELECT * FROM [dbo].[Compras]
--SELECT * FROM [dbo].[DetalleCompra]
--select * from [dbo].[Usuarios]
--select * from [dbo].[HistorialContrasenas]
--select * from [dbo].[HistorialAccesos]


-- Usuarios
INSERT INTO dbo.Usuarios (NombreUsuario, NombreCompleto, Contrasena, Rol, Activo)
VALUES
    ('admin',      'Administrador General',  'Admin123*',      'Administrador', 1),
    ('gerente',    'Gerente General',        'Gerente123*',    'Administrador', 1),
    ('cajero1',    'Cajero Turno Mañana',    'Cajero123*',     'Usuario',       1),
    ('cajero2',    'Cajero Turno Tarde',     'Cajero123*',     'Usuario',       1),
    ('mozo1',      'Mozo Principal',         'Mozo123*',       'Usuario',       1),
    ('cocina1',    'Jefe de Cocina',         'Cocina123*',     'Usuario',       1),
    ('supervisor', 'Supervisor de Sala',     'Supervisor123*', 'Usuario',       1),
    ('almacen',    'Encargado de Almacén',   'Almacen123*',    'Usuario',       1),
    ('delivery1',  'Repartidor Delivery 1',  'Delivery123*',   'Usuario',       1),
    ('conta',      'Contador',               'Conta123*',      'Usuario',       1);
GO

-- ========================
-- BEBIDAS (ID = 2)

-- ========================
INSERT INTO [dbo].[Productos]
VALUES ('Inka Kola 1.5L',          'Bebidas', 4.50, 100, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Pepsi',              'Bebidas', 2.50, 500, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Coca Cola 1.5L',          'Bebidas', 3.00, 300, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Fanta Naranja 2L',      'Bebidas', 2.80, 150, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Sprite 1.5 L',             'Bebidas', 2.70, 180, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Agua Cielo 3 L',         'Bebidas', 1.50, 400, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Agua San Luis 600mL',      'Bebidas', 1.40, 350, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Red Bull',           'Bebidas', 6.50, 80,  'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Volt',               'Bebidas', 4.20, 90,  'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Powerade',           'Bebidas', 4.00, 110, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Gatorade Limón',     'Bebidas', 3.80, 120, 'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Chicha Morada',      'Bebidas', 3.50, 70,  'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Limonada',           'Bebidas', 2.20, 60,  'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Té Helado Durazno',  'Bebidas', 2.90, 95,  'Activo');

INSERT INTO [dbo].[Productos]
VALUES ('Café Frío',          'Bebidas', 3.20, 50,  'Activo');


-- ==============
-- ENTRADAS
-- ==============
INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Nuggets (6 unid)',       'Entradas', 10.00, 30, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Salchipapas clásica',       'Entradas', 12.00, 25, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Tequeños de queso (6 unid)','Entradas', 15.00, 20, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Ensalada clásica',          'Entradas',  7.00, 25, 'Activo');

-- ========================
-- POLLO
-- ========================
INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Pollo a la brasa 1/4',   'Pollo', 22.00, 40, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Pollo a la brasa 1/2',      'Pollo', 38.00, 35, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Pollo entero + papas',      'Pollo', 70.00, 20, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('1/4 pollo + ensalada',      'Pollo', 25.00, 25, 'Activo');


-- ==========
-- POSTRES
-- ==========
INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Mazamorra morada',          'Postres', 5.50, 25, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Arroz con leche',           'Postres', 5.50, 25, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Helado de vainilla',        'Postres', 6.00, 30, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Flan de caramelo',          'Postres', 6.50, 20, 'Activo');


-- ============
-- GOLOSINAS
-- ============
INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Chupetín',                  'Golosina', 1.00, 100, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Chocolate Sublime',         'Golosina', 2.50, 60,  'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Galleta Oreo',              'Golosina', 2.00, 50,  'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Caramelo surtido',          'Golosina', 0.50, 200, 'Activo');

-- ============
-- COMPLEMENTOS
-- ============
INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Papa frita porción',                  'Complementos', 5.00, 100, 'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Porción de arroz',         'Complementos', 5.50, 60,  'Activo');

INSERT INTO dbo.Productos (Nombre, Categoria, Precio, Stock, Estado)
VALUES ('Porcion de choclo',              'Complementos', 2300, 50,  'Activo');


/* =========================================================
   2. PROVEEDORES
   ========================================================= */

DECLARE @ProvAvicola INT,
        @ProvBebidas INT,
        @ProvPapas   INT;

IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE Nombre = N'Distribuidora Avícola San Juan')
BEGIN
    INSERT INTO Proveedores (Nombre, RUC, Telefono, Direccion)
    VALUES (N'Distribuidora Avícola San Juan', '20123456789', '987654321',
            N'Av. Los Pollos 123 - San Juan');
END;

IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE Nombre = N'Embotelladora Lima')
BEGIN
    INSERT INTO Proveedores (Nombre, RUC, Telefono, Direccion)
    VALUES (N'Embotelladora Lima', '20987654321', '912345678',
            N'Av. Las Bebidas 456 - Lima');
END;

IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE Nombre = N'Proveedor de Papas Andinas')
BEGIN
    INSERT INTO Proveedores (Nombre, RUC, Telefono, Direccion)
    VALUES (N'Proveedor de Papas Andinas', '20456789012', '923456789',
            N'Jr. Los Tubérculos 789 - Huaral');
END;

SELECT
    @ProvAvicola = ID
FROM Proveedores
WHERE Nombre = N'Distribuidora Avícola San Juan';

SELECT
    @ProvBebidas = ID
FROM Proveedores
WHERE Nombre = N'Embotelladora Lima';

SELECT
    @ProvPapas = ID
FROM Proveedores
WHERE Nombre = N'Proveedor de Papas Andinas';
GO



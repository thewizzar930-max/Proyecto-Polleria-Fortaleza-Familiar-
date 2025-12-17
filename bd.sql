-- ==============================================
-- Script para crear la base de datos 'polleria_db' y sus tablas
-- ==============================================

-- --- Creación y selección de la Base de Datos ---
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'polleria_db')
BEGIN
    CREATE DATABASE polleria_db;
    PRINT 'Base de datos [polleria_db] creada exitosamente.'
END
ELSE
BEGIN
    PRINT 'La base de datos [polleria_db] ya existe.'
END
GO

-- Establecer el contexto a nuestra base de datos
USE polleria_db;
GO


-- --- Tabla de Productos ---
-- Almacena todos los productos que vende la pollería.

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Productos' and xtype='U')
BEGIN
    CREATE TABLE Productos (
        ID INT PRIMARY KEY IDENTITY(1,1),       -- Identificador único para cada producto (se autoincrementa)
        Nombre NVARCHAR(100) NOT NULL,          -- Nombre del producto, por ejemplo: '1/4 de Pollo a la Brasa'
        Categoria NVARCHAR(50),                 -- Categoría a la que pertenece, por ejemplo: 'Platos Principales', 'Bebidas'
        Precio DECIMAL(10, 2) NOT NULL,         -- Precio de venta al público
        Stock INT NOT NULL DEFAULT 0,           -- Cantidad disponible en inventario
        Estado NVARCHAR(20) NOT NULL DEFAULT 'Activo' -- Estado del producto: 'Activo' o 'Inactivo'
    );
    PRINT 'Tabla [Productos] creada exitosamente.'
END
ELSE
BEGIN
    PRINT 'La tabla [Productos] ya existe.'
END
GO

-- --- Tabla de Categorías ---
-- Almacena las diferentes categorías para los productos (ej: Bebidas, Platos, Postres).
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categorias' and xtype='U')
BEGIN
    CREATE TABLE Categorias (
        ID INT PRIMARY KEY IDENTITY(1,1),
        Nombre NVARCHAR(50) NOT NULL UNIQUE
    );
    PRINT 'Tabla [Categorias] creada exitosamente.'

    -- Insertamos algunas categorías de ejemplo para empezar
    INSERT INTO Categorias (Nombre) VALUES ('Pollo');
    INSERT INTO Categorias (Nombre) VALUES ('Bebidas');
    INSERT INTO Categorias (Nombre) VALUES ('Postres');
    INSERT INTO Categorias (Nombre) VALUES ('Entradas');
    INSERT INTO Categorias (Nombre) VALUES ('Complementos');
    INSERT INTO Categorias (Nombre) VALUES ('Golosina');
    PRINT 'Categorías de ejemplo insertadas.'
END
ELSE
BEGIN
    PRINT 'La tabla [Categorias] ya existe.'
END
GO

-- --- Tabla de Proveedores ---
-- Almacena la información de los proveedores de insumos.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Proveedores' and xtype='U')
BEGIN
    CREATE TABLE Proveedores (
        ID INT PRIMARY KEY IDENTITY(1,1),
        Nombre NVARCHAR(100) NOT NULL,
        RUC NVARCHAR(11) UNIQUE, -- El RUC debe ser único
        Telefono NVARCHAR(20),
        Direccion NVARCHAR(255),
        Estado NVARCHAR(20) NOT NULL DEFAULT 'Activo'
    );
    PRINT 'Tabla [Proveedores] creada exitosamente.'
END
ELSE
BEGIN
    PRINT 'La tabla [Proveedores] ya existe.'
END
GO

-- --- Tabla de Ventas ---
-- Almacena la cabecera de cada transacción de venta.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Ventas' and xtype='U')
BEGIN
    CREATE TABLE Ventas (
        ID INT PRIMARY KEY IDENTITY(1,1),
        FechaVenta DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha y hora en que se realiza la venta
        TotalVenta DECIMAL(10, 2) NOT NULL,
        Estado NVARCHAR(20) NOT NULL DEFAULT 'Completada' -- 'Completada', 'Anulada'
    );
    PRINT 'Tabla [Ventas] creada exitosamente.'
END
ELSE
BEGIN
    PRINT 'La tabla [Ventas] ya existe.'
END
GO

-- --- Tabla de Detalle de Venta ---
-- Almacena cada producto vendido dentro de una transacción.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DetalleVenta' and xtype='U')
BEGIN
    CREATE TABLE DetalleVenta (
        ID INT PRIMARY KEY IDENTITY(1,1),
        VentaID INT NOT NULL,
        ProductoID INT NOT NULL,
        Cantidad INT NOT NULL,
        PrecioUnitario DECIMAL(10, 2) NOT NULL, -- Precio al momento de la venta
        Subtotal DECIMAL(10, 2) NOT NULL,
        CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (VentaID) REFERENCES Ventas(ID),
        CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ID)
    );
    PRINT 'Tabla [DetalleVenta] creada exitosamente.'
END
ELSE
BEGIN
    PRINT 'La tabla [DetalleVenta] ya existe.'
END
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Tabla de Usuarios (si aún no existe)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Usuarios' and xtype='U')
BEGIN
    CREATE TABLE dbo.Usuarios (
        ID             INT IDENTITY(1,1) PRIMARY KEY,
        NombreUsuario  NVARCHAR(50)   NOT NULL UNIQUE,
        NombreCompleto NVARCHAR(100)  NOT NULL,
        Contrasena     NVARCHAR(255)  NOT NULL,
        Rol            NVARCHAR(20)   NOT NULL DEFAULT 'Usuario',  -- 'Administrador' / 'Usuario'
        Activo         BIT            NOT NULL DEFAULT 1,          -- 1 = Activo, 0 = Bloqueado
        FechaCreacion  DATETIME       NOT NULL DEFAULT GETDATE()
    );

END
ELSE
BEGIN
    PRINT 'La tabla [Usuarios] ya existe.';
END
GO

-- Historial de contraseñas
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HistorialContrasenas' and xtype='U')
BEGIN
    CREATE TABLE HistorialContrasenas (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        UsuarioID           INT NOT NULL,
        ContrasenaAnterior  NVARCHAR(255) NOT NULL,
        FechaCambio         DATETIME NOT NULL DEFAULT GETDATE(),
        Motivo              NVARCHAR(100) NULL,
        CONSTRAINT FK_HistorialContrasenas_Usuario
            FOREIGN KEY (UsuarioID) REFERENCES Usuarios(ID)
    );
END
GO

-- Historial de Accesos
IF OBJECT_ID('dbo.HistorialAccesos', 'U') IS NOT NULL
    DROP TABLE dbo.HistorialAccesos;
GO

CREATE TABLE dbo.HistorialAccesos (
    ID          INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID   INT       NOT NULL,
    FechaAcceso DATETIME  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_HistorialAccesos_Usuarios
        FOREIGN KEY (UsuarioID) REFERENCES dbo.Usuarios(ID)
);
GO


USE polleria_db;
GO

-- ======================================
-- TABLA: Compras (cabecera)
-- ======================================
IF OBJECT_ID('dbo.Compras', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Compras
    (
        ID           INT IDENTITY(1,1) NOT NULL PRIMARY KEY,  -- ID de la compra
        ProveedorID  INT NOT NULL,                            -- FK a Proveedores.ID
        FechaCompra  DATETIME NOT NULL 
            CONSTRAINT DF_Compras_FechaCompra DEFAULT (GETDATE()),
        TotalCompra  DECIMAL(10,2) NOT NULL,                  -- Monto total de la compra
        Estado       VARCHAR(20) NOT NULL 
            CONSTRAINT DF_Compras_Estado DEFAULT ('Registrada'),
        Observaciones NVARCHAR(255) NULL
    );
END;
GO

-- FK a Proveedores (si aún no existe)
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_Compras_Proveedores'
)
BEGIN
    ALTER TABLE dbo.Compras
    ADD CONSTRAINT FK_Compras_Proveedores
        FOREIGN KEY (ProveedorID)
        REFERENCES dbo.Proveedores(ID);
END;
GO

-- Índice por Proveedor y Fecha (para consultas/reportes)
IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_Compras_Proveedor_Fecha'
      AND object_id = OBJECT_ID('dbo.Compras')
)
BEGIN
    CREATE INDEX IX_Compras_Proveedor_Fecha
        ON dbo.Compras(ProveedorID, FechaCompra);
END;
GO

-- ======================================
-- TABLA: DetalleCompra (detalle por producto)
-- ======================================
IF OBJECT_ID('dbo.DetalleCompra', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DetalleCompra
    (
        ID            INT IDENTITY(1,1) NOT NULL PRIMARY KEY,   -- ID del detalle
        CompraID      INT NOT NULL,                             -- FK a Compras.ID
        ProductoID    INT NOT NULL,                             -- FK a Productos.ID
        Cantidad      INT NOT NULL,                             -- Unidades compradas
        PrecioUnitario DECIMAL(10,2) NOT NULL,                  -- Precio unitario de compra
        Subtotal      DECIMAL(10,2) NOT NULL                    -- Cantidad * PrecioUnitario
    );
END;
GO

-- FK a Compras
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_DetalleCompra_Compras'
)
BEGIN
    ALTER TABLE dbo.DetalleCompra
    ADD CONSTRAINT FK_DetalleCompra_Compras
        FOREIGN KEY (CompraID)
        REFERENCES dbo.Compras(ID);
END;
GO

-- FK a Productos
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_DetalleCompra_Productos'
)
BEGIN
    ALTER TABLE dbo.DetalleCompra
    ADD CONSTRAINT FK_DetalleCompra_Productos
        FOREIGN KEY (ProductoID)
        REFERENCES dbo.Productos(ID);
END;
GO

-- Índices para acelerar consultas
IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_DetalleCompra_CompraID'
      AND object_id = OBJECT_ID('dbo.DetalleCompra')
)
BEGIN
    CREATE INDEX IX_DetalleCompra_CompraID
        ON dbo.DetalleCompra(CompraID);
END;
GO

IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_DetalleCompra_ProductoID'
      AND object_id = OBJECT_ID('dbo.DetalleCompra')
)
BEGIN
    CREATE INDEX IX_DetalleCompra_ProductoID
        ON dbo.DetalleCompra(ProductoID);
END;
GO

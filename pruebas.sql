IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL
    DROP TABLE dbo.Usuarios;
GO

CREATE TABLE dbo.Usuarios (
    ID             INT IDENTITY(1,1) PRIMARY KEY,
    NombreUsuario  NVARCHAR(50)   NOT NULL UNIQUE,
    NombreCompleto NVARCHAR(100)  NOT NULL,
    Contrasena     NVARCHAR(255)  NOT NULL,
    Rol            NVARCHAR(20)   NOT NULL DEFAULT 'Usuario',  -- 'Administrador' / 'Usuario'
    Activo         BIT            NOT NULL DEFAULT 1,          -- 1 = Activo, 0 = Bloqueado
    FechaCreacion  DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

IF OBJECT_ID('dbo.HistorialContrasenas', 'U') IS NOT NULL
    DROP TABLE dbo.HistorialContrasenas;
GO

CREATE TABLE dbo.HistorialContrasenas (
    ID                 INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID          INT            NOT NULL,
    ContrasenaAnterior NVARCHAR(255)  NOT NULL,
    FechaCambio        DATETIME       NOT NULL DEFAULT GETDATE(),
    Motivo             NVARCHAR(120)  NULL,
    CONSTRAINT FK_HistorialContrasenas_Usuarios
        FOREIGN KEY (UsuarioID) REFERENCES dbo.Usuarios(ID)
);
GO

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

--- Consulta para saber las llaves Foraneas
SELECT 
    fk.name        AS NombreFK,
    OBJECT_NAME(fk.parent_object_id) AS TablaHija,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnaHija,
    OBJECT_NAME(fk.referenced_object_id) AS TablaPadre,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ColumnaPadre
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE fk.referenced_object_id = OBJECT_ID('dbo.Usuarios');

SELECT * FROM sysobjects WHERE name='HistorialContrasenas' and xtype='U'

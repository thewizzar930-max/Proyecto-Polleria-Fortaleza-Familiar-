USE polleria_db;
GO

SET NOCOUNT ON;
GO

/* =========================================================
   1. OBTENER IDs DE PRODUCTOS Y PROVEEDORES
   ========================================================= */

DECLARE @ProdPolloCuarto INT,
        @ProdPolloMedio INT,
        @ProdInka       INT,
        @ProdCoca       INT,
        @ProdPapa       INT;

DECLARE @ProvAvicola INT,
        @ProvBebidas INT,
        @ProvPapas   INT;

SELECT @ProdPolloCuarto = ID FROM Productos WHERE Nombre = N'Pollo a la brasa 1/4';
SELECT @ProdPolloMedio  = ID FROM Productos WHERE Nombre = N'Pollo a la brasa 1/2';
SELECT @ProdInka        = ID FROM Productos WHERE Nombre = N'Inka Kola 1.5L';
SELECT @ProdCoca        = ID FROM Productos WHERE Nombre = N'Coca Cola 1.5L';
SELECT @ProdPapa        = ID FROM Productos WHERE Nombre = N'Papa frita porción';

SELECT @ProvAvicola = ID FROM Proveedores WHERE Nombre = N'Distribuidora Avícola San Juan';
SELECT @ProvBebidas = ID FROM Proveedores WHERE Nombre = N'Embotelladora Lima';
SELECT @ProvPapas   = ID FROM Proveedores WHERE Nombre = N'Proveedor de Papas Andinas';

IF @ProdPolloCuarto IS NULL OR @ProdPolloMedio IS NULL OR
   @ProdInka IS NULL OR @ProdCoca IS NULL OR @ProdPapa IS NULL
BEGIN
    RAISERROR('Faltan productos base (pollo/bebidas/papas). Ejecuta primero el script de productos.', 16, 1);
    RETURN;
END;

IF @ProvAvicola IS NULL OR @ProvBebidas IS NULL OR @ProvPapas IS NULL
BEGIN
    RAISERROR('Faltan proveedores base. Ejecuta primero el script de proveedores.', 16, 1);
    RETURN;
END;

/* =========================================================
   2. PRECIOS DE VENTA (tomados de Productos) Y COSTO COMPRA
   ========================================================= */

DECLARE @PrecioPolloCuartoVenta DECIMAL(10,2),
        @PrecioPolloMedioVenta  DECIMAL(10,2),
        @PrecioInkaVenta        DECIMAL(10,2),
        @PrecioCocaVenta        DECIMAL(10,2),
        @PrecioPapaVenta        DECIMAL(10,2);

SELECT @PrecioPolloCuartoVenta = Precio FROM Productos WHERE ID = @ProdPolloCuarto;
SELECT @PrecioPolloMedioVenta  = Precio FROM Productos WHERE ID = @ProdPolloMedio;
SELECT @PrecioInkaVenta        = Precio FROM Productos WHERE ID = @ProdInka;
SELECT @PrecioCocaVenta        = Precio FROM Productos WHERE ID = @ProdCoca;
SELECT @PrecioPapaVenta        = Precio FROM Productos WHERE ID = @ProdPapa;

-- Costos de compra ~ 60% del precio de venta
DECLARE @CostoPolloCuarto DECIMAL(10,2) = @PrecioPolloCuartoVenta * 0.6,
        @CostoPolloMedio  DECIMAL(10,2) = @PrecioPolloMedioVenta  * 0.6,
        @CostoInka        DECIMAL(10,2) = @PrecioInkaVenta        * 0.6,
        @CostoCoca        DECIMAL(10,2) = @PrecioCocaVenta        * 0.6,
        @CostoPapa        DECIMAL(10,2) = @PrecioPapaVenta        * 0.6;

/* =========================================================
   3. SIMULACIÓN DE VENTAS Y COMPRAS (2024-01-01 a 2025-10-31)
   ========================================================= */

DECLARE @Fecha DATE = CONVERT(date, '20240101', 112);
DECLARE @FechaFin DATE = CONVERT(date, '20251208', 112);

DECLARE @NumVentasDia INT;
DECLARE @i INT;

DECLARE @VentaID INT;
DECLARE @FechaHora DATETIME;

DECLARE @r INT;

DECLARE @qPolloCuarto INT,
        @qPolloMedio  INT,
        @qInka        INT,
        @qCoca        INT,
        @qPapa        INT;

DECLARE @SubPolloCuarto DECIMAL(10,2),
        @SubPolloMedio  DECIMAL(10,2),
        @SubInka        DECIMAL(10,2),
        @SubCoca        DECIMAL(10,2),
        @SubPapa        DECIMAL(10,2),
        @TotalVenta     DECIMAL(10,2);

DECLARE @CompraID INT;
DECLARE @TotalCompra DECIMAL(10,2);

WHILE @Fecha <= @FechaFin
BEGIN
    /* ===========================
       3.1 VENTAS DIARIAS
       =========================== */

    -- Número de ventas del día: 5 a 15
    SET @r = ABS(CHECKSUM(NEWID()));
    SET @NumVentasDia = 5 + (@r % 11);  -- 5..15

    SET @i = 1;
    WHILE @i <= @NumVentasDia
    BEGIN
        -- Hora aleatoria entre 11:00 y 22:00 (11 horas = 660 minutos)
        SET @r = ABS(CHECKSUM(NEWID()));
        DECLARE @Minutos INT = @r % 660;
        SET @FechaHora = DATEADD(MINUTE, @Minutos, DATEADD(HOUR, 11, CAST(@Fecha AS DATETIME)));

        -- Cantidades por producto (0..3). Aseguramos al menos 1 producto.
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPolloCuarto = @r % 3;   -- 0..2
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPolloMedio  = @r % 3;
        SET @r = ABS(CHECKSUM(NEWID())); SET @qInka        = @r % 3;
        SET @r = ABS(CHECKSUM(NEWID())); SET @qCoca        = @r % 3;
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPapa        = @r % 4;   -- 0..3

        IF (@qPolloCuarto + @qPolloMedio + @qInka + @qCoca + @qPapa) = 0
            SET @qPolloCuarto = 1;  -- al menos algo se vende

        -- Subtotales
        SET @SubPolloCuarto = @qPolloCuarto * @PrecioPolloCuartoVenta;
        SET @SubPolloMedio  = @qPolloMedio  * @PrecioPolloMedioVenta;
        SET @SubInka        = @qInka        * @PrecioInkaVenta;
        SET @SubCoca        = @qCoca        * @PrecioCocaVenta;
        SET @SubPapa        = @qPapa        * @PrecioPapaVenta;

        SET @TotalVenta = @SubPolloCuarto + @SubPolloMedio + @SubInka + @SubCoca + @SubPapa;

        -- Insertar cabecera de venta
        INSERT INTO Ventas (FechaVenta, TotalVenta)
        VALUES (@FechaHora, @TotalVenta);

        SET @VentaID = SCOPE_IDENTITY();

        -- Insertar detalle (solo productos con cantidad > 0)
        IF @qPolloCuarto > 0
            INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
            VALUES (@VentaID, @ProdPolloCuarto, @qPolloCuarto, @PrecioPolloCuartoVenta, @SubPolloCuarto);

        IF @qPolloMedio > 0
            INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
            VALUES (@VentaID, @ProdPolloMedio, @qPolloMedio, @PrecioPolloMedioVenta, @SubPolloMedio);

        IF @qInka > 0
            INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
            VALUES (@VentaID, @ProdInka, @qInka, @PrecioInkaVenta, @SubInka);

        IF @qCoca > 0
            INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
            VALUES (@VentaID, @ProdCoca, @qCoca, @PrecioCocaVenta, @SubCoca);

        IF @qPapa > 0
            INSERT INTO DetalleVenta (VentaID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
            VALUES (@VentaID, @ProdPapa, @qPapa, @PrecioPapaVenta, @SubPapa);

        SET @i = @i + 1;
    END;

    /* ===========================
       3.2 COMPRAS PERIÓDICAS
       =========================== */
    -- Días 1, 11 y 21 de cada mes: 2 compras (pollos+papas, bebidas)
    IF DAY(@Fecha) IN (1, 11, 21)
    BEGIN
        /* --- Compra de pollo + papas --- */
        -- Cantidades (mayores para compra)
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPolloCuarto = 20 + (@r % 31);  -- 20..50
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPolloMedio  = 10 + (@r % 21);  -- 10..30
        SET @r = ABS(CHECKSUM(NEWID())); SET @qPapa        = 50 + (@r % 51);  -- 50..100

        SET @SubPolloCuarto = @qPolloCuarto * @CostoPolloCuarto;
        SET @SubPolloMedio  = @qPolloMedio  * @CostoPolloMedio;
        SET @SubPapa        = @qPapa        * @CostoPapa;

        SET @TotalCompra = @SubPolloCuarto + @SubPolloMedio + @SubPapa;

        INSERT INTO Compras (ProveedorID, FechaCompra, TotalCompra, Observaciones)
        VALUES (@ProvAvicola, @Fecha, @TotalCompra, N'Compra simulada de pollo y papas');

        SET @CompraID = SCOPE_IDENTITY();

        INSERT INTO DetalleCompra (CompraID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
        VALUES
            (@CompraID, @ProdPolloCuarto, @qPolloCuarto, @CostoPolloCuarto, @SubPolloCuarto),
            (@CompraID, @ProdPolloMedio,  @qPolloMedio,  @CostoPolloMedio,  @SubPolloMedio),
            (@CompraID, @ProdPapa,        @qPapa,        @CostoPapa,        @SubPapa);

        /* --- Compra de bebidas --- */
        SET @r = ABS(CHECKSUM(NEWID())); SET @qInka = 30 + (@r % 41);  -- 30..70
        SET @r = ABS(CHECKSUM(NEWID())); SET @qCoca = 30 + (@r % 41);  -- 30..70

        SET @SubInka = @qInka * @CostoInka;
        SET @SubCoca = @qCoca * @CostoCoca;

        SET @TotalCompra = @SubInka + @SubCoca;

        INSERT INTO Compras (ProveedorID, FechaCompra, TotalCompra, Observaciones)
        VALUES (@ProvBebidas, @Fecha, @TotalCompra, N'Compra simulada de bebidas');

        SET @CompraID = SCOPE_IDENTITY();

        INSERT INTO DetalleCompra (CompraID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
        VALUES
            (@CompraID, @ProdInka, @qInka, @CostoInka, @SubInka),
            (@CompraID, @ProdCoca, @qCoca, @CostoCoca, @SubCoca);
    END;

    SET @Fecha = DATEADD(DAY, 1, @Fecha);
END;

SET NOCOUNT OFF;
GO

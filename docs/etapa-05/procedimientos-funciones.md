# 1. Procedimientos y funciones almacenadas

## 1.1 Definición y objetivo
Un procedimiento almacenado es un programa SQL guardado en la base de datos que puede ejecutar varias operaciones (insertar, actualizar, validar). Una función recibe parámetros y devuelve un valor escalar o una tabla. El objetivo es centralizar la lógica de negocio en la base y no repetirla en cada consulta o aplicación.

## 1.2 Ventajas y aplicaciones
* **Reutilizan** lógica de negocio y reducen código repetido.
* **Mejoran la mantenibilidad:** una regla se cambia en un solo lugar.
* **Permiten** dar permisos de ejecución sin dar acceso directo a las tablas (ver tema 4).
* **Aplicaciones:** registrar una venta completa, calcular descuentos, emitir reportes.

## 1.3 Implementación en SQL Server Express
Se usan `CREATE FUNCTION` y `CREATE PROCEDURE` (o `CREATE OR ALTER`, disponible desde SQL Server 2016 SP1). Cada uno debe ir en su propio lote, separado con `GO`.

## 1.4 Caso aplicado al sistema
* **Función `dbo.fn_CalcularDescuentoCliente`:** suma lo comprado históricamente por un cliente. Más de $500.000 → 10%; más de $200.000 → 5%; caso contrario 0%.
* **Procedimiento `dbo.sp_RegistrarVentaCompleta`:** crea el Comprobante y la Compra, inserta el Detalle_Compra con el precio histórico, descuenta stock, aplica el descuento y registra el método y el monto del pago, todo dentro de una transacción (tema 2).

## 1.5 Script de demostración

```sql
-- Función de descuento
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (@ID_Cliente int)
RETURNS decimal(5,2)
AS
BEGIN
    DECLARE @Total decimal(18,2);

    SELECT @Total = ISNULL(SUM(dc.Subtotal), 0)
    FROM Compra c
    INNER JOIN Detalle_Compra dc ON dc.ID_Compra = c.ID_compra
    WHERE c.ID_Cliente = @ID_Cliente;

    RETURN CASE WHEN @Total > 500000 THEN 10.00
                WHEN @Total > 200000 THEN 5.00
                ELSE 0.00 END;
END;
GO

-- Uso de la función
SELECT c.ID_Cliente, p.Nombre, p.Apellido,
       dbo.fn_CalcularDescuentoCliente(c.ID_Cliente) AS Descuento_Porcentaje
FROM cliente c
INNER JOIN Persona p ON p.ID_Persona = c.ID_Persona;
GO

-- Procedimiento de venta completa (incluye transacción: ver tema 2)
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaCompleta
    @ID_Cliente   int,
    @ID_Producto  int,
    @Cantidad     int,
    @Tipo_Emision varchar(50) = 'Factura B',
    @Metodo_Pago  varchar(50) = 'Efectivo'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Stock int, @Precio decimal(10,2), @Descuento decimal(5,2),
            @Subtotal decimal(10,2), @ID_Comprobante int, @ID_Compra int,
            @ID_Metodo int;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Cantidad <= 0
            THROW 50001, 'La cantidad debe ser mayor a cero.', 1;

        -- Bloquea la fila del producto mientras dura la transacción
        SELECT @Stock = Stock_producto, @Precio = Precio_producto
        FROM Producto WITH (UPDLOCK, HOLDLOCK)
        WHERE ID_Producto = @ID_Producto;

        IF @Stock IS NULL
            THROW 50002, 'El producto no existe.', 1;
        IF @Stock < @Cantidad
            THROW 50003, 'Stock insuficiente: se revierte la operación.', 1;

        SET @Descuento = dbo.fn_CalcularDescuentoCliente(@ID_Cliente);
        SET @Subtotal  = @Cantidad * @Precio * (1 - @Descuento / 100.0);

        -- 1) Encabezado
        INSERT INTO Comprobante(fecha_emision, tipo_emision)
        VALUES (CAST(GETDATE() AS date), @Tipo_Emision);
        SET @ID_Comprobante = SCOPE_IDENTITY();

        INSERT INTO Compra(ID_Comprobante, ID_Cliente)
        VALUES (@ID_Comprobante, @ID_Cliente);
        SET @ID_Compra = SCOPE_IDENTITY();

        -- 2) Detalle con precio histórico
        INSERT INTO Detalle_Compra(ID_Compra, ID_Producto, Cantidad_Compra, Subtotal, Precio_Unitario)
        VALUES (@ID_Compra, @ID_Producto, @Cantidad, @Subtotal, @Precio);

        -- 3) Stock
        UPDATE Producto
        SET Stock_producto = Stock_producto - @Cantidad
        WHERE ID_Producto = @ID_Producto;

        -- 4) Pago
        INSERT INTO Metodo_Pago(ID_Comprobante, Descripcion)
        VALUES (@ID_Comprobante, @Metodo_Pago);
        SET @ID_Metodo = SCOPE_IDENTITY();

        INSERT INTO Detalle_Pago(ID_Metodo, ID_Comprobante, Monto)
        VALUES (@ID_Metodo, @ID_Comprobante, @Subtotal);

        COMMIT TRANSACTION;

        SELECT @ID_Compra AS ID_Compra, @Descuento AS Descuento_Aplicado, @Subtotal AS Total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;   -- reenvía el error original al llamador
    END CATCH
END;
GO
```

**Resultado esperado de la función:**
Ana (ID 1) → `0.00` y Luis (ID 2) → `10.00`, porque acumuló `$600.000`.

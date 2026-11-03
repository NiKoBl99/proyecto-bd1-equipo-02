USE SistemaVentasYservicios;
GO

-- Paso 1: Comprobar el stock inicial y el descuento actual del cliente
SELECT ID_Producto, Nombre_producto, Stock_producto 
FROM Producto WHERE ID_Producto = 1;

SELECT c.ID_Cliente, p.Nombre, dbo.fn_CalcularDescuentoCliente(c.ID_Cliente) AS Descuento
FROM cliente c INNER JOIN Persona p ON p.ID_Persona = c.ID_Persona
WHERE c.ID_Cliente = 1;
GO

-- Paso 2: Ejecutar la venta completa (transacción)
EXEC dbo.sp_RegistrarVentaCompleta
    @ID_Cliente   = 1,
    @ID_Producto  = 1,
    @Cantidad     = 2,
    @Tipo_Emision = 'Factura B',
    @Metodo_Pago  = 'Tarjeta de Debito';
GO

-- Paso 3: Comprobar que el stock disminuyó correctamente
SELECT ID_Producto, Nombre_producto, Stock_producto 
FROM Producto WHERE ID_Producto = 1;
GO

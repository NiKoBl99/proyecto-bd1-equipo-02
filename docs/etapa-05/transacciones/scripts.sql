-- Estado inicial
SELECT ID_Producto, Nombre_producto, Stock_producto FROM Producto;
SELECT (SELECT COUNT(*) FROM Compra) AS Compras,
       (SELECT COUNT(*) FROM Detalle_Compra) AS Detalles,
       (SELECT COUNT(*) FROM Detalle_Pago) AS Pagos;

-- PRUEBA CORRECTA: Mouse (stock 10), compra de 5 unidades, cliente Ana
EXEC dbo.sp_RegistrarVentaCompleta @ID_Cliente = 1, @ID_Producto = 1, @Cantidad = 5;

SELECT ID_Producto, Nombre_producto, Stock_producto FROM Producto WHERE ID_Producto = 1;

-- PRUEBA INCORRECTA: Teclado (stock 3), compra de 5 unidades
BEGIN TRY
    EXEC dbo.sp_RegistrarVentaCompleta @ID_Cliente = 1, @ID_Producto = 2, @Cantidad = 5;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Error, ERROR_MESSAGE() AS Mensaje;
END CATCH;

-- Verificación: no debe haber registros parciales
SELECT ID_Producto, Nombre_producto, Stock_producto FROM Producto WHERE ID_Producto = 2;
SELECT (SELECT COUNT(*) FROM Compra) AS Compras,
       (SELECT COUNT(*) FROM Detalle_Compra) AS Detalles,
       (SELECT COUNT(*) FROM Detalle_Pago) AS Pagos;

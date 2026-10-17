SELECT
    Producto.ID_Producto,
    Producto.Nombre_producto,
FROM Compra
INNER JOIN Comprobante
    ON Compra.ID_Comprobante = Comprobante.ID_comprobante
INNER JOIN Detalle_Compra
    ON Compra.ID_compra = Detalle_Compra.ID_Compra
INNER JOIN Producto
    ON Detalle_Compra.ID_Producto = Producto.ID_Producto
GROUP BY
    Producto.ID_Producto,
    Producto.Nombre_producto

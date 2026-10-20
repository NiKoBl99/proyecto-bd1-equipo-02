# Informe de Ventas: Productos Comercializados

El siguiente apartado del informe detalla el catálogo de productos que han registrado movimientos efectivos de venta. La consulta relaciona el historial de compras con sus respectivos comprobantes y detalles, agrupando los resultados para obtener un listado único de los artículos comercializados.

### Consulta SQL

```sql
SELECT
    Producto.ID_Producto,
    Producto.Nombre_producto
FROM Compra
INNER JOIN Comprobante
    ON Compra.ID_Comprobante = Comprobante.ID_comprobante
INNER JOIN Detalle_Compra
    ON Compra.ID_compra = Detalle_Compra.ID_Compra
INNER JOIN Producto
    ON Detalle_Compra.ID_Producto = Producto.ID_Producto
GROUP BY
    Producto.ID_Producto,
    Producto.Nombre_producto;

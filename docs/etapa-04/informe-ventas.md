# Informe de Ventas: Productos Comercializados

El siguiente apartado del informe detalla el catálogo de productos que han registrado movimientos efectivos de venta. La consulta relaciona el historial de compras con sus respectivos comprobantes y detalles, agrupando los resultados para obtener un listado único de los artículos comercializados.

### Consulta SQL

```sql
SELECT
    Producto.ID_Producto,
    Producto.Nombre_producto,
    SUM(Detalle_Compra.Cantidad_Compra) AS Unidades_Vendidas,
    SUM(Detalle_Compra.Subtotal) AS Total_Vendido,
    COUNT(DISTINCT Compra.ID_compra) AS Cantidad_Compras
FROM Compra
INNER JOIN Comprobante
    ON Compra.ID_Comprobante = Comprobante.ID_comprobante
INNER JOIN Detalle_Compra
    ON Compra.ID_compra = Detalle_Compra.ID_Compra
INNER JOIN Producto
    ON Detalle_Compra.ID_Producto = Producto.ID_Producto
WHERE Comprobante.fecha_emision >= '2026-01-01'
  AND Comprobante.fecha_emision < '2027-01-01'
GROUP BY
    Producto.ID_Producto,
    Producto.Nombre_producto
ORDER BY Total_Vendido DESC;

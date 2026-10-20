# Consulta de Compras por Cliente

Esta consulta obtiene los clientes que han comprado más de $100,000 en el año 2026, ordenados por el total comprado de forma descendente.

```sql
SELECT
    Cliente.ID_Cliente,
    Persona.Nombre,
    Persona.Apellido,
    COUNT(DISTINCT Compra.ID_compra) AS Cantidad_Compras,
    SUM(Detalle_Compra.Subtotal) AS Total_Comprado
FROM Cliente
INNER JOIN Persona
    ON Cliente.ID_Persona = Persona.ID_Persona
INNER JOIN Compra
    ON Cliente.ID_Cliente = Compra.ID_Cliente
INNER JOIN Comprobante
    ON Compra.ID_Comprobante = Comprobante.ID_comprobante
INNER JOIN Detalle_Compra
    ON Compra.ID_compra = Detalle_Compra.ID_Compra
WHERE Comprobante.fecha_emision >= '2026-01-01'
  AND Comprobante.fecha_emision < '2027-01-01'
GROUP BY
    Cliente.ID_Cliente,
    Persona.Nombre,
    Persona.Apellido
HAVING SUM(Detalle_Compra.Subtotal) > 100000
ORDER BY Total_Comprado DESC;
```

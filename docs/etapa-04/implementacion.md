# Implementación de consultas SQL y conceptos utilizados

## 1. Consulta de factura y comprobante

Esta consulta tiene como objetivo consolidar la información correspondiente al encabezado y al detalle de una venta, permitiendo visualizar los datos del comprobante, el cliente, los productos adquiridos, las cantidades y los subtotales de cada renglón, junto con el total acumulado de la compra.

Para su implementación se utilizan las cláusulas `SELECT`, `FROM`, `INNER JOIN` y `ORDER BY`. Mediante `INNER JOIN` se relacionan las tablas `Compra`, `Comprobante`, `Cliente`, `Persona`, `Detalle_Compra` y `Producto`, utilizando sus claves correspondientes para obtener información relacionada.

El subtotal de cada renglón se obtiene de la columna `Subtotal` de la tabla `Detalle_Compra`, mientras que el total de la compra se calcula mediante la función de agregación `SUM()` combinada con la cláusula `OVER (PARTITION BY Compra.ID_compra)`. Esta última permite sumar los subtotales correspondientes a una misma compra sin eliminar los registros individuales de sus productos.

Finalmente, `ORDER BY` organiza los resultados por identificador de compra y por identificador del detalle, facilitando la lectura de los comprobantes.

## 2. Reporte agregado de ventas por producto

Esta consulta permite obtener un informe de ventas por producto dentro de un rango de fechas determinado. Para cada producto se informa la cantidad total de unidades vendidas, el importe total vendido y la cantidad de compras diferentes en las que aparece.

Se utilizan las cláusulas `INNER JOIN` para relacionar las tablas `Compra`, `Comprobante`, `Detalle_Compra` y `Producto`. La cláusula `WHERE` establece el período de análisis mediante la fecha de emisión del comprobante.

La cláusula `GROUP BY` agrupa los registros según el identificador y el nombre del producto. Sobre esos grupos se aplican las funciones de agregación `SUM()` y `COUNT(DISTINCT ...)`. La primera permite calcular las unidades vendidas y el importe total, mientras que la segunda contabiliza las compras diferentes asociadas a cada producto.

Por último, `ORDER BY` ordena los resultados según el importe total vendido, de mayor a menor. De esta manera, el reporte facilita la identificación de los productos que generan mayores ingresos durante el período seleccionado.

## 3. Consulta de negocio avanzada: análisis de compras por cliente

Esta consulta tiene como finalidad identificar a los clientes cuyo importe total de compras supera un umbral establecido, considerando únicamente las operaciones realizadas durante un período determinado.

Para obtener los datos necesarios se relacionan las tablas `Cliente`, `Persona`, `Compra`, `Comprobante` y `Detalle_Compra` mediante `INNER JOIN`. La cláusula `WHERE` filtra las operaciones según la fecha de emisión de sus comprobantes.

Luego, `GROUP BY` agrupa los registros por cliente, utilizando su identificador, nombre y apellido. Sobre cada grupo se aplican las funciones `COUNT(DISTINCT ...)` y `SUM()`, que permiten calcular, respectivamente, la cantidad de compras diferentes y el importe total comprado.

La cláusula `HAVING` establece una condición sobre los resultados agrupados: solamente se incluyen los clientes cuyo importe total supera los $100.000. A diferencia de `WHERE`, que filtra filas antes de la agrupación, `HAVING` permite filtrar los grupos según el resultado de una operación de agregación.

Finalmente, `ORDER BY` ordena los clientes por importe total comprado, en orden descendente.

## Conceptos de SQL aplicados

En las tres consultas se emplean distintos elementos del lenguaje SQL para recuperar, relacionar, calcular y organizar información:

- **`SELECT`:** especifica las columnas y expresiones que se mostrarán en el resultado.
- **`FROM`:** establece la tabla principal de la consulta.
- **`INNER JOIN`:** relaciona tablas mediante condiciones de coincidencia entre sus columnas.
- **`WHERE`:** filtra las filas que cumplen determinadas condiciones antes de realizar la agrupación.
- **`GROUP BY`:** agrupa registros que comparten determinados valores para realizar cálculos por grupo.
- **`SUM()`:** suma los valores numéricos de una columna.
- **`COUNT(DISTINCT ...)`:** cuenta los valores diferentes de una expresión, evitando contabilizar varias veces el mismo identificador.
- **`OVER (PARTITION BY ...)`:** permite realizar cálculos sobre conjuntos de filas relacionados, conservando el detalle individual de cada registro.
- **`HAVING`:** filtra los grupos según condiciones que pueden involucrar funciones de agregación.
- **`ORDER BY`:** establece el orden en que se presentan los resultados.
- **`AS`:** asigna un nombre descriptivo a una columna calculada, facilitando la interpretación de los resultados.

## Conclusión

La implementación de estas consultas permite obtener información útil para la gestión comercial de la base de datos. La primera facilita la consulta de comprobantes y sus detalles; la segunda proporciona un resumen de las ventas por producto; y la tercera permite identificar clientes según su volumen de compras.

En conjunto, las consultas aplican operaciones de selección, combinación, filtrado y agregación de datos, demostrando el uso de herramientas fundamentales de SQL Server para la elaboración de informes y el análisis de información comercial.

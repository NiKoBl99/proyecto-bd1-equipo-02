# 5. Optimización de consultas mediante índices

## 5.1 Definición y objetivo
Un **índice** es una estructura que permite al motor de base de datos ubicar datos sin recorrer toda la tabla, de manera similar al índice de un libro. El objetivo principal es reducir las lecturas en disco/memoria y los tiempos de respuesta, evitando la operación de **Table Scan** cuando sea posible.

---

## 5.2 Ventajas y aplicaciones
* **Aceleran las búsquedas y los filtros** por fecha, cliente, código o producto.
* **Reducen las lecturas lógicas** en tablas de gran volumen.
* **Consideraciones de rendimiento:** Ocupan espacio en disco y pueden penalizar las operaciones de modificación (`INSERT`, `UPDATE` y `DELETE`), debido a que los índices deben mantenerse actualizados automáticamente.

---

## 5.3 Implementación en SQL Server Express
Para administrar índices se utilizan las siguientes instrucciones DDL:
* `CREATE CLUSTERED INDEX`
* `CREATE NONCLUSTERED INDEX ... INCLUDE (...)`
* `DROP INDEX`

Para medir el rendimiento de las consultas se emplean los siguientes comandos:

```sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
```
---

## 5.4 Caso aplicado al sistema
Los informes de ventas (consultas 2 y 3 del proyecto) filtran por la columna `Comprobante.fecha_emision` y unen las tablas `Compra` y `Detalle_Compra`.

Se propone crear un índice por fecha y dos índices adicionales sobre las columnas de unión para mejorar el rendimiento global de las consultas.

---

## 5.5 Script de demostración

### A. Caso de la guía: `VentaHistorica` con 1.000.000 de filas

#### Crear la tabla y cargar los datos

```sql
CREATE TABLE VentaHistorica (
    id_venta    BIGINT IDENTITY(1,1),
    fecha_venta DATE NOT NULL,
    importe     DECIMAL(12,2) NOT NULL
);
GO

SET NOCOUNT ON;
GO

WITH Numeros AS (
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO VentaHistorica(fecha_venta, importe)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
    RAND(CHECKSUM(NEWID())) * 10000
FROM Numeros;
GO

SELECT COUNT(*) AS CantidadRegistros
FROM VentaHistorica;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO
```

#### 1. Consulta sin índice

```sql
SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO
```
#### 2. Índice agrupado sobre la fecha

```sql
CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON VentaHistorica(fecha_venta);
GO

SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO

DROP INDEX IX_VentaHistorica_Fecha
ON VentaHistorica;
GO
```
*El índice permite localizar el rango de fechas solicitado. El plan de ejecución puede utilizar un **Clustered Index Seek**.*

#### 3. Índice con cobertura

```sql
CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura
ON VentaHistorica(fecha_venta)
INCLUDE (importe);
GO

SELECT fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO
```
*El índice contiene todas las columnas necesarias para resolver la consulta sin requerir accesos adicionales a las filas de la tabla para recuperar la columna `importe`.*

---

### B. Aplicación al modelo del sistema de ventas

#### Insertar comprobantes

```sql
WITH N AS (
    SELECT TOP (200000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO Comprobante(fecha_emision, tipo_emision)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2025-01-01'),
    'Factura B'
FROM N;
```

#### Insertar compras

```sql
INSERT INTO Compra(ID_Comprobante, ID_Cliente)
SELECT
    ID_comprobante,
    1 + ABS(CHECKSUM(NEWID())) % 2
FROM Comprobante
WHERE ID_comprobante NOT IN (
    SELECT ID_Comprobante
    FROM Compra
);
```

#### Insertar detalles de compra

```sql
INSERT INTO Detalle_Compra(
    ID_Compra,
    ID_Producto,
    Cantidad_Compra,
    Subtotal,
    Precio_Unitario
)
SELECT
    ID_compra,
    1 + ABS(CHECKSUM(NEWID())) % 2,
    1,
    15000,
    15000
FROM Compra
WHERE ID_compra NOT IN (
    SELECT ID_Compra
    FROM Detalle_Compra
);
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO
```

#### Medición antes de crear los índices
1. Ejecutar la **Consulta 2** (Informe de Venta) y la **Consulta 3** (Consulta avanzada).
2. Registrar el tiempo de CPU, el tiempo total, las lecturas lógicas y los operadores del plan de ejecución.

#### Crear los índices propuestos

```sql
CREATE NONCLUSTERED INDEX IX_Comprobante_FechaEmision
ON Comprobante(fecha_emision)
INCLUDE (tipo_emision);

CREATE NONCLUSTERED INDEX IX_Compra_Comprobante
ON Compra(ID_Comprobante)
INCLUDE (ID_Cliente);

CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra
ON Detalle_Compra(ID_Compra)
INCLUDE (ID_Producto, Cantidad_Compra, Subtotal);
GO
```

#### Medición después de crear los índices
Volver a ejecutar las consultas 2 y 3 con los mismos parámetros y comparar los resultados.

Para la **Consulta 2**, si se filtran únicamente los registros del año 2026, utilizar un rango de fechas en lugar de aplicar la función `YEAR()` sobre la columna:

```sql
WHERE fecha_emision >= '2026-01-01'
  AND fecha_emision < '2027-01-01';
```
*Esta condición es **sargable**, lo que permite que el índice sobre `fecha_emision` pueda utilizarse mediante un **Index Seek**, dependiendo del plan elegido por el optimizador.*

---

## 5.6 Resultados

Completar la siguiente tabla con las mediciones reales obtenidas mediante `SET STATISTICS` y el plan de ejecución real. Adjuntar capturas de los planes.

| Escenario | Tiempo CPU (ms) | Tiempo total (ms) | Lecturas lógicas | Operación principal |
| :--- | :---: | :---: | :---: | :---: |
| **Sin índice** | XXX | XXX | XXX | Table Scan |
| **Índice agrupado sobre fecha** | XXX | XXX | XXX | Clustered Index Seek |
| **Índice con cobertura** | XXX | XXX | XXX | Index Seek |

### Resultados esperados
* **Sin índice:** El motor debe examinar todas las filas de la tabla para localizar los registros que cumplen el filtro, produciendo un alto número de lecturas lógicas.
* **Índice agrupado sobre la fecha:** Reduce notablemente las lecturas al localizar directamente el rango solicitado.
* **Índice con cobertura:** Elimina los accesos adicionales a la tabla (*Key/RID Lookups*) al contener todas las columnas necesarias para la consulta.
* **Modelo del sistema de ventas:** Las consultas 2 y 3 se beneficiarán de los índices sobre `Comprobante`, `Compra` y `Detalle_Compra`. La selección de *Index Seek*, *Table Scan*, *Hash Match* u otros operadores dependerá de las estadísticas, la cantidad de filas y el costo estimado por el optimizador.

---

## Conclusión
La creación de índices estratégicos mejora ostensiblemente el rendimiento de las consultas que utilizan filtros y uniones frecuentes. En el sistema de ventas, los índices sobre las fechas de emisión y las claves foráneas de unión permiten reducir significativamente las lecturas lógicas y los tiempos de respuesta.

Sin embargo, dado que cada índice consume almacenamiento en disco y agrega carga operacional a las instrucciones de escritura (`INSERT`, `UPDATE`, `DELETE`), es indispensable indexar únicamente las columnas críticas y validar los beneficios mediante mediciones reales.

---

## Limpieza (Opcional)
Ejecutar este script únicamente si los usuarios, roles e inicios de sesión creados durante las pruebas ya no son necesarios.

```sql
USE SistemaVentas;
GO

DROP USER IF EXISTS usuario_admin;
DROP USER IF EXISTS usuario_lector;
DROP USER IF EXISTS usuario_con_rol;
DROP USER IF EXISTS usuario_sin_rol;

DROP ROLE IF EXISTS rol_consulta_productos;
GO

USE master;
GO

DROP LOGIN IF EXISTS usuario_admin;
DROP LOGIN IF EXISTS usuario_lector;
DROP LOGIN IF EXISTS usuario_con_rol;
DROP LOGIN IF EXISTS usuario_sin_rol;
GO
```

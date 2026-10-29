5. Optimización de consultas mediante índices
5.1 Definición y objetivo

Un índice es una estructura que permite al motor de base de datos ubicar datos sin recorrer toda la tabla, de manera similar al índice de un libro.

El objetivo es reducir las lecturas y los tiempos de respuesta, evitando el Table Scan cuando sea posible.

5.2 Ventajas y aplicaciones

Los índices ofrecen las siguientes ventajas:

Aceleran las búsquedas y los filtros por fecha, cliente, código o producto.
Reducen las lecturas lógicas en tablas grandes.
Mejoran el rendimiento de las consultas que utilizan frecuentemente determinadas columnas.

Sin embargo, también presentan algunos costos:

Ocupan espacio en disco.
Pueden penalizar levemente las operaciones INSERT, UPDATE y DELETE, ya que los índices deben mantenerse actualizados.
5.3 Implementación en SQL Server Express

En SQL Server Express se pueden utilizar las siguientes instrucciones para administrar índices:

CREATE CLUSTERED INDEX: crea un índice agrupado.
CREATE NONCLUSTERED INDEX ... INCLUDE (...): crea un índice no agrupado que puede incluir columnas adicionales para cubrir una consulta.
DROP INDEX: elimina un índice existente.

Para medir el rendimiento de las consultas se utilizan las siguientes herramientas:

sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


Además, en SQL Server Management Studio (SSMS), se puede activar el plan de ejecución real mediante Ctrl + M.

Estas herramientas permiten comparar el tiempo de CPU, el tiempo total, las lecturas lógicas y las operaciones utilizadas por el motor de base de datos.

5.4 Caso aplicado al sistema

Los informes de ventas correspondientes a las consultas 2 y 3 del proyecto filtran información por Comprobante.fecha_emision y realizan uniones entre las tablas Compra y Detalle_Compra.

Se propone crear índices sobre las columnas utilizadas en los filtros y las uniones, dado que estas columnas no cuentan con índices específicos, salvo los que pudieran existir por las claves primarias.

Los índices propuestos son:

Un índice sobre Comprobante.fecha_emision, incluyendo tipo_emision.
Un índice sobre Compra.ID_Comprobante, incluyendo ID_Cliente.
Un índice sobre Detalle_Compra.ID_Compra, incluyendo ID_Producto, Cantidad_Compra y Subtotal.

El objetivo es reducir las lecturas lógicas y mejorar el rendimiento de los informes de ventas.

5.5 Script de demostración
A. Caso de la guía: VentaHistorica con 1.000.000 de filas
1. Crear la tabla y cargar los datos
sql
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
    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % 1825,
        '2020-01-01'
    ),
    RAND(CHECKSUM(NEWID())) * 10000
FROM Numeros;
GO

SELECT COUNT(*) AS CantidadRegistros
FROM VentaHistorica;

2. Activar las estadísticas de rendimiento
sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

3. Consulta sin índice

En este escenario, la tabla es un heap, es decir, no tiene un índice agrupado.

sql
SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO


El objetivo es observar las lecturas lógicas y comprobar si el plan de ejecución utiliza un operador Table Scan.

4. Crear un índice agrupado sobre la fecha
sql
CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON VentaHistorica(fecha_venta);
GO

SELECT id_venta, fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO


Este índice organiza los datos de la tabla según la clave del índice agrupado. La consulta puede utilizar un Clustered Index Seek para localizar el rango de fechas solicitado.

A continuación, se elimina el índice para realizar la siguiente prueba:

sql
DROP INDEX IX_VentaHistorica_Fecha
ON VentaHistorica;
GO

5. Crear un índice no agrupado con cobertura
sql
CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura
ON VentaHistorica(fecha_venta)
INCLUDE (importe);
GO

SELECT fecha_venta, importe
FROM VentaHistorica
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
GO


El índice incluye todas las columnas necesarias para esta consulta. Por lo tanto, el motor puede resolverla directamente desde el índice sin tener que acceder a las filas de la tabla para obtener importe.

B. Aplicación al modelo del sistema de ventas
Importante: ejecutar esta carga en una copia de la base de datos o al finalizar las demás pruebas, ya que agrega 200.000 comprobantes y modifica los datos utilizados por los informes de ventas.
1. Insertar comprobantes
sql
WITH N AS (
    SELECT TOP (200000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO Comprobante(fecha_emision, tipo_emision)
SELECT
    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % 730,
        '2025-01-01'
    ),
    'Factura B'
FROM N;

2. Insertar compras
sql
INSERT INTO Compra(ID_Comprobante, ID_Cliente)
SELECT
    ID_comprobante,
    1 + ABS(CHECKSUM(NEWID())) % 2
FROM Comprobante
WHERE ID_comprobante NOT IN (
    SELECT ID_Comprobante
    FROM Compra
);

3. Insertar detalles de compra
sql
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

4. Medir el rendimiento antes de crear los índices
sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO


Ejecutar la consulta 2 (Informe de Venta) y la consulta 3 (Consulta avanzada) del proyecto.

Registrar los siguientes datos:

Tiempo de CPU.
Tiempo total de ejecución.
Lecturas lógicas.
Operadores principales del plan de ejecución.
5. Crear los índices propuestos
sql
CREATE NONCLUSTERED INDEX IX_Comprobante_FechaEmision
ON Comprobante(fecha_emision)
INCLUDE (tipo_emision);

CREATE NONCLUSTERED INDEX IX_Compra_Comprobante
ON Compra(ID_Comprobante)
INCLUDE (ID_Cliente);

CREATE NONCLUSTERED INDEX IX_DetalleCompra_Compra
ON Detalle_Compra(ID_Compra)
INCLUDE (
    ID_Producto,
    Cantidad_Compra,
    Subtotal
);
GO

6. Medir el rendimiento después de crear los índices

Volver a ejecutar las mismas consultas 2 y 3, utilizando los mismos parámetros y filtros que en la prueba anterior.

Comparar los resultados obtenidos antes y después de la creación de los índices.

Para la consulta 2, si se filtran únicamente los registros de 2026, se recomienda utilizar un rango de fechas en lugar de aplicar la función YEAR() sobre la columna:

sql
WHERE fecha_emision >= '2026-01-01'
  AND fecha_emision < '2027-01-01';


Este tipo de condición permite que el motor utilice un índice sobre fecha_emision mediante un posible Index Seek, siempre que el plan de ejecución y el costo estimado lo favorezcan.

5.6 Resultados

Completar esta sección con las mediciones obtenidas mediante SET STATISTICS TIME, SET STATISTICS IO y el plan de ejecución real de SQL Server. Adjuntar capturas de los planes utilizados en cada prueba.

Tabla comparativa
Escenario	Tiempo CPU (ms)	Tiempo total (ms)	Lecturas lógicas	Operación principal
Sin índice	XX	XX	XX	Table Scan
Índice agrupado sobre fecha	XX	XX	XX	Clustered Index Seek
Índice con cobertura	XX	XX	XX	Index Seek

Nota: los valores XX deben reemplazarse por los resultados reales obtenidos durante las pruebas. Las operaciones indicadas son resultados esperados, no garantías de que el optimizador las seleccione.

Resultados esperados
Sin índice: el motor debe examinar las filas de la tabla para localizar los registros que cumplen el filtro. Esto puede generar miles de lecturas lógicas.
Índice agrupado sobre la fecha: el motor puede localizar directamente el rango solicitado y reducir las lecturas, especialmente cuando el filtro devuelve una proporción pequeña de los registros.
Índice con cobertura: el motor puede resolver la consulta directamente desde el índice, evitando accesos adicionales a la tabla para recuperar las columnas incluidas.
Modelo del sistema de ventas: las consultas 2 y 3 podrían reducir sus lecturas y utilizar operaciones como Index Seek en las tablas Comprobante, Compra y Detalle_Compra. Sin embargo, el optimizador también puede elegir escaneos u otras operaciones según la cantidad de filas, las estadísticas y el costo estimado.
Conclusión

La implementación de índices permite mejorar el rendimiento de las consultas que filtran y relacionan grandes cantidades de datos. En el caso del sistema de ventas, los índices sobre las fechas de emisión y las columnas de unión pueden reducir las lecturas lógicas y los tiempos de respuesta de los informes.

No obstante, cada índice adicional ocupa espacio en disco y agrega trabajo a las operaciones de inserción, actualización y eliminación. Por este motivo, se recomienda crear índices únicamente sobre las columnas que participan con frecuencia en filtros, búsquedas y uniones, y validar su utilidad mediante mediciones reales.

5.7 Limpieza opcional

El siguiente script elimina los usuarios, el rol y los inicios de sesión creados durante las pruebas. Ejecutarlo únicamente si esos objetos ya no son necesarios.

sql
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

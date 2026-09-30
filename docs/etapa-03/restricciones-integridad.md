# Restricciones de Integridad Definidas

Para garantizar la coherencia y validez de los datos en el sistema, se implementaron las siguientes restricciones a nivel de base de datos:

## 1. Claves Primarias (PRIMARY KEY)
Todas las tablas cuentan con identificadores únicos. Destaca el uso de **Claves Primarias Compuestas** en las tablas transaccionales intermedias puras:
* `Detalle_Pago`: PK compuesta por `(id_comprobante, id_metodo)`.
* `Detalle_Compra`: PK compuesta por `(id_compra, id_producto)`.

## 2. Restricciones de Unicidad (UNIQUE)
Se aplicó la restricción `UNIQUE` en campos que identifican unívocamente a entidades del mundo real para evitar registros duplicados:
* `Persona`: El atributo `dni` y el `email` son únicos.
* `Proveedor`: El atributo `cuit` es único.

## 3. Integridad Referencial (FOREIGN KEY)
Se establecieron 23 restricciones de clave foránea para mantener la coherencia relacional. Por ejemplo, el motor impedirá que se registre un `Equipo` si el `id_cliente` no existe previamente en la tabla maestra `Cliente`, evitando registros huérfanos.

## 4. Obligatoriedad de Datos (NOT NULL)
Se forzó la obligatoriedad de carga mediante `NOT NULL` en columnas críticas para la lógica de negocio, como la `fecha_emision` de un comprobante o el `stock` de los productos e insumos.

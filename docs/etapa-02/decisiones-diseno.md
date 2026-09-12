# Decisiones de Diseño - Etapa 02

Durante el modelado de datos, el equipo tomó las siguientes decisiones de diseño:

1. **Uso de supertipo PERSONA:** Se decidió abstraer los datos comunes de `CLIENTE` y `TECNICO` en una entidad general llamada `PERSONA` para evitar la redundancia de atributos como Nombre, Apellido, DNI y Mail.
2. **Claves Primarias Artificiales:** Se optó por utilizar IDs numéricos (ej. `ID_Empresa`, `ID_Equipo`) como claves primarias para todas las entidades, facilitando así la vinculación entre tablas mediante claves foráneas. Los identificadores naturales como `DNI` o `CUIT` se configuraron con la restricción de "Unique".
3. **Gestión de Comprobantes:** Se generalizó el concepto de facturación centralizando los datos en la entidad `COMPROBANTE`, la cual se relaciona de forma modular con las compras de productos y las órdenes de reparación de equipos.
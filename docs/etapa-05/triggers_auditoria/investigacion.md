# Triggers de auditoría

## Definición y objetivo
Un trigger es un procedimiento que se ejecuta **automáticamente** ante un `INSERT`, `UPDATE` o `DELETE` sobre una tabla. Para auditoría, guarda quién cambió qué, cuándo y con qué valores anteriores.

## Ventajas y aplicaciones
- Trazabilidad: responde quién modificó un precio, cuándo se eliminó un producto y qué valor tenía antes.
- Funciona sin depender de que la aplicación registre el cambio.
- Aplicaciones: control de precios y stock, detección de cambios no autorizados.

## Implementación
Se crea una tabla de auditoría y un trigger `AFTER INSERT`, `UPDATE`, `DELETE`. Dentro del trigger se usan las tablas virtuales `inserted` (valores nuevos) y `deleted` (valores anteriores). Se obtiene el usuario con `SUSER_NAME()`. El trigger está escrito para operar sobre varias filas a la vez.

## Caso aplicado al sistema
Auditoría de `Producto`: se registran fecha y hora, usuario, producto, precio anterior y nuevo, stock anterior y nuevo, y tipo de operacion. Como la venta descuenta stock, cada venta tambien deja rastro en la auditoría.

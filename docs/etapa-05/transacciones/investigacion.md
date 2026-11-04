# Manejo de transacciones

## Definición y objetivo

Una transacción agrupa varias operaciones en una única unidad lógica de
trabajo: o se confirman todas (`COMMIT`) o se deshacen todas
(`ROLLBACK`). Garantiza las propiedades **ACID**: Atomicidad,
Consistencia, Aislamiento y Durabilidad.

## Ventajas y aplicaciones

-   **Evitan datos incompletos:** una venta puede involucrar
    `Comprobante`, `Compra`, `Detalle_Compra`, `Producto`, `Metodo_Pago`
    y `Detalle_Pago`.
-   **Mantienen la consistencia del stock** ante errores o accesos
    simultáneos.
-   **Aplicaciones:** ventas, pagos, anulaciones y ajustes de
    inventario.

## Implementación en SQL Server Express

Se utilizan `BEGIN TRANSACTION`, `COMMIT` y `ROLLBACK`, junto con
`TRY...CATCH`.

También se agrega `SET XACT_ABORT ON` para que los errores de ejecución
reviertan la transacción. Por su parte, `UPDLOCK` y `HOLDLOCK` permiten
controlar el acceso concurrente al stock y evitar que dos ventas
simultáneas consuman las mismas unidades.

## Caso aplicado al sistema

Un cliente compra 5 unidades de un producto. Si hay stock suficiente, se
registra toda la operación y se descuenta la cantidad correspondiente.
Si no alcanza, no se registra la venta, ni el detalle, ni el pago, y el
stock queda intacto.

Esta lógica está implementada en el procedimiento almacenado

## Conclusión

Esto demuestra la **atomicidad** de las transacciones: si todas las
operaciones pueden realizarse correctamente, se confirman; si ocurre un
error, se revierten y la base de datos conserva su estado anterior.

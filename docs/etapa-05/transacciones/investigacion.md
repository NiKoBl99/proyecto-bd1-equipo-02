Manejo de transacciones
Definición y objetivo
Una transacción agrupa varias operaciones en una única unidad lógica de trabajo: o se confirman todas (COMMIT) o se deshacen todas (ROLLBACK). Garantiza las propiedades ACID: Atomicidad, Consistencia, Aislamiento y Durabilidad.
Ventajas y aplicaciones
•	Evitan datos incompletos: una venta toca Comprobante, Compra, Detalle_Compra, Producto, Metodo_Pago y Detalle_Pago.
•	Mantienen la consistencia del stock ante errores o accesos simultáneos.
•	Aplicaciones: ventas, pagos, anulaciones, ajustes de inventario.
Implementación en SQL Server Express
BEGIN TRANSACTION, COMMIT, ROLLBACK, junto con TRY...CATCH. Se agrega SET XACT_ABORT ON para que cualquier error de ejecución revierta la transacción, y UPDLOCK, HOLDLOCK para que dos ventas simultáneas no consuman el mismo stock.
Caso aplicado al sistema
Un cliente compra 5 unidades de un producto. Si hay stock, se registra todo y se descuenta; si no alcanza, no se registra la venta, ni el detalle, ni el pago, y el stock queda intacto. La lógica ya está dentro de sp_RegistrarVentaCompleta.

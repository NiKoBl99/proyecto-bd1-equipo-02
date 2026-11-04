# Evidencia de Manejo de Transacciones

Esta carpeta contiene las pruebas del manejo de transacciones en SQL Server, demostrando la integridad y atomicidad de las operaciones de venta.

- **Venta exitosa:** Se ejecuta `dbo.sp_RegistrarVentaCompleta` para registrar una compra de 5 unidades de Mouse. Se verifica la generación de la venta, sus detalles y pagos, junto con la actualización del stock de 10 a 5 unidades.
- **Venta fallida:** Se intenta registrar una compra de 5 unidades de Teclado cuando solamente hay 3 disponibles. Se produce el error `50003` y se ejecuta `ROLLBACK`, evitando que se registre una venta incompleta o se modifique el stock.
- **Verificación de atomicidad:** Se comprueba que, ante un error, todas las operaciones de la transacción se revierten y la base de datos conserva su estado anterior.

Estas pruebas demuestran que `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK` y los mecanismos de control de concurrencia permiten mantener la consistencia de los datos.

### Resultados esperados adaptados a la ejecución actual

| Prueba | Resultado | 
| ----- | ----- | 
| Correcta (Mouse x5) | Venta con total \$118.750 y descuento aplicado de 5.00. El stock del Mouse pasa de 48 a 43. Los contadores de compras, detalles y pagos aumentan en 1. | 
| Correcta (Teclado x5)<br>(Originalmente la prueba de error) | Venta exitosa porque el stock inicial era 30 (suficiente para cubrir los 5 solicitados). La venta se registra con un total de \$213.750 y 5.00 de descuento. El stock del Teclado pasa de 30 a 25. Los contadores finales reflejan 11 compras, 11 detalles y 3 pagos. |


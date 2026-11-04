# Evidencia de Manejo de Transacciones

Esta carpeta contiene las pruebas del manejo de transacciones en SQL Server, demostrando la integridad y atomicidad de las operaciones de venta.

- **Venta exitosa:** Se ejecuta `dbo.sp_RegistrarVentaCompleta` para registrar una compra de 5 unidades de Mouse. Se verifica la generación de la venta, sus detalles y pagos, junto con la actualización del stock de 10 a 5 unidades.
- **Venta fallida:** Se intenta registrar una compra de 5 unidades de Teclado cuando solamente hay 3 disponibles. Se produce el error `50003` y se ejecuta `ROLLBACK`, evitando que se registre una venta incompleta o se modifique el stock.
- **Verificación de atomicidad:** Se comprueba que, ante un error, todas las operaciones de la transacción se revierten y la base de datos conserva su estado anterior.

Estas pruebas demuestran que `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK` y los mecanismos de control de concurrencia permiten mantener la consistencia de los datos.

## Pruebas y resultados

  -----------------------------------------------------------------------
  Prueba                              Resultado
  ----------------------------------- -----------------------------------
  **Correcta (Mouse × 5)**            Venta con total de **\$75.000** y
                                      **0 % de descuento**. El stock del
                                      Mouse pasa de 10 a 5. Las
                                      cantidades de compras, detalles y
                                      pagos aumentan en 1.

  **Incorrecta (Teclado × 5)**        Se produce el **error 50003** y se
                                      ejecuta `ROLLBACK`. El stock del
                                      Teclado sigue siendo 3 y los
                                      contadores no cambian respecto de
                                      la prueba anterior.
  -----------------------------------------------------------------------


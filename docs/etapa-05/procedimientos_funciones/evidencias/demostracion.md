# Evidencia de Procedimientos y Funciones Almacenadas

Esta carpeta contiene la demostración de la lógica de negocio centralizada en la base de datos.

* **Función de Descuento:** Se verifica la ejecución de `dbo.fn_CalcularDescuentoCliente`, validando que el cliente reciba un 5% o 10% dependiendo de su historial de compras.
* **Transacción de Venta:** Se ejecuta `dbo.sp_RegistrarVentaCompleta`. El script de prueba evidencia cómo la transacción genera los comprobantes, aplica el descuento correspondiente de la función y actualiza (disminuye) el stock del producto de forma segura usando bloqueos de concurrencia.

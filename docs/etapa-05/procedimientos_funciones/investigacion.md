# Procedimientos y funciones almacenadas

## Definición y objetivo
Un procedimiento almacenado es un programa SQL guardado en la base de datos que puede ejecutar varias operaciones (insertar, actualizar, validar). Una función recibe parámetros y devuelve un valor escalar o una tabla. El objetivo es centralizar la lógica de negocio en la base y no repetirla en cada consulta o aplicación.

## Ventajas y aplicaciones
* **Reutilizan** lógica de negocio y reducen código repetido.
* **Mejoran la mantenibilidad:** una regla se cambia en un solo lugar.
* **Permiten** dar permisos de ejecución sin dar acceso directo a las tablas (ver tema 4).
* **Aplicaciones:** registrar una venta completa, calcular descuentos, emitir reportes.

## Implementación en SQL Server Express
Se usan `CREATE FUNCTION` y `CREATE PROCEDURE`. Cada uno debe ir en su propio lote, separado con `GO`.

## Caso aplicado al sistema
* **Función `dbo.fn_CalcularDescuentoCliente`:** suma lo comprado históricamente por un cliente. Más de $500.000 → 10%; más de $200.000 → 5%; caso contrario 0%.
* **Procedimiento `dbo.sp_RegistrarVentaCompleta`:** crea el Comprobante y la Compra, inserta el Detalle_Compra con el precio histórico, descuenta stock, aplica el descuento y registra el método y el monto del pago, todo dentro de una transacción.

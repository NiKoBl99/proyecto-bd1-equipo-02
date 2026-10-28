# 2. Manejo de transacciones

## 2.1 Definición y objetivo

Una transacción agrupa varias operaciones en una **única unidad lógica de trabajo**: o se confirman todas (`COMMIT`) o se deshacen todas (`ROLLBACK`).

Las transacciones garantizan las propiedades **ACID**:

- **Atomicidad:** todas las operaciones se completan o ninguna queda aplicada.
- **Consistencia:** la base de datos mantiene las reglas de integridad.
- **Aislamiento:** las operaciones concurrentes no deben producir resultados inconsistentes.
- **Durabilidad:** los cambios confirmados permanecen guardados.

## 2.2 Ventajas y aplicaciones

- **Evitan datos incompletos:** una venta puede involucrar las tablas `Comprobante`, `Compra`, `Detalle_Compra`, `Producto`, `Metodo_Pago` y `Detalle_Pago`.
- **Mantienen la consistencia del stock** ante errores o accesos simultáneos.
- **Aplicaciones habituales:** ventas, pagos, anulaciones y ajustes de inventario.

## 2.3 Implementación en SQL Server Express

La implementación utiliza las siguientes instrucciones y mecanismos:

- `BEGIN TRANSACTION`: inicia la transacción.
- `COMMIT`: confirma los cambios.
- `ROLLBACK`: revierte los cambios.
- `TRY...CATCH`: permite gestionar errores.
- `SET XACT_ABORT ON`: hace que determinados errores de ejecución provoquen la finalización y reversión de la transacción.
- `UPDLOCK` y `HOLDLOCK`: ayudan a controlar el acceso concurrente a los registros involucrados y a evitar que dos ventas consuman el mismo stock disponible.

## 2.4 Caso aplicado al sistema

Un cliente intenta comprar cinco unidades de un producto. Si hay stock suficiente, se registra la venta completa y se descuenta la cantidad correspondiente. Si el stock no alcanza, **no se registra la venta, ni el detalle, ni el pago, y el stock queda intacto**.

Esta lógica está implementada en el procedimiento almacenado `dbo.sp_RegistrarVentaCompleta`.

## 2.5 Script de demostración

El siguiente script permite consultar el estado inicial, probar una venta válida, probar una venta que debe fallar por falta de stock y verificar que no queden registros parciales.

> **Importante:** el ejemplo supone que el producto con `ID_Producto = 1` es un Mouse con stock inicial de 10 unidades, que el producto con `ID_Producto = 2` es un Teclado con stock inicial de 3 unidades y que el cliente con `ID_Cliente = 1` existe. Ejecutá la prueba sobre una base de datos de desarrollo o una copia de prueba.

```sql
-- Estado inicial
SELECT ID_Producto, Nombre_producto, Stock_producto
FROM Producto;

SELECT
    (SELECT COUNT(*) FROM Compra) AS Compras,
    (SELECT COUNT(*) FROM Detalle_Compra) AS Detalles,
    (SELECT COUNT(*) FROM Detalle_Pago) AS Pagos;

-- PRUEBA CORRECTA: Mouse (stock 10), compra de 5 unidades, cliente Ana
EXEC dbo.sp_RegistrarVentaCompleta
    @ID_Cliente = 1,
    @ID_Producto = 1,
    @Cantidad = 5;

-- Verificar el stock del Mouse
SELECT ID_Producto, Nombre_producto, Stock_producto
FROM Producto
WHERE ID_Producto = 1;

-- PRUEBA INCORRECTA: Teclado (stock 3), compra de 5 unidades
BEGIN TRY
    EXEC dbo.sp_RegistrarVentaCompleta
        @ID_Cliente = 1,
        @ID_Producto = 2,
        @Cantidad = 5;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS Error,
        ERROR_MESSAGE() AS Mensaje;
END CATCH;

-- Verificar el stock del Teclado
SELECT ID_Producto, Nombre_producto, Stock_producto
FROM Producto
WHERE ID_Producto = 2;

-- Verificar que no se hayan creado registros parciales
SELECT
    (SELECT COUNT(*) FROM Compra) AS Compras,
    (SELECT COUNT(*) FROM Detalle_Compra) AS Detalles,
    (SELECT COUNT(*) FROM Detalle_Pago) AS Pagos;
```

## 2.6 Resultados esperados

| Prueba | Resultado esperado |
|---|---|
| **Correcta (Mouse × 5)** | La venta se registra con un total de **$75.000** y **0 % de descuento**. El stock del Mouse pasa de 10 a 5 unidades. Los contadores de compras, detalles y pagos aumentan en 1. |
| **Incorrecta (Teclado × 5)** | Se produce el error **50003** y se ejecuta `ROLLBACK`. El stock del Teclado permanece en 3 unidades y los contadores de compras, detalles y pagos no cambian respecto del estado posterior a la prueba correcta. |

Los resultados exactos dependen de los datos de la base y de la implementación del procedimiento almacenado.

## 2.7 Conclusión

La prueba demuestra la **atomicidad** de las transacciones: si una operación de la venta falla por falta de stock, los cambios de esa venta se revierten y la base de datos no queda con información parcial.

SELECT
    Compra.ID_compra,
    Comprobante.ID_comprobante,
    Comprobante.fecha_emision,
    Comprobante.tipo_emision,
    Persona.Nombre,
    Persona.Apellido,
    Producto.Nombre_producto,
    Detalle_Compra.Cantidad_Compra,
    Detalle_Compra.Subtotal,
        SUM(Detalle_Compra.Subtotal) OVER (
            PARTITION BY Compra.ID_compra
    ) AS Total_Compra
    FROM Compra
INNER JOIN Comprobante
    ON Compra.ID_Comprobante = Comprobante.ID_comprobante
INNER JOIN Cliente
    ON Compra.ID_Cliente = Cliente.ID_Cliente
INNER JOIN Persona
    ON Cliente.ID_Persona = Persona.ID_Persona
INNER JOIN Detalle_Compra
    ON Compra.ID_compra = Detalle_Compra.ID_Compra
INNER JOIN Producto
    ON Detalle_Compra.ID_Producto = Producto.ID_Producto

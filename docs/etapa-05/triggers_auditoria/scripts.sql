CREATE TABLE auditoria_producto(
    ID_Auditoria INT IDENTITY(1,1) PRIMARY KEY,
    Fecha_Hora datetime2 NOT NULL DEFAULT SYSDATETIME(),
    Usuario sysname NOT NULL,
    ID_Producto INT NOT NULL,
    Nombre_producto VARCHAR(50) NULL,
    Precio_anterior DECIMAL(10,2) NULL,
    Precio_nuevo DECIMAL(10,2) NULL,
    Stock_anterior INT NULL,
    Stock_nuevo INT NULL,
    Operacion VARCHAR(10) NOT NULL
);
GO

CREATE OR ALTER TRIGGER trg_Auditoria_Producto
ON Producto
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO auditoria_producto
        (Usuario, ID_Producto, Nombre_producto, Precio_anterior, Precio_nuevo,
         Stock_anterior, Stock_nuevo, Operacion)
    SELECT SUSER_SNAME(),
           COALESCE(i.ID_Producto, d.ID_Producto),
           COALESCE(i.Nombre_producto, d.Nombre_producto),
           d.Precio_producto, i.Precio_producto,
           d.Stock_producto,  i.Stock_producto,
           CASE 
                WHEN d.ID_Producto IS NULL THEN 'INSERT'
                WHEN i.ID_Producto IS NULL THEN 'DELETE'
                ELSE 'UPDATE' END
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.ID_Producto = d.ID_Producto
    WHERE i.ID_Producto IS NULL OR d.ID_Producto IS NULL      -- INSERT o DELETE
       OR i.Precio_producto <> d.Precio_producto               -- cambió el precio
       OR i.Stock_producto  <> d.Stock_producto;               -- cambió el stock
END;
GO

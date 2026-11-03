use SistemaVentasYservicios

UPDATE Producto SET Precio_producto = 110000 WHERE ID_Producto = 10;
INSERT INTO Producto(Stock_producto,Nombre_producto,Precio_producto,ID_Empresa,ID_Proveedor)
VALUES (17,'Teclado Mecanico RGB',67000,1,1);
DELETE FROM Producto WHERE Nombre_producto = 'Monitor Gamer 144hz';

SELECT * FROM auditoria_producto ORDER BY ID_Auditoria;
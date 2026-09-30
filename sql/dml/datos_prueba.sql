-- Insertamos 8 registros en Equipos
INSERT INTO Equipo (descripcion, ID_cliente, ID_tecnico, ID_comprobante)
VALUES 
('Notebook HP - No enciende', 1, 1, 1),
('PC de escritorio - Limpieza de hardware', 2, 2, 2),
('MacBook Air - Cambio de batería', 1, 2, 1),
('All in One Lenovo - Pantalla rota', 2, 1, 2),
('Notebook Dell - Actualización a disco SSD', 1, 1, 1),
('PC Gamer - Armado completo y gestión de cables', 2, 2, 2),
('Impresora Epson - Limpieza de cabezales', 1, 2, 1),
('Consola PS5 - Mantenimiento térmico', 2, 1, 2);
GO

-- Insertamos 8 registros en Métodos de Pago
INSERT INTO Metodo_Pago (ID_comprobante, Descripcion)
VALUES 
(1, 'Tarjeta de Credito'),
(2, 'Transferencia Bancaria'),
(1, 'Efectivo'),
(2, 'Mercado Pago'),
(1, 'Tarjeta de Debito'),
(2, 'Cheque a 30 días'),
(1, 'MODO / Billetera Virtual'),
(2, 'Criptomonedas (USDT)');
GO

-- Insertamos 8 registros en Proveedores
-- (Asegurando que los CUITs sean únicos y no superen el límite de tipo INT)
INSERT INTO Proveedor (CUIT, Nombre, Mail)
VALUES 
(20111222, 'Distribuidora Informática', 'ventas@distribuidora.com'),
(20333444, 'Mayorista Tech', 'contacto@mayorista.com'),
(20444555, 'Insumos PC SA', 'info@insumospc.com.ar'),
(20555666, 'Hardware Global', 'ventas@hwglobal.com'),
(20666777, 'Cables y Redes SRL', 'b2b@cablesyredes.com'),
(20777888, 'Gaming Store Proveedores', 'pedidos@gamingstore.com.ar'),
(20888999, 'Repuestos Tech Corrientes', 'stock@repuestostech.com'),
(20999111, 'Importadora del Norte', 'comercial@importadora.com.ar');
GO

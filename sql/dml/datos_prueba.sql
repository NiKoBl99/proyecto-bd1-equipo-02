--SE REGISTRA PERSONA 1
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('87654321', 'ElGabo', 'Fava', '6666666666', 'elgabo666@email.com'); 
INSERT INTO Empresa (Nombre) VALUES ('Techo Store Corrientes Capital'); 
INSERT INTO cliente (ID_Persona) VALUES (1); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (1, 1); 

--SE REGISTRA PERSONA 2
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('34232323', 'Santi', 'Cardozo', '1234567890', 'santigg@email.com'); 
INSERT INTO Empresa (Nombre) VALUES ('Grido Tecnologia'); 
INSERT INTO cliente (ID_Persona) VALUES (2); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (2, 2); 

--SE REGISTRA PERSONA 3
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('32345234', 'Nico', 'Blanco', '3334445553', 'nicobk@email.com'); 
INSERT INTO Empresa (Nombre) VALUES ('Carrefour'); 
INSERT INTO cliente (ID_Persona) VALUES (3); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (3, 3); 

--SE REGISTRA PERSONA 4
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('343434232', 'Luciano', 'Gerez', '1223332221', 'lucgerz@email.com'); 
INSERT INTO Empresa (Nombre) VALUES ('Tecno Corrientes'); 
INSERT INTO cliente (ID_Persona) VALUES (4); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (4, 4); 

--SE REGISTRA PERSONA 5
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('342323414', 'Nico', 'Blanco', '3334445553', 'nicobk2@email.com'); 

INSERT INTO cliente (ID_Persona) VALUES (5); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (5, 3); 

--SE REGISTRA PERSONA 6
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('11345234', 'Nico', 'Negro', '3334445553', 'nicobk3@email.com'); 
INSERT INTO cliente (ID_Persona) VALUES (6); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (6, 3); 

--SE REGISTRA PERSONA 7
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('434141414', 'Nico', 'Torres', '3334445553', 'nicobk4@email.com'); 
INSERT INTO cliente (ID_Persona) VALUES (7); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (7, 3); 

--SE REGISTRA PERSONA 8
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES ('33344231', 'Lionel', 'Perez', '232342311', 'lmisss@email.com'); 
INSERT INTO Empresa (Nombre) VALUES ('RYR'); 
INSERT INTO cliente (ID_Persona) VALUES (8); 
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES (8, 5); 

INSERT INTO Comprobante (fecha_emision, tipo_emision)
VALUES 
    ('2026-09-01', 'Factura A'),
    ('2026-09-02', 'Factura B'),
    ('2026-09-05', 'Factura C'),
    ('2026-09-10', 'Ticket'),
    ('2026-09-12', 'Factura B'),
    ('2026-09-15', 'Factura A'),
    ('2026-09-18', 'Factura A'),
    ('2026-09-20', 'Ticket'),
GO


INSERT INTO Tecnico (ID_Persona, ID_Empresa)
VALUES 
    (1, 1), 
    (2, 1), 
    (3, 2), 
    (4, 2), 
    (5, 3), 
    (6, 3), 
    (7, 4), 
    (8, 4), 
GO

INSERT INTO Compra (ID_Comprobante, ID_Cliente)
VALUES 
    (1, 1),  
    (2, 2),  
    (3, 3),  
    (4, 4),  
    (5, 1),  
    (6, 2), 
    (7, 3),  
    (8, 4),
GO

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

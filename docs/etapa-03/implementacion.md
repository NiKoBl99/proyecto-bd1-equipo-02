# Implementación de la Base de Datos: Empresa de venta y servicio de Electronica 

## 1. Introducción
El presente documento detalla la implementación física (scripts SQL) de la base de datos diseñada para la gestión de una empresa dedicada a la venta de productos electrónicos y servicio técnico. El modelo relacional ha sido traducido a lenguaje SQL (Transact-SQL) estructurando adecuadamente las tablas maestras, transaccionales y de detalle.

## 2. Consideraciones de Diseño y Optimización
Durante el paso del modelo Entidad-Relación a la implementación en SQL Server, se aplicaron las siguientes optimizaciones para garantizar la integridad de los datos y el cumplimiento de la Tercera Forma Normal (3FN):

1. **Orden de Jerarquía:** Se estructuró la creación de tablas respetando las dependencias de las claves foráneas (Foreign Keys), iniciando por las tablas maestras fuertes (`Persona`, `Empresa`, `Comprobante`, `Proveedor`).
2. **Tipo de Dato CUIT:** Se modificó el tipo de dato del campo `CUIT` en la tabla `Proveedor` pasando de `INT` a `BIGINT`, ya que el formato de 11 dígitos de un CUIT supera el límite máximo del tipo entero tradicional.
3. **Claves Primarias en Tablas de Detalle:** Se incorporaron campos identificadores únicos (`ID_Detalle_Compra`, `ID_Detalle_Pago`) en las tablas de detalle para evitar conflictos de cardinalidad y permitir el registro de múltiples ítems bajo una misma transacción.

---

# Implementación de Base de Datos - Empresa de venta y servicio de Electronica 

## 1. Creación de Tablas

```sql
CREATE TABLE Persona(
    ID_Persona int identity (1,1) primary key,
    DNI VARCHAR (50) NOT NULL UNIQUE,
    Nombre Varchar (50) not null,
    Apellido varchar (50) not null,
    Telefono varchar (50) not null,
    Mail varchar (50) not null UNIQUE
);
GO

CREATE TABLE cliente (
    ID_Cliente int identity (1,1) primary key,
    ID_Persona int,
    constraint fk_Cliente_Persona FOREIGN KEY (ID_Persona) references Persona(ID_Persona) 
);
GO

CREATE TABLE Empresa(
    ID_Empresa int identity (1,1) primary key,
    Nombre varchar (50) not null
);
GO

CREATE TABLE Tecnico(
    ID_Tecnico int identity (1,1) primary key, 
    ID_Persona int,
    constraint fk_Tecnico_Persona FOREIGN KEY (ID_Persona) references Persona(ID_Persona),
    ID_Empresa int,
    constraint fk_Tecnico_Empresa FOREIGN KEY (ID_Empresa) references Empresa(ID_Empresa)
);
GO

CREATE TABLE Comprobante(
    ID_comprobante int identity (1,1) primary key,
    fecha_emision date, 
    tipo_emision varchar (50)
);
GO

CREATE TABLE Compra (
    ID_compra int identity (1,1) primary key,
    ID_Comprobante int,
    constraint fk_compra_comprobante FOREIGN KEY (ID_comprobante) references Comprobante(ID_comprobante),
    ID_Cliente int,
    constraint fk_compra_cliente FOREIGN KEY (ID_cliente) references Cliente (ID_cliente)
);
GO

CREATE TABLE Equipo (
    ID_equipo int identity (1,1) primary key,
    descripcion varchar (100),
    ID_cliente int,
    constraint fk_equipo_cliente FOREIGN KEY (ID_cliente) references Cliente(ID_cliente),
    ID_tecnico int,
    constraint fk_equipo_tecnico FOREIGN KEY (ID_tecnico) references Tecnico(ID_tecnico),
    ID_comprobante int,
    constraint fk_equipo_comprobante FOREIGN KEY (ID_comprobante) references Comprobante(ID_comprobante)
);
GO

CREATE TABLE Metodo_Pago (
    ID_Metodo int identity (1,1) primary key,
    ID_comprobante int,
    constraint fk_metodo_comprobante FOREIGN KEY (ID_Comprobante) references Comprobante(ID_Comprobante),
    Descripcion varchar (50) not null
);
GO

CREATE TABLE Proveedor (
    ID_Proveedor int identity (1,1) primary key,
    CUIT bigint unique not null,
    Nombre varchar (50),
    Mail varchar (50)
);
GO

CREATE TABLE Producto(
    ID_Producto int identity (1,1) primary key,
    Stock_producto int not null,
    Nombre_producto varchar (50) not null,
    Precio_producto decimal (10,2) not null,
    ID_Empresa int,
    constraint fk_producto_empresa FOREIGN KEY (ID_Empresa) references Empresa(ID_Empresa),
    ID_Proveedor int,
    constraint fk_producto_proveedor FOREIGN KEY (ID_Proveedor) references Proveedor(ID_Proveedor)
);
GO

CREATE TABLE Insumo(
    ID_Insumo int identity (1,1) primary key,
    Stock_insumo int not null,
    Nombre_insumo varchar (50) not null,
    Precio_insumo decimal (10,2) not null,
    ID_Empresa int,
    constraint fk_insumo_empresa FOREIGN KEY (ID_Empresa) references Empresa(ID_Empresa),
    ID_Proveedor int,
    constraint fk_insumo_proveedor FOREIGN KEY (ID_Proveedor) references Proveedor(ID_Proveedor)
);
GO

CREATE TABLE Detalle_Pago(
    ID_Metodo int,
    constraint fk_detalleP_metodo FOREIGN KEY (ID_Metodo) references Metodo_Pago(ID_Metodo),
    ID_Comprobante int,
    constraint fk_detalle_comprobante FOREIGN KEY (ID_Comprobante) references Comprobante(ID_Comprobante),
    Monto decimal (10,2) not null
);
GO

CREATE TABLE Factura(
    ID_Factura int identity (1,1) primary key,
    ID_Empresa int,
    constraint fk_factura_empresa FOREIGN KEY (ID_Empresa) references Empresa(ID_Empresa),
    ID_Proveedor int,
    constraint fk_factura_proveedor FOREIGN KEY (ID_Proveedor) references Proveedor(ID_Proveedor)
);
GO

-- ==========================================
-- 4. TABLAS DE TERCER NIVEL DE DEPENDENCIA
-- ==========================================

CREATE TABLE Detalle_Factura (
    ID_DetalleF int identity (1,1) primary key,
    Cantidad_Factura int not null,
    Precio_compra decimal (10,2) not null,
    ID_Factura int,
    constraint fk_detallef_factura FOREIGN KEY (ID_Factura) references Factura(ID_Factura),
    ID_Insumo int,
    constraint fk_detallef_insumo FOREIGN KEY (ID_Insumo) references Insumo(ID_Insumo),
    ID_Producto int,
    constraint fk_detallef_producto FOREIGN KEY (ID_Producto) references Producto(ID_Producto)
);
GO

CREATE TABLE Detalle_Compra(
    ID_Compra int identity (1,1) primary key,
    constraint fk_detallec_compra FOREIGN KEY (ID_Compra) references Compra(ID_Compra),
    ID_Producto int,
    constraint fk_detallec_producto FOREIGN KEY (ID_Producto) references Producto(ID_Producto),
    Cantidad_Compra int not null,
    Subtotal decimal (10,2) not null
);
GO

CREATE TABLE Detalle_Reparacion(
    ID_Detalle_Reparacion int identity (1,1) primary key,
    Cantidad int not null,
    ID_Equipo int,
    constraint fk_detaller_equipo FOREIGN KEY (ID_Equipo) references Equipo(ID_Equipo),
    ID_Insumo int,
    constraint fk_detaller_insumo FOREIGN KEY (ID_Insumo) references Insumo(ID_Insumo),
    ID_Producto int,
    constraint fk_detaller_producto FOREIGN KEY (ID_Producto) references Producto(ID_Producto)
);


GO
```
---

## 4. Script DML (Data Manipulation Language) - Población de Datos

Este script inserta los registros iniciales de prueba (Mock Data) estructurados respetando la integridad referencial.

```sql
-- 1. INSERCIONES EN TABLAS MAESTRAS (Sin dependencias)

-- PERSONAS
INSERT INTO Persona (DNI, Nombre, Apellido, Telefono, Mail) VALUES 
('87654321', 'ElGabo', 'Fava', '6666666666', 'elgabo666@email.com'),
('34232323', 'Santi', 'Cardozo', '1234567890', 'santigg@email.com'),
('32345234', 'Nico', 'Blanco', '3334445553', 'nicobk@email.com'),
('343434232', 'Luciano', 'Gerez', '1223332221', 'lucgerz@email.com'),
('342323414', 'Nico', 'Blanco', '3334445553', 'nicobk2@email.com'),
('11345234', 'Nico', 'Negro', '3334445553', 'nicobk3@email.com'),
('434141414', 'Nico', 'Torres', '3334445553', 'nicobk4@email.com'),
('33344231', 'Lionel', 'Perez', '232342311', 'lmisss@email.com');
GO

-- EMPRESAS
INSERT INTO Empresa (Nombre) VALUES 
('Techo Store Corrientes Capital'),
('Grido Tecnologia'),
('Carrefour'),
('Tecno Corrientes'),
('RYR');
GO

-- COMPROBANTES
INSERT INTO Comprobante (fecha_emision, tipo_emision) VALUES 
('2026-09-01', 'Factura A'),
('2026-09-02', 'Factura B'),
('2026-09-05', 'Factura C'),
('2026-09-10', 'Ticket'),
('2026-09-12', 'Factura B'),
('2026-09-15', 'Factura A'),
('2026-09-18', 'Factura A'),
('2026-09-20', 'Ticket');
GO

-- PROVEEDORES
INSERT INTO Proveedor (CUIT, Nombre, Mail) VALUES 
(20111222, 'Distribuidora Informática', 'ventas@distribuidora.com'),
(20333444, 'Mayorista Tech', 'contacto@mayorista.com'),
(20444555, 'Insumos PC SA', 'info@insumospc.com.ar'),
(20555666, 'Hardware Global', 'ventas@hwglobal.com'),
(20666777, 'Cables y Redes SRL', 'b2b@cablesyredes.com'),
(20777888, 'Gaming Store Proveedores', 'pedidos@gamingstore.com.ar'),
(20888999, 'Repuestos Tech Corrientes', 'stock@repuestostech.com'),
(20999111, 'Importadora del Norte', 'comercial@importadora.com.ar');
GO


-- 2. INSERCIONES EN TABLAS DE PRIMER NIVEL DE DEPENDENCIA

-- CLIENTES
INSERT INTO Cliente (ID_Persona) VALUES 
(1), (2), (3), (4), (5), (6), (7), (8);
GO

-- TÉCNICOS
INSERT INTO Tecnico (ID_Persona, ID_Empresa) VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 3), 
(6, 3), 
(7, 3), 
(8, 5);
GO

-- MÉTODOS DE PAGO
INSERT INTO Metodo_Pago (ID_comprobante, Descripcion) VALUES 
(1, 'Tarjeta de Credito'),
(2, 'Transferencia Bancaria'),
(1, 'Efectivo'),
(2, 'Mercado Pago'),
(1, 'Tarjeta de Debito'),
(2, 'Cheque a 30 días'),
(1, 'MODO / Billetera Virtual'),
(2, 'Criptomonedas (USDT)');
GO


-- 3. INSERCIONES EN TABLAS DE SEGUNDO NIVEL DE DEPENDENCIA

-- COMPRAS
INSERT INTO Compra (ID_Comprobante, ID_Cliente) VALUES 
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 1),  
(6, 2), 
(7, 3),  
(8, 4);
GO

-- EQUIPOS
INSERT INTO Equipo (descripcion, ID_cliente, ID_tecnico, ID_comprobante) VALUES 
('Notebook HP - No enciende', 1, 1, 1),
('PC de escritorio - Limpieza de hardware', 2, 2, 2),
('MacBook Air - Cambio de batería', 1, 2, 1),
('All in One Lenovo - Pantalla rota', 2, 1, 2),
('Notebook Dell - Actualización a disco SSD', 1, 1, 1),
('PC Gamer - Armado completo y gestión de cables', 2, 2, 2),
('Impresora Epson - Limpieza de cabezales', 1, 2, 1),
('Consola PS5 - Mantenimiento térmico', 2, 1, 2);
GO
```

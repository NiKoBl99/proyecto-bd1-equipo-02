# Implementación de la Base de Datos: Sistema de Ventas y Servicio Técnico de emepresa electronica 

## 1. Introducción
El presente documento detalla la implementación física (scripts SQL) de la base de datos diseñada para la gestión de una empresa dedicada a la venta de productos electrónicos y servicio técnico. El modelo relacional ha sido traducido a lenguaje SQL (Transact-SQL) estructurando adecuadamente las tablas maestras, transaccionales y de detalle.

## 2. Consideraciones de Diseño y Optimización
Durante el paso del modelo Entidad-Relación a la implementación en SQL Server, se aplicaron las siguientes optimizaciones para garantizar la integridad de los datos y el cumplimiento de la Tercera Forma Normal (3FN):

1. **Orden de Jerarquía:** Se estructuró la creación de tablas respetando las dependencias de las claves foráneas (Foreign Keys), iniciando por las tablas maestras fuertes (`Persona`, `Empresa`, `Comprobante`, `Proveedor`).
2. **Tipo de Dato CUIT:** Se modificó el tipo de dato del campo `CUIT` en la tabla `Proveedor` pasando de `INT` a `BIGINT`, ya que el formato de 11 dígitos de un CUIT supera el límite máximo del tipo entero tradicional.
3. **Claves Primarias en Tablas de Detalle:** Se incorporaron campos identificadores únicos (`ID_Detalle_Compra`, `ID_Detalle_Pago`) en las tablas de detalle para evitar conflictos de cardinalidad y permitir el registro de múltiples ítems bajo una misma transacción.

---

## 3. Script DDL (Data Definition Language) - Creación del Esquema

A continuación se detalla el script para la creación de las tablas y sus respectivas restricciones (Constraints).

```sql
-- ==========================================
-- 1. TABLAS MAESTRAS (Sin claves foráneas)
-- ==========================================
CREATE TABLE Persona(
    ID_Persona INT IDENTITY (1,1) PRIMARY KEY,
    DNI VARCHAR (50) NOT NULL UNIQUE,
    Nombre VARCHAR (50) NOT NULL,
    Apellido VARCHAR (50) NOT NULL,
    Telefono VARCHAR (50) NOT NULL,
    Mail VARCHAR (50) NOT NULL UNIQUE
);
GO

CREATE TABLE Empresa(
    ID_Empresa INT IDENTITY (1,1) PRIMARY KEY,
    Nombre VARCHAR (50) NOT NULL
);
GO

CREATE TABLE Comprobante(
    ID_comprobante INT IDENTITY (1,1) PRIMARY KEY,
    fecha_emision DATE, 
    tipo_emision VARCHAR (50)
);
GO

CREATE TABLE Proveedor (
    ID_Proveedor INT IDENTITY (1,1) PRIMARY KEY,
    CUIT BIGINT UNIQUE NOT NULL, 
    Nombre VARCHAR (50),
    Mail VARCHAR (50)
);
GO

-- ==========================================
-- 2. TABLAS DE PRIMER NIVEL DE DEPENDENCIA
-- ==========================================
CREATE TABLE Cliente (
    ID_Cliente INT IDENTITY (1,1) PRIMARY KEY,
    ID_Persona INT,
    CONSTRAINT fk_Cliente_Persona FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona) 
);
GO

CREATE TABLE Tecnico(
    ID_Tecnico INT IDENTITY (1,1) PRIMARY KEY, 
    ID_Persona INT,
    ID_Empresa INT,
    CONSTRAINT fk_Tecnico_Persona FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona),
    CONSTRAINT fk_Tecnico_Empresa FOREIGN KEY (ID_Empresa) REFERENCES Empresa(ID_Empresa)
);
GO

CREATE TABLE Metodo_Pago (
    ID_Metodo INT IDENTITY (1,1) PRIMARY KEY,
    ID_comprobante INT,
    Descripcion VARCHAR (50) NOT NULL,
    CONSTRAINT fk_metodo_comprobante FOREIGN KEY (ID_Comprobante) REFERENCES Comprobante(ID_Comprobante)
);
GO

CREATE TABLE Producto(
    ID_Producto INT IDENTITY (1,1) PRIMARY KEY,
    Stock_producto INT NOT NULL,
    Nombre_producto VARCHAR (50) NOT NULL,
    Precio_producto DECIMAL (10,2) NOT NULL,
    ID_Empresa INT,
    ID_Proveedor INT,
    CONSTRAINT fk_producto_empresa FOREIGN KEY (ID_Empresa) REFERENCES Empresa(ID_Empresa),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)
);
GO

CREATE TABLE Insumo(
    ID_Insumo INT IDENTITY (1,1) PRIMARY KEY,
    Stock_insumo INT NOT NULL,
    Nombre_insumo VARCHAR (50) NOT NULL,
    Precio_insumo DECIMAL (10,2) NOT NULL,
    ID_Empresa INT,
    ID_Proveedor INT,
    CONSTRAINT fk_insumo_empresa FOREIGN KEY (ID_Empresa) REFERENCES Empresa(ID_Empresa),
    CONSTRAINT fk_insumo_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)
);
GO

CREATE TABLE Factura(
    ID_Factura INT IDENTITY (1,1) PRIMARY KEY,
    ID_Empresa INT,
    ID_Proveedor INT,
    CONSTRAINT fk_factura_empresa FOREIGN KEY (ID_Empresa) REFERENCES Empresa(ID_Empresa),
    CONSTRAINT fk_factura_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)
);
GO

-- ==========================================
-- 3. TABLAS DE SEGUNDO NIVEL DE DEPENDENCIA
-- ==========================================
CREATE TABLE Compra (
    ID_compra INT IDENTITY (1,1) PRIMARY KEY,
    ID_Comprobante INT,
    ID_Cliente INT,
    CONSTRAINT fk_compra_comprobante FOREIGN KEY (ID_comprobante) REFERENCES Comprobante(ID_comprobante),
    CONSTRAINT fk_compra_cliente FOREIGN KEY (ID_cliente) REFERENCES Cliente (ID_cliente)
);
GO

CREATE TABLE Equipo (
    ID_equipo INT IDENTITY (1,1) PRIMARY KEY,
    descripcion VARCHAR (100),
    ID_cliente INT,
    ID_tecnico INT,
    ID_comprobante INT,
    CONSTRAINT fk_equipo_cliente FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente),
    CONSTRAINT fk_equipo_tecnico FOREIGN KEY (ID_tecnico) REFERENCES Tecnico(ID_tecnico),
    CONSTRAINT fk_equipo_comprobante FOREIGN KEY (ID_comprobante) REFERENCES Comprobante(ID_comprobante)
);
GO

CREATE TABLE Detalle_Pago(
    ID_Detalle_Pago INT IDENTITY (1,1) PRIMARY KEY,
    ID_Metodo INT,
    ID_Comprobante INT,
    Monto DECIMAL (10,2) NOT NULL,
    CONSTRAINT fk_detalleP_metodo FOREIGN KEY (ID_Metodo) REFERENCES Metodo_Pago(ID_Metodo),
    CONSTRAINT fk_detalle_comprobante FOREIGN KEY (ID_Comprobante) REFERENCES Comprobante(ID_Comprobante)
);
GO

CREATE TABLE Detalle_Factura (
    ID_DetalleF INT IDENTITY (1,1) PRIMARY KEY,
    Cantidad_Factura INT NOT NULL,
    Precio_compra DECIMAL (10,2) NOT NULL,
    ID_Factura INT,
    ID_Insumo INT,
    ID_Producto INT,
    CONSTRAINT fk_detallef_factura FOREIGN KEY (ID_Factura) REFERENCES Factura(ID_Factura),
    CONSTRAINT fk_detallef_insumo FOREIGN KEY (ID_Insumo) REFERENCES Insumo(ID_Insumo),
    CONSTRAINT fk_detallef_producto FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);
GO

-- ==========================================
-- 4. TABLAS DE TERCER NIVEL DE DEPENDENCIA
-- ==========================================
CREATE TABLE Detalle_Compra(
    ID_Detalle_Compra INT IDENTITY (1,1) PRIMARY KEY,
    ID_Compra INT,
    ID_Producto INT,
    Cantidad_Compra INT NOT NULL,
    Subtotal DECIMAL (10,2) NOT NULL,
    CONSTRAINT fk_detallec_compra FOREIGN KEY (ID_Compra) REFERENCES Compra(ID_Compra),
    CONSTRAINT fk_detallec_producto FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);
GO

CREATE TABLE Detalle_Reparacion(
    ID_Detalle_Reparacion INT IDENTITY (1,1) PRIMARY KEY,
    Cantidad INT NOT NULL,
    ID_Equipo INT,
    ID_Insumo INT,
    ID_Producto INT,
    CONSTRAINT fk_detaller_equipo FOREIGN KEY (ID_Equipo) REFERENCES Equipo(ID_Equipo),
    CONSTRAINT fk_detaller_insumo FOREIGN KEY (ID_Insumo) REFERENCES Insumo(ID_Insumo),
    CONSTRAINT fk_detaller_producto FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
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

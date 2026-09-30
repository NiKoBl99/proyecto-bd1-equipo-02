CREATE TABLE Persona
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    dni INT UNIQUE NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(30) UNIQUE,
    CONSTRAINT PK_PERSONA PRIMARY KEY (id_persona)
);
GO

CREATE TABLE Metodo_Pago
(
    id_metodo INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(20) NOT NULL,
    CONSTRAINT PK_METODO_PAGO PRIMARY KEY (id_metodo)
);
GO

CREATE TABLE Empresa
(
    id_empresa INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT PK_EMPRESA PRIMARY KEY (id_empresa)
);
GO

CREATE TABLE Proveedor
(
    id_proveedor INT IDENTITY(1,1) NOT NULL,
    cuit BIGINT UNIQUE NOT NULL, -- BIGINT por la longitud del CUIT
    nombre VARCHAR(40) NOT NULL,
    email VARCHAR(30),
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor)
);
GO

CREATE TABLE Cliente
(
    id_cliente INT IDENTITY(1,1) NOT NULL,
    id_persona INT,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (id_cliente)
);
GO

CREATE TABLE Tecnico
(
    id_tecnico INT IDENTITY(1,1) NOT NULL,
    id_persona INT,
    id_empresa INT,
    CONSTRAINT PK_TECNICO PRIMARY KEY (id_tecnico)
);
GO

CREATE TABLE Producto
(
    id_producto INT IDENTITY(1,1) NOT NULL,
    stock INT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_empresa INT,
    id_proveedor INT,
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto),
    CONSTRAINT CK_PRODUCTO_STOCK CHECK (stock >= 0),
    CONSTRAINT CK_PRODUCTO_PRECIO CHECK (precio >= 0)
);
GO

CREATE TABLE Insumo
(
    id_insumo INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    stock INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_empresa INT,
    id_proveedor INT,
    CONSTRAINT PK_INSUMO PRIMARY KEY (id_insumo),
    CONSTRAINT CK_INSUMO_STOCK CHECK (stock >= 0),
    CONSTRAINT CK_INSUMO_PRECIO CHECK (precio >= 0)
);
GO

CREATE TABLE Comprobante
(
    id_comprobante INT IDENTITY(1,1) NOT NULL,
    fecha_emision DATE NOT NULL,
    descripcion VARCHAR(20) NOT NULL, -- originalmente era "tipo_emision" me parece mas apropiado cambiarlo a descripcion
    CONSTRAINT PK_COMPROBANTE PRIMARY KEY (id_comprobante)
);
GO

CREATE TABLE Equipo
(
    id_equipo INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(40) NOT NULL,
    id_cliente INT,
    id_tecnico INT,
    id_comprobante INT,
    CONSTRAINT PK_EQUIPO PRIMARY KEY (id_equipo)
);
GO

CREATE TABLE Factura
(
    id_factura INT IDENTITY(1,1) NOT NULL,
    id_empresa INT,
    id_proveedor INT,
    CONSTRAINT PK_FACTURA PRIMARY KEY (id_factura)
);
GO

CREATE TABLE Compra
(
    id_compra INT IDENTITY(1,1) NOT NULL,
    id_cliente INT,
    id_comprobante INT,
    CONSTRAINT PK_COMPRA PRIMARY KEY (id_compra)
);
GO

CREATE TABLE Detalle_Pago
(
    id_comprobante INT,
    id_metodo INT,
    monto DECIMAL(10,2),
    CONSTRAINT PK_DETALLE_PAGO PRIMARY KEY (id_comprobante, id_metodo)
);
GO

CREATE TABLE Detalle_Reparacion
(
    id_detalle_reparacion INT IDENTITY(1,1) NOT NULL,
    cantidad INT,
    id_equipo INT,
    id_insumo INT,
    id_producto INT,
    CONSTRAINT PK_DETALLE_REPARACION PRIMARY KEY (id_detalle_reparacion)
);
GO

CREATE TABLE Detalle_Factura
(
    id_detalle_factura INT IDENTITY(1,1) NOT NULL,
    cantidad INT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    id_factura INT,
    id_insumo INT,
    id_producto INT,
    CONSTRAINT PK_DETALLE_FACTURA PRIMARY KEY (id_detalle_factura)
);
GO

CREATE TABLE Detalle_Compra
(
    id_compra INT,
    id_producto INT,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY (id_compra, id_producto)
);
GO

-- Claves foraneas
ALTER TABLE Cliente
ADD CONSTRAINT FK_Cliente_Persona
FOREIGN KEY (id_persona) REFERENCES Persona (id_persona);
GO

ALTER TABLE Tecnico
ADD CONSTRAINT FK_Tecnico_Persona
FOREIGN KEY (id_persona) REFERENCES Persona (id_persona),
    CONSTRAINT FK_Tecnico_Empresa
FOREIGN KEY (id_empresa) REFERENCES Empresa (id_empresa);
GO

ALTER TABLE Producto
ADD CONSTRAINT FK_Producto_Empresa
FOREIGN KEY (id_empresa) REFERENCES Empresa (id_empresa),
    CONSTRAINT FK_Producto_Proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedor (id_proveedor);
GO

ALTER TABLE Insumo
ADD CONSTRAINT FK_Insumo_Empresa
FOREIGN KEY (id_empresa) REFERENCES Empresa (id_empresa),
    CONSTRAINT FK_Insumo_Proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedor (id_proveedor);
GO

ALTER TABLE Equipo
ADD CONSTRAINT FK_Equipo_Cliente
FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente),
    CONSTRAINT FK_Equipo_Tecnico
FOREIGN KEY (id_tecnico) REFERENCES Tecnico (id_tecnico),
    CONSTRAINT FK_Equipo_Comprobante
FOREIGN KEY (id_comprobante) REFERENCES Comprobante (id_comprobante);
GO

ALTER TABLE Factura
ADD CONSTRAINT FK_Factura_Empresa
FOREIGN KEY (id_empresa) REFERENCES Empresa (id_empresa),
    CONSTRAINT FK_Factura_Proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedor (id_proveedor);
GO

ALTER TABLE Compra
ADD CONSTRAINT FK_Compra_Cliente
FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente),
    CONSTRAINT FK_Compra_Comprobante
FOREIGN KEY (id_comprobante) REFERENCES Comprobante (id_comprobante);
GO

ALTER TABLE Detalle_Pago
ADD CONSTRAINT FK_Detalle_Pago_Comprobante
FOREIGN KEY (id_comprobante) REFERENCES Comprobante (id_comprobante),
    CONSTRAINT FK_Detalle_Pago_Metodo
FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago (id_metodo);
GO

ALTER TABLE Detalle_Reparacion
ADD CONSTRAINT FK_Detalle_Reparacion_Equipo
FOREIGN KEY (id_equipo) REFERENCES Equipo (id_equipo),
    CONSTRAINT FK_Detalle_Reparacion_Insumo
FOREIGN KEY (id_insumo) REFERENCES Insumo (id_insumo),
    CONSTRAINT FK_Detalle_Reparacion_Producto
FOREIGN KEY (id_producto) REFERENCES Producto (id_producto);
GO

ALTER TABLE Detalle_Factura
ADD CONSTRAINT FK_Detalle_Factura_Factura
FOREIGN KEY (id_factura) REFERENCES Factura (id_factura),
    CONSTRAINT FK_Detalle_Factura_Insumo
FOREIGN KEY (id_insumo) REFERENCES Insumo (id_insumo),
    CONSTRAINT FK_Detalle_Factura_Producto
FOREIGN KEY (id_producto) REFERENCES Producto (id_producto);
GO

ALTER TABLE Detalle_Compra
ADD CONSTRAINT FK_Detalle_Compra_Compra
FOREIGN KEY (id_compra) REFERENCES Compra (id_compra),
    CONSTRAINT FK_Detalle_Compra_Producto
FOREIGN KEY (id_producto) REFERENCES Producto (id_producto);
GO

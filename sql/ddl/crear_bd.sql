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

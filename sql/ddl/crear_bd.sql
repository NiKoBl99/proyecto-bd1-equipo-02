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

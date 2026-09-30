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
    ID_Detalle_Compra int identity (1,1) primary key,
    ID_Compra int, 
    constraint fk_detallec_compra FOREIGN KEY (ID_Compra) references Compra(ID_Compra),
    ID_Producto int, constraint fk_detallec_producto FOREIGN KEY (ID_Producto) references Producto(ID_Producto),
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

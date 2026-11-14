CREATE DATABASE SistemaVentasYservicios
    
CREATE TABLE dbo.Persona (
    ID_Persona INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DNI        VARCHAR(50) NOT NULL UNIQUE,
    Nombre     VARCHAR(50) NOT NULL,
    Apellido   VARCHAR(50) NOT NULL,
    Telefono   VARCHAR(50) NOT NULL,
    Mail       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.Empresa (
    ID_Empresa INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre     VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Proveedor (
    ID_Proveedor INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CUIT         BIGINT NOT NULL UNIQUE,
    Nombre       VARCHAR(50) NULL,
    Mail         VARCHAR(50) NULL
);

CREATE TABLE dbo.Comprobante (
    ID_comprobante INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fecha_emision  DATE NULL,
    tipo_emision   VARCHAR(50) NULL
);

CREATE TABLE dbo.cliente (
    ID_Cliente INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_Persona INT NULL,
    CONSTRAINT fk_Cliente_Persona FOREIGN KEY (ID_Persona) REFERENCES dbo.Persona(ID_Persona)
);

CREATE TABLE dbo.Tecnico (
    ID_Tecnico INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_Persona INT NULL,
    ID_Empresa INT NULL,
    CONSTRAINT fk_Tecnico_Persona FOREIGN KEY (ID_Persona) REFERENCES dbo.Persona(ID_Persona),
    CONSTRAINT fk_Tecnico_Empresa FOREIGN KEY (ID_Empresa) REFERENCES dbo.Empresa(ID_Empresa)
);

CREATE TABLE dbo.Producto (
    ID_Producto     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Stock_producto  INT NOT NULL,
    Nombre_producto VARCHAR(50) NOT NULL,
    Precio_producto DECIMAL(10,2) NOT NULL,
    ID_Empresa      INT NULL,
    ID_Proveedor    INT NULL,
    CONSTRAINT fk_producto_empresa   FOREIGN KEY (ID_Empresa)   REFERENCES dbo.Empresa(ID_Empresa),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES dbo.Proveedor(ID_Proveedor)
);

CREATE TABLE dbo.Insumo (
    ID_Insumo     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Stock_insumo  INT NOT NULL,
    Nombre_insumo VARCHAR(50) NOT NULL,
    Precio_insumo DECIMAL(10,2) NOT NULL,
    ID_Empresa    INT NULL,
    ID_Proveedor  INT NULL,
    CONSTRAINT fk_insumo_empresa   FOREIGN KEY (ID_Empresa)   REFERENCES dbo.Empresa(ID_Empresa),
    CONSTRAINT fk_insumo_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES dbo.Proveedor(ID_Proveedor)
);

CREATE TABLE dbo.Metodo_Pago (
    ID_Metodo      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_comprobante INT NULL,
    Descripcion    VARCHAR(50) NOT NULL,
    CONSTRAINT fk_metodo_comprobante FOREIGN KEY (ID_comprobante) REFERENCES dbo.Comprobante(ID_comprobante)
);

CREATE TABLE dbo.Equipo (
    ID_equipo      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion    VARCHAR(100) NULL,
    ID_cliente     INT NULL,
    ID_tecnico     INT NULL,
    ID_comprobante INT NULL,
    CONSTRAINT fk_equipo_cliente     FOREIGN KEY (ID_cliente)     REFERENCES dbo.cliente(ID_Cliente),
    CONSTRAINT fk_equipo_tecnico     FOREIGN KEY (ID_tecnico)     REFERENCES dbo.Tecnico(ID_Tecnico),
    CONSTRAINT fk_equipo_comprobante FOREIGN KEY (ID_comprobante) REFERENCES dbo.Comprobante(ID_comprobante)
);

CREATE TABLE dbo.Compra (
    ID_compra      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_Comprobante INT NULL,
    ID_Cliente     INT NULL,
    CONSTRAINT fk_compra_comprobante FOREIGN KEY (ID_Comprobante) REFERENCES dbo.Comprobante(ID_comprobante),
    CONSTRAINT fk_compra_cliente     FOREIGN KEY (ID_Cliente)     REFERENCES dbo.cliente(ID_Cliente)
);

CREATE TABLE dbo.Factura (
    ID_Factura   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_Empresa   INT NULL,
    ID_Proveedor INT NULL,
    CONSTRAINT fk_factura_empresa   FOREIGN KEY (ID_Empresa)   REFERENCES dbo.Empresa(ID_Empresa),
    CONSTRAINT fk_factura_proveedor FOREIGN KEY (ID_Proveedor) REFERENCES dbo.Proveedor(ID_Proveedor)
);

CREATE TABLE dbo.Detalle_Compra (
    ID_Detalle_Compra INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_Compra         INT NULL,
    ID_Producto       INT NULL,
    Cantidad_Compra   INT NOT NULL,
    Precio_Unitario   DECIMAL(10,2) NOT NULL,
    Subtotal          DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detallec_compra   FOREIGN KEY (ID_Compra)   REFERENCES dbo.Compra(ID_compra),
    CONSTRAINT fk_detallec_producto FOREIGN KEY (ID_Producto) REFERENCES dbo.Producto(ID_Producto)
);

CREATE TABLE dbo.Detalle_Factura (
    ID_DetalleF      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Cantidad_Factura INT NOT NULL,
    Precio_compra    DECIMAL(10,2) NOT NULL,
    ID_Factura       INT NULL,
    ID_Insumo        INT NULL,
    ID_Producto      INT NULL,
    CONSTRAINT fk_detallef_factura  FOREIGN KEY (ID_Factura)  REFERENCES dbo.Factura(ID_Factura),
    CONSTRAINT fk_detallef_insumo   FOREIGN KEY (ID_Insumo)   REFERENCES dbo.Insumo(ID_Insumo),
    CONSTRAINT fk_detallef_producto FOREIGN KEY (ID_Producto) REFERENCES dbo.Producto(ID_Producto)
);

CREATE TABLE dbo.Detalle_Pago (
    ID_Metodo      INT NULL,
    ID_Comprobante INT NULL,
    Monto          DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalleP_metodo      FOREIGN KEY (ID_Metodo)      REFERENCES dbo.Metodo_Pago(ID_Metodo),
    CONSTRAINT fk_detalle_comprobante  FOREIGN KEY (ID_Comprobante) REFERENCES dbo.Comprobante(ID_comprobante)
);

CREATE TABLE dbo.Detalle_Reparacion (
    ID_Detalle_Reparacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Cantidad              INT NOT NULL,
    ID_Equipo             INT NULL,
    ID_Insumo             INT NULL,
    ID_Producto           INT NULL,
    CONSTRAINT fk_detaller_equipo   FOREIGN KEY (ID_Equipo)   REFERENCES dbo.Equipo(ID_equipo),
    CONSTRAINT fk_detaller_insumo   FOREIGN KEY (ID_Insumo)   REFERENCES dbo.Insumo(ID_Insumo),
    CONSTRAINT fk_detaller_producto FOREIGN KEY (ID_Producto) REFERENCES dbo.Producto(ID_Producto)
);

CREATE TABLE dbo.auditoria_producto (
    ID_Auditoria    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Fecha_Hora      DATETIME NOT NULL DEFAULT GETDATE(),
    Usuario         VARCHAR(100) NOT NULL,
    ID_Producto     INT NOT NULL,
    Nombre_producto VARCHAR(50) NOT NULL,
    Precio_anterior DECIMAL(10,2) NULL,
    Precio_nuevo    DECIMAL(10,2) NULL,
    Operacion       VARCHAR(20) NOT NULL
);

GO

# Modelo Relacional

A continuación se detalla el esquema relacional obtenido a partir del pasaje a tablas:

* **PERSONA** (ID_Persona, Nombre, Apellido, DNI, Mail)
* **CLIENTE** (ID_Cliente, fk_PERSONA)
* **TECNICO** (ID_Tecnico, fk_PERSONA, fk_EMPRESA)
* **PROVEEDOR** (ID_Proveedor, CUIT, Nombre, Mail)
* **INSUMO** (ID_Insumo, Nombre_insumo, Stock_insumo, Precio_insumo, fk_TECNICO, fk_EMPRESA, fk_PROVEEDOR)
* **EQUIPO** (ID_Equipo, Descripcion, fk_CLIENTE, fk_TECNICO, fk_COMPROBANTE)
* **COMPROBANTE** (ID_Comprobante, Fecha_emision, Tipo_emision)
* **METODO_PAGO** (ID_Metodo, Descripcion, fk_COMPROBANTE)
* **COMPRA** (ID_Compra, fk_CLIENTE, fk_COMPROBANTE, fk_PRODUCTO)
* **PRODUCTO** (ID_Producto, Stock_producto, Nombre_producto, Precio_producto, fk_EMPRESA, fk_PROVEEDOR)
* **EMPRESA** (ID_Empresa, Nombre)
* **FACTURA** (ID_Factura, fk_EMPRESA, fk_INSUMO, fk_PRODUCTO, fk_PROVEEDOR)
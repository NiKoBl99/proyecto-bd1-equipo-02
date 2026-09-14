# Decisiones de Diseño

## Decisiones de Diseño del Sistema

* **DD1 Abstracción Mediante Supertipo/Subtipo:** Se utiliza una entidad general _Persona_ que almacena los atributos obligatorios exigidos (ID, Nombre, Apellido, DNI, Correo, Teléfono). De esta entidad derivan _Cliente_ y _Técnico_. Esta decisión evita la redundancia de datos en caso de que un empleado técnico también consuma servicios o productos de la empresa.
* **DD2 Segregación del Inventario:** El modelo separa conceptualmente _Producto_ e _Insumo_. Esta decisión permite flujos de trabajo paralelos. Ambos mantienen una relación estricta con la entidad _Proveedor_, lo que garantiza la exclusividad de suministro exigida por la RN 6.
* **DD3 El Equipo como Eje del Servicio Técnico:** La entidad _Equipo_ actúa como el núcleo transaccional de la reparación. Posee relaciones directas con el _Cliente_ (dueño), con un único _Técnico_ y genera un _Comprobante_ final, lo que permite respaldar la gestión de garantías.
* **DD4 Unificación del Modelo de Ingresos:** Se independiza la entidad _Comprobante_. Este recibe flujos de dos orígenes: operaciones de mostrador (a través de la entidad _Compra_) y servicios técnicos (a través de la entidad _Equipo_). A su vez, se vincula con *Método_pago*, permitiendo registrar la forma en la que el cliente abona el total de la operación.

# Reglas de Negocio

* **RN 1 (Registro de clientes):** Todo cliente que solicite una reparación o realice una compra debe ser registrado obligatoriamente en el sistema con los siguientes atributos: ID, nombre, apellido, teléfono, correo electrónico y DNI[cite: 3].
* **RN 2 (Control de stock):** Al concretarse una venta de productos, el sistema debe descontar automáticamente las unidades correspondientes del stock disponible en el inventario[cite: 3].
* **RN 3 (Uso de insumos en reparaciones):** Los productos e insumos utilizados durante un servicio de reparación deben registrarse en la orden de trabajo para ser descontados del stock general del negocio[cite: 3].
* **RN 4 (Emisión de comprobantes):** Toda venta o servicio de reparación finalizado debe generar un comprobante (ticket) asociado al cliente, el cual servirá como respaldo para la gestión de garantías ante posibles fallas[cite: 3].
* **RN 5 (Asignación de técnicos):** Cuando se entrega un equipo para reparar se le asigna a un técnico[cite: 3]. Un técnico puede tener varios equipos para reparación, pero un equipo no puede tener más de un técnico asignado[cite: 3].
* **RN 6 (Exclusividad de proveedores):** Un proveedor puede suministrar múltiples productos diferentes, pero un producto específico pertenece a un único proveedor exclusivo[cite: 3].
* **RN 7 (Métodos de pago):** Toda venta o pago de servicio debe estar asociada obligatoriamente a al menos un método de pago válido (tarjeta de débito, tarjeta de crédito, efectivo, transferencia o cheque)[cite: 3].
* **RN 8 (Historial de precios):** En cada venta o detalle de compra se debe almacenar el precio unitario del producto en ese momento exacto, evitando que cambios futuros afecten los registros pasados[cite: 3].

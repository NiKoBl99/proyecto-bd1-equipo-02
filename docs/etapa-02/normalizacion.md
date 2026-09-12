# Documentación de la Normalización

## Primera Forma Normal (1FN)
Cada celda debe tener un solo valor y no puede haber grupo de celdas repetidas[cite: 4]. 
* **Ejemplo:** Dentro de nuestra tabla relacional solo existen valores atómicos[cite: 4]. Como se observa en la tabla `INSUMO`, cada atributo (Nombre_insumo, Stock_insumo, Precio_insumo) contiene un único valor.

## Segunda Forma Normal (2FN)
No existen entidades las cuales posean una clave compuesta o lo que es lo mismo todas las entidades del esquema relacional tienen una clave primaria propia[cite: 4]. 
* **Ejemplo:** También en la tabla que realizamos se puede evidenciar que no existe ninguna compuesta o tabla intermedia[cite: 4]. Cada tabla principal se identifica con su propio ID simple (ej. `ID_Empresa`, `ID_Factura`).

## Tercera Forma Normal (3FN)
Nuestro esquema relacional cumple la tercera forma normalización, ya que los atributos que no son claves dependen directamente de su clave principal[cite: 4]. 
* **Ejemplo:** El nombre de la persona no aparece reflejado directamente en la tabla cliente, sino que en la tabla cliente lo muestra a través del (id_persona)[cite: 4].

Seguridad: permisos a nivel de usuarios y roles

Definición y objetivo

Controlar quién accede a la información y qué operaciones puede realizar, aplicando el principio de mínimo privilegio. Los permisos pueden darse a usuarios individuales o agruparse en roles reutilizables.
Ventajas y aplicaciones

•	Protegen datos sensibles y evitan modificaciones accidentales o no autorizadas.
•	Los roles simplifican la administración: se cambia el permiso del rol y no el de cada usuario.
•	Con procedimientos almacenados, un usuario puede ejecutar una operación autorizada sin tener permiso de escritura directo sobre las tablas (cadena de propiedad).

Implementación en SQL Server Express
Se usan CREATE LOGIN (nivel servidor), CREATE USER (nivel base), ALTER ROLE ... ADD MEMBER, CREATE ROLE, GRANT, DENY y REVOKE. Para que los inicios de sesión SQL funcionen, la instancia debe tener habilitada la autenticación mixta (Windows y SQL Server). Las pruebas usan EXECUTE AS USER para simular a cada usuario sin reconectarse.
Caso aplicado al sistema

•	usuario_admin: dueño de la base (db_owner), puede insertar directamente.
•	usuario_lector: solo puede leer Compra y ejecutar sp_RegistrarVentaCompleta; no puede insertar directamente en Compra.
•	rol_consulta_productos: rol con SELECT sobre Producto; usuario_con_rol pertenece a él y usuario_sin_rol no.



# Seguridad: permisos a nivel de usuarios y roles

## Definición y objetivo

Controlar quién accede a la información y qué operaciones puede realizar, aplicando el **principio de mínimo privilegio**. Los permisos pueden darse a usuarios individuales o agruparse en **roles** reutilizables.

## Ventajas y aplicaciones

* Protegen datos sensibles y evitan modificaciones accidentales o no autorizadas.
* Los roles simplifican la administración: se cambia el permiso del rol y no el de cada usuario.
* Con procedimientos almacenados, un usuario puede ejecutar una operación autorizada sin tener permiso de escritura directo sobre las tablas (cadena de propiedad).

## Implementación en SQL Server Express

Se usan `CREATE LOGIN` (nivel servidor), `CREATE USER` (nivel base), `ALTER ROLE ... ADD MEMBER`, `CREATE ROLE`, `GRANT`, `DENY` y `REVOKE`. Para que los inicios de sesión SQL funcionen, la instancia debe tener habilitada la **autenticación mixta** (Windows y SQL Server). Las pruebas usan `EXECUTE AS USER` para simular a cada usuario sin reconectarse.

## Caso aplicado al sistema

* `usuario_admin`: dueño de la base (`db_owner`), puede insertar directamente.
* `usuario_lector`: solo puede leer `Compra` y **ejecutar** `sp_RegistrarVentaCompleta`; no puede insertar directamente en `Compra`.
* `rol_consulta_productos`: rol con `SELECT` sobre `Producto`; `usuario_con_rol` pertenece a él y `usuario_sin_rol` no.

## Script de demostración

```sql
-- Parte 1: permisos a usuarios
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
GO
USE SistemaVentas;
GO
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_lector FOR LOGIN usuario_lector;
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GRANT SELECT ON dbo.Compra TO usuario_lector;
GRANT EXECUTE ON dbo.sp_RegistrarVentaCompleta TO usuario_lector;
GO

-- Parte 2: permisos por rol
CREATE LOGIN usuario_con_rol WITH PASSWORD = 'Rol123*';
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'Rol456*';
GO
CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
CREATE ROLE rol_consulta_productos;
GRANT SELECT ON dbo.Producto TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO

-- PRUEBAS (cada una simula al usuario y vuelve con REVERT)
-- 1) Admin: INSERT directo -> correcto
EXECUTE AS USER = 'usuario_admin';
    INSERT INTO Comprobante(fecha_emision, tipo_emision) VALUES (GETDATE(), 'Prueba');
    INSERT INTO Compra(ID_Comprobante, ID_Cliente) VALUES (SCOPE_IDENTITY(), 1);
    PRINT 'Admin: INSERT correcto';
REVERT;

-- 2) Lector: INSERT directo -> denegado
EXECUTE AS USER = 'usuario_lector';
BEGIN TRY
    INSERT INTO Compra(ID_Comprobante, ID_Cliente) VALUES (1, 1);
END TRY
BEGIN CATCH
    PRINT 'Lector INSERT directo: ' + ERROR_MESSAGE();
END CATCH;
REVERT;

-- 3) Lector: ejecuta el procedimiento -> correcto
EXECUTE AS USER = 'usuario_lector';
    EXEC dbo.sp_RegistrarVentaCompleta @ID_Cliente = 1, @ID_Producto = 1, @Cantidad = 1;
REVERT;

-- 4) Usuario con rol: SELECT sobre Producto -> correcto
EXECUTE AS USER = 'usuario_con_rol';
    SELECT * FROM Producto;
REVERT;

-- 5) Usuario sin rol: SELECT sobre Producto -> denegado
EXECUTE AS USER = 'usuario_sin_rol';
BEGIN TRY
    SELECT * FROM Producto;
END TRY
BEGIN CATCH
    PRINT 'Sin rol SELECT: ' + ERROR_MESSAGE();
END CATCH;
REVERT;
```

## Resultados esperados

| Prueba | Usuario | Resultado |
| :--- | :--- | :--- |
| `SELECT` sobre `Producto` | `usuario_con_rol` | Correcto |
| `SELECT` sobre `Producto` | `usuario_sin_rol` | Acceso denegado (error 229/230) |
| `INSERT` directo sobre `Compra` | `usuario_admin` | Correcto |
| `INSERT` directo sobre `Compra` | `usuario_lector` | Acceso denegado (error 229) |
| `EXEC sp_RegistrarVentaCompleta` | `usuario_lector` | Correcto, aunque no tiene `INSERT` sobre las tablas |

**Conclusión:** el lector no puede modificar tablas directamente, pero sí realizar la operación autorizada a través del procedimiento, que mantiene las reglas de negocio (stock, descuento, transacción).

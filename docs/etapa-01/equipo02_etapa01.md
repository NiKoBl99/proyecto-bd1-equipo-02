# Contribución individual -- Etapa 01
**Equipo:** 02
**Integrante:** Nicolas Gustavo Blanco
**Fecha:** 2026-09-12

## 1. Aporte realizado
Inicialización del repositorio del equipo en GitHub y creación de la estructura de directorios base solicitada por la cátedra (`docs/` y `sql/`). Además, realicé la integración y formateo en Markdown de la introducción del caso de estudio y las reglas de negocio (RN 1 a RN 8) en sus respectivos archivos.

## 2. Decisiones en las que participé
Participé en la organización inicial del entorno de trabajo del grupo, estableciendo la base del control de versiones y asegurando que la documentación del dominio quedara correctamente plasmada en el sistema de archivos del proyecto.

## 3. Problemas o dificultades identificadas
Durante la configuración inicial, me encontré con varias dificultades técnicas al usar la terminal y Git por primera vez:
- Falta de configuración de la identidad global de Git (`user.email` y `user.name`), lo que impedía realizar los commits.
- Desincronización entre el repositorio local y el remoto en GitHub al haber modificado archivos directamente en la web.
- Bloqueo en la terminal al abrirse el editor Vim (pantalla negra) durante la ejecución de un `git pull`, lo que dificultó completar la mezcla de archivos.

## 4. Soluciones o propuestas realizadas
- Se configuraron exitosamente las credenciales usando los comandos `git config --global`.
- Para solucionar el conflicto de desincronización y evadir el bloqueo de Vim, apliqué comandos específicos en la terminal de Visual Studio Code para abortar la mezcla (`git merge --abort`) y luego forcé una descarga sin entrar al editor mediante `git pull origin main --no-edit`. Finalmente, logré subir todos los archivos con `git push`.

## 5. Evidencias en el repositorio
- `docs/etapa-01/descripcion-caso.md`
- `docs/etapa-01/reglas-negocio.md`
- Commits: "Agrega estructura de carpetas base requerida por la cátedra", "Estructura inicial de carpetas y archivos del proyecto", "Agrega descripción del caso y reglas de negocio de la Etapa 1".

## 6. Reflexión individual
¿Qué concepto o competencia de Bases de Datos I considero que desarrollé en esta etapa?
Desarrollé fuertemente la competencia del uso de herramientas de control de versiones (Git y GitHub) integradas con Visual Studio Code. Aprendí a inicializar repositorios, manejar el ciclo de trabajo básico (add, commit, push) y a comprender cómo resolver problemas de sincronización entre el entorno local y la nube; habilidades fundamentales para el trabajo colaborativo a lo largo de toda la materia.

# Contribución individual -- Etapa 01
**Equipo:** 02
**Integrante:** Gabriel Fava
**Fecha:** 2026-09-14

## 1. Aporte realizado
Colaboré activamente en el diagramado inicial del sistema, la definición de las entidades y la selección de los atributos que el mismo requería. En cuanto a la gestión del repositorio en GitHub, redacté y añadí la documentación correspondiente al alcance del sistema y las decisiones de diseño tomadas para su confección.

## 2. Decisiones en las que participé
Participé en la elección del dominio del sistema (electrónica), la creación de la entidad _Metodo_pago_ relacionada con _Comprobante_ para evitar la redundancia de datos, y la inclusión de la entidad _Factura_ para separar estructuralmente el flujo de reabastecimiento interno (compras a proveedores) del flujo de ingresos por ventas y reparaciones.

## 3. Problemas o dificultades identificadas
Dificultad para consensuar la cardinalidad en las relaciones de componentes consumibles (insumos) y cómo reflejar el historial de precios sin alterar las tablas maestras, lo cual resolvimos ajustando las reglas de negocio.

## 4. Soluciones o propuestas realizadas
Propuse añadir las siguientes Reglas de Negocio:
- **RN 4 (Emisión de Comprobantes)** Para formalizar el cierre de las operaciones, asegurando que tanto las ventas de mostrador como las reparaciones finalizadas cuenten con un respaldo documental unificado, el cual es indispensable para la posterior validación y gestión de garantías.
- **RN 7 (Metodos de pago)** Para establecer un control estricto y auditable sobre los ingresos, garantizando que toda transacción quede vinculada obligatoriamente a canales financieros válidos y estructurados, evitando registros huérfanos o ambiguos.

## 5. Evidencias en el repositorio
- `docs/etapa-01/alcance.md`
- `docs/etapa-01/decisiones-diseno.md`
- Commits: "alcance del sistema en Etapa 1 en alcance.md", "añado Decisiones de Diseño en decisiones-diseno.md".

## 6. Reflexión individual
¿Qué concepto o competencia de Bases de Datos I considero que desarrollé en esta etapa?
Durante esta etapa considero que desarrollé la competencia de abstracción y modelado conceptual de datos. Aprendí a interpretar reglas de negocio expresadas en lenguaje natural y traducirlas en un modelo estructurado y lógico (Diagrama Entidad-Relación). Específicamente, mejoré mi capacidad para identificar entidades transaccionales (como la reparación de equipos) frente a entidades paramétricas (como los métodos de pago), y a definir cardinalidades precisas que garanticen la integridad de los datos, previniendo redundancias o inconsistencias futuras en el diseño de la base de datos.

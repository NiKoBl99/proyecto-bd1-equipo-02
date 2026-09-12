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

# proyecto-bd1-equipo-02
# Proyecto Integrador - Bases de Datos I

**Universidad Nacional del Nordeste (UNNE)**  
**Facultad de Ciencias Exactas y Naturales y Agrimensura (FaCENA)**  
**Carrera:** Licenciatura en Sistemas de Información

---

## 👥 Equipo 02
- Aiello, Mariano
- Blanco, Nicolas Gustavo
- Cardozo Candia, Santiago
- Fava, Gabriel 
- Gerez, Luciano Andres

## 📋 Caso de Estudio
**Empresa de Venta y Servicio de Electrónica:** Sistema de información para la gestión unificada del registro de clientes, flujo de stock de insumos/productos suministrados por proveedores, y administración de órdenes de reparación técnicas.

## 📂 Estructura del Repositorio
El proyecto está organizado de la siguiente forma:

```text
proyecto-bd1-equipo-02/
├── docs/
│   ├── etapa-01/
│   │   ├── descripcion-caso.md
│   │   ├── alcance.md
│   │   ├── reglas-negocio.md
│   │   └── decisiones-diseno.md
│   ├── etapa-02/
│   │   ├── der/
│   │   │   └── der.png
│   │   ├── modelo-relacional.md
│   │   ├── normalizacion.md
│   │   └── decisiones-diseno.md
│   ├── etapa-03/
│   │   ├── implementacion.md
│   │   ├── restricciones-integridad.md
│   │   └── pruebas-validacion.md
│   ├── etapa-04/
│   │   ├── casos-uso.md
│   │   ├── comprobante-venta.md
│   │   ├── informe-ventas.md
│   │   └── consulta-avanzada.md
│   └── etapa-05/
│       ├── procedimientos_funciones/
│       │   ├── investigacion.md
│       │   ├── scripts.sql
│       │   └── evidencias/
│       ├── transacciones/
│       │   ├── investigacion.md
│       │   ├── scripts.sql
│       │   └── evidencias/
│       ├── triggers_auditoria/
│       │   ├── investigacion.md
│       │   ├── scripts.sql
│       │   └── evidencias/
│       ├── indices-optimizacion.md
│       └── seguridad.md
├── sql/
│   ├── ddl/
│   │   └── crear_bd.sql
│   ├── dml/
│   │   └── datos_prueba.sql
│   └── consultas/
│       ├── comprobante_venta.sql
│       ├── informe_ventas.sql
│       └── consulta_avanzada.sql
└── README.md

```

## 🛠️ Tecnologías Utilizadas

**SGBD:** Microsoft SQL Server
**Modelado:** ERDPlus / Draw.io
**Documentación y Control de Versiones:** Markdown, Git & GitHub


## 🚀 Cómo Ejecutar los Scripts
1. Clonar el repositorio: `git clone https://github.com/NiKoBl99/proyecto-bd1-equipo-02.git`
2. Abrir **SQL Server Management Studio (SSMS)**.
3. Ejecutar los scripts en orden:
   - `sql/ddl/crear_bd.sql` (Crea la base de datos, tablas y restricciones)
   - `sql/dml/datos_prueba.sql` (Inserta datos de prueba)

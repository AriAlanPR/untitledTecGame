# Changelog

Todos los cambios notables en este proyecto se documentarán en este archivo.
El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y este proyecto sigue [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Estructura Documental**: Reorganización de la carpeta `docs/` con `backlog.md`, `roadmap.md`, `changelog.md` y `observations.md`.
- **Material Formativo**: Clasificación de las notas y sesiones del curso bajo `docs/referencia-curso/` como base histórica del proyecto.
- **Evolución del Proyecto**: Reenfoque formal de la arquitectura de un taller/curso hacia una implementación de videojuego completo en Flutter + Flame.
- **Auditoría Técnica**: Documento de descubrimiento técnico para la migración de `GameCoronaTec` (Corona SDK) hacia Flutter + Flame en `docs/auditoria/migrar-corona-a-flame.md`.
- **OpenSpec**: Inicialización del sistema de especificaciones en `openspec/` con el change propuesto `setup-assets-and-dependencies`.

---

## [0.1.0] - 2024-10-21

### Added
- Interfaz gráfica inicial con Flutter (`StartMenu`, `ScoreMenuPage`, `ConfigurationPage`).
- Animaciones de partículas y transiciones cúbicas de pantalla.
- Wrapper básico de Flame (`GameApp`, `GameScope`, componentes de prueba).
- Localización multi-idioma (Español / Inglés) con `localization` y `assets/i18n`.
- Utilidades de almacenamiento local (`PersistentData` con `shared_preferences`).

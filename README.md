# untitled_tec_game

Videojuego arcade 2D completo desarrollado con **Flutter** y **Flame**, evolucionado a partir de un prototipo formativo inicial y la migración del juego espacial de Corona SDK (`GameCoronaTec`). El proyecto está estructurado con una arquitectura modular y escalable para convertirse en una experiencia de juego completa y multiplataforma (Móvil y Web).

---

## Documentación del Proyecto

Toda la documentación técnica, planificación y seguimiento se encuentra en la carpeta [`docs/`](docs/):

- 🗺️ **[Roadmap](docs/roadmap.md)**: Visión del producto, fases del desarrollo e hitos hacia el juego completo.
- 📋 **[Backlog](docs/backlog.md)**: Lista de changes activos, planificados y backlog de mecánicas avanzadas.
- 📜 **[Changelog](docs/changelog.md)**: Historial de versiones y evolución del proyecto.
- 💡 **[Observaciones y Notas Técnicas](docs/observations.md)**: Decisiones de arquitectura, lecciones aprendidas y notas de compatibilidad.
- 🔍 **[Auditoría de Migración](docs/auditoria/migrar-corona-a-flame.md)**: Análisis comparativo detallado entre Corona SDK y Flame.
- 📚 **[Referencia Histórica del Curso](docs/referencia-curso/TEMAS.md)**: Material didáctico inicial que dio origen al prototipo.

---

## Paquetes y Herramientas

### agregar repositorios:
#### configuracion para splash screen
`flutter pub add flutter_native_splash`

```
flutter_native_splash:
  color: "#ffffff"
  image: assets/images/splash.png
```
- Instalacion:
`dart run flutter_native_splash:create`
- [ ] [documentacion](https://pub.dev/packages/flutter_native_splash)

#### configuracion para icono de lanzamiento
`flutter pub add flutter_icons`
```
flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/launcher.png"
```

- Instalacion:
`dart run flutter_launcher_icons`
- [ ] [documentacion](https://pub.dev/packages/flutter_launcher_icons)

### Fuentes de información
- [ ] [más sobre flame](https://docs.flame-engine.org)
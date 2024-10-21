# untitled_tec_game

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Paquetes

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
`dart run flutter_launcher_icons:generate`
- [ ] [documentacion](https://pub.dev/packages/flutter_launcher_icons)
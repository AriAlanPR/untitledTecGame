# Observations & Technical Notes — untitledTecGame

Bitácora de observaciones técnicas, lecciones aprendidas, hallazgos de compatibilidad y decisiones de arquitectura tomadas durante el desarrollo del proyecto.

---

## 1. Arquitectura y Motor de Juego

### Flame vs Box2D (`flame_forge2d`)
- **Observación**: En el proyecto original de Corona SDK (`TecISC/game.lua:25-26`), la física se iniciaba con `physics.setGravity(0, 0)`. Los asteroides se desplazaban usando velocidades lineales fijas y los lásers utilizaban transiciones directas.
- **Decisión**: No se integrará `flame_forge2d`. El sistema integrado `flame/collisions.dart` (`HasCollisionDetection`, `CircleHitbox`, `RectangleHitbox`) cubre el 100% de los requerimientos de interacción física sin agregar el peso binario del motor Box2D.
- **Beneficio**: Menor consumo de memoria, inicialización instantánea y código más mantenible en Dart puro.

### Spritesheets y Dimensiones de Frames
- **Observación**: Los archivos gráficos del juego utilizan atlas empacados con TexturePacker:
  - `character1.png`: Cuadrícula uniforme de 64x64 píxeles por frame. Secuencias principales: `shot` (11 frames), `left` (8 frames), `right` (8 frames).
  - `effects_skills.png`: Cuadrícula uniforme de 34x34 píxeles por frame. Secuencia de asteroide `woosh` (8 frames).
- **Decisión**: Se importan directamente a `assets/images/` y se cortan usando `SpriteAnimationData.sequenced` o `SpriteSheet` de Flame, preservando la numeración original de frames.

---

## 2. Dependencias y Ecosistema Flutter

### Conflicto de Versión `intl` y `flutter_localizations`
- **Observación**: Al intentar añadir `flame_audio` o ejecutar `flutter pub upgrade`, el gestor de paquetes falló indicando que `flutter_localizations` del SDK de Flutter instalado depende de `intl: ^0.20.3`, mientras que `pubspec.yaml` tenía fijado `intl: ^0.19.0`.
- **Acción requerida**: Elevar la restricción de `intl` a `^0.20.3` en `pubspec.yaml` durante el change `setup-assets-and-dependencies`.

### Estrategia de Audio
- **Observación**: Los archivos de audio originales (`.wav` y `.mp3`) no estaban presentes en el repositorio de Corona debido a reglas de exclusión en `.gitignore:6,8`.
- **Decisión**: La arquitectura del juego mantendrá una capa `AudioManager` desacoplada con métodos semánticos (`playLaser()`, `playExplosion()`, `playDamage()`). En fases iniciales funcionará con stubs silenciosos para no bloquear el desarrollo del gameplay, y posteriormente se incorporarán assets libres de derechos o generados con IA.

---

## 3. Estado y Persistencia

### Persistencia del Ranking Top 10
- **Observación**: En Corona SDK, los récords se almacenaban en un archivo JSON plano `scores.json` dentro de `system.DocumentsDirectory`.
- **Implementación**: En Flutter, la clase `PersistentData` (`lib/utils/persistent_data.dart`) maneja `SharedPreferences`. Se serializará el top 10 bajo la clave `'high_scores'` como JSON string o lista de enteros, alimentando directamente a `ScoreMenuPage`.

---

## 4. Filosofía de Movimiento y Animación: UI vs Game Loop

### Separación de Enfoques de Animación
- **Observación**: Los videojuegos arcade requieren un nivel de reactividad visual muy alto ("jugosidad" o *juice*), pero mezclar técnicas de animación de aplicaciones convencionales en el bucle de renderizado de Flame degrada el rendimiento y rompe la consistencia.
- **Decisión Arquitectónica**:
  1. **Capa Flutter UI & Overlays (Vocabulario de Emil Kowalski / `flutter-movimiento`)**:
     - Aplica a: `StartMenu`, `ConfigurationPage`, `ScoreMenuPage`, `GameHudOverlay`, `GameOverOverlay` y diálogos.
     - Principios: Microinteracciones táctiles (escalado a 0.95 al presionar botones), curvas spring amortiguadas, duraciones rápidas (150–250ms), transiciones de salida sin retrasos innecesarios para mantener al jugador en acción.
  2. **Capa Canvas & Componentes (Flame Game Loop / "Game Feel" & "Juice")**:
     - Aplica a: `PlayerComponent`, `AsteroidComponent`, `LaserComponent`, `FirstWorld`.
     - Principios: Basados en técnicas de *Game Feel* (Jan Willem Nijman / Vlambeer):
       - *Screen Shake*: Sacudida de cámara con atenuación exponencial ante impactos críticos.
       - *Hit Stop / Freeze Frames*: Micro-pausas deliberadas (2 a 4 frames) al colisionar para transmitir contundencia física.
       - *Partículas y Flash*: Destellos de impacto y sistemas de partículas acelerados por hardware.


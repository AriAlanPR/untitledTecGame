# Design Document: boss-encounter-metalshark

## 1. Arquitectura y Componentes Técnicos

### 1.1 Modelo del Jefe (`BossComponent`)
- **Ubicación**: [`lib/game/components/boss_component.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/boss_component.dart)
- **Asset**: [`assets/images/metalshark.png`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/assets/images/metalshark.png) (610 × 560 px).
- **Spritesheet**: Cuadrícula de 2 columnas × 3 filas con `srcSize: Vector2(305, 186.6)`. Se renderiza a tamaño en juego de `Vector2(200, 122)` con `PolygonHitbox` o `CircleHitbox(radius: 60)`.
- **Vida**: 40 HP iniciales.
- **Ciclo de Estados**:
  - `entering`: desciende desde `y = -150` hasta su altitud de combate (`y = 180`).
  - `strafe`: desplazamiento sinusoidal horizontal en el tercio superior entre `x = 120` y `x = gameWidth - 120`.
  - `diveBomb`: (activado periódicamente en Fase 2 al tener < 50% HP): embiste verticalmente hacia la coordenada `x` del jugador a 600 px/s, y regresa a su altitud base.
  - `dying`: secuencia de explosiones en cadena, destellos y eliminación del mundo.

### 1.2 Proyectiles Hostiles de Plasma (`BossPlasmaComponent`)
- **Ubicación**: [`lib/game/components/boss_plasma_component.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/boss_plasma_component.dart)
- **Características**:
  - Esfera de energía de 24 px de diámetro con halo incandescente naranja/rojo (`0xFFFF3D00`).
  - Desplazamiento vectorial calculado en el momento del disparo apuntando hacia la posición actual del jugador (`velocity = (playerPos - bossPos).normalized() * 380`).
  - **Colisión con Jugador**: inflige daño (`player.takeDamage()`) y se destruye.
  - **Colisión con Láser**: colisiona con [`LaserComponent`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/laser_component.dart), destruyendo ambos proyectiles con feedback sonoro de explosión.

### 1.3 Coordinación en `TecGame` y Spawner
- **Tiempo de Juego**: variable `_sessionTime` acumulada en `TecGame.update(dt)`.
- **Condición Dual**:
  ```dart
  if (!_bossSpawned && _sessionTime >= 45.0 && score >= 1500) {
    _triggerBossEncounter();
  }
  ```
- **Control del Spawner**: [`AsteroidSpawner`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/asteroid_spawner.dart) recibe una bandera `isPaused`. Durante el combate del Boss no caen asteroides regulares. Al morir el Boss, el spawner se reanuda con `speedMultiplier = 1.35`.
- **Reactividad de Salud**: `bossHpNotifier = ValueNotifier<double?>(null)` en `TecGame`. Cuando el Boss está activo, emite valores de `1.0` a `0.0`.

### 1.4 HUD y Notificaciones (`GameHudOverlay`)
- **Alerta de Entrada**: Banner animado con fondo rojo translúcido y parpadeo de 3 segundos: *"¡ALERTA: METAL SHARK DETECTADO!"*.
- **Barra de Vida**: Widget animado en la parte superior del HUD con borde de neón, etiqueta *"METAL SHARK"* y relleno proporcional que disminuye suavemente con los impactos.

---

## 2. Archivos Afectados

- `lib/game/components/boss_component.dart` (Nuevo)
- `lib/game/components/boss_plasma_component.dart` (Nuevo)
- `lib/game/components/asteroid_spawner.dart` (Banderas `isPaused` y `speedMultiplier`)
- `lib/game/components/laser_component.dart` (Intercepción de plasma hostil)
- `lib/game/components/first_world.dart`
- `lib/game/tec_game.dart` (`bossHpNotifier`, `sessionTime`)
- `lib/game/overlays/game_hud_overlay.dart` (Barra de vida del Boss y banner de alerta)
- `assets/i18n/es_MX.json` y `assets/i18n/en_US.json`
- `test/boss_encounter_test.dart` (Nuevo)

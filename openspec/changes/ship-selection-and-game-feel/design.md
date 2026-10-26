# Design: ship-selection-and-game-feel

## Context

`untitledTecGame` currently hardcodes `character1.png` inside `PlayerComponent.onLoad()`.
Both `character1.png` and `character2.png` exist in `assets/images/` and share the identical 64x64 frame layout:
- `idle`: 0
- `left`: 69..76 (count 8)
- `right`: 87..94 (count 8)
- `shot`: 122..132 (count 11)

In addition, `TecGame` uses Flame's modern `CameraComponent.withFixedResolution` attached to a `World`, making viewfinder manipulations straightforward.

## Architecture & Components

### 1. `ShipConfig` (`lib/models/ship_config.dart`)
```dart
class ShipConfig {
  final String id;
  final String nameKey;
  final String spriteSheet;
  final double shotCooldown;
  final double moveSpeedMultiplier;

  const ShipConfig({
    required this.id,
    required this.nameKey,
    required this.spriteSheet,
    this.shotCooldown = 0.6,
    this.moveSpeedMultiplier = 1.0,
  });

  static const ShipConfig alphaScout = ShipConfig(
    id: 'alpha_scout',
    nameKey: 'nave_alpha_scout',
    spriteSheet: 'character1.png',
    shotCooldown: 0.6,
    moveSpeedMultiplier: 1.0,
  );

  static const ShipConfig betaInterceptor = ShipConfig(
    id: 'beta_interceptor',
    nameKey: 'nave_beta_interceptor',
    spriteSheet: 'character2.png',
    shotCooldown: 0.4,
    moveSpeedMultiplier: 1.25,
  );

  static const List<ShipConfig> all = [alphaScout, betaInterceptor];
}
```

### 2. Player Component Updates (`lib/game/components/player_component.dart`)
- Accepts `ShipConfig config` (defaults to `ShipConfig.alphaScout` or loaded from `PersistentData`).
- In `onLoad()`: loads `config.spriteSheet` dynamically.
- `_shotTimer` resets according to `config.shotCooldown`.

### 3. Screen Shake & Hit Stop in `TecGame` (`lib/game/tec_game.dart`)
- **Screen Shake**:
  - `void shakeScreen({double duration = 0.3, double intensity = 15.0})`
  - In `update(dt)`: updates a shake timer and offsets `camera.viewfinder.position` with randomized dampened values, returning to `Vector2.zero()` when finished.
- **Hit Stop**:
  - `void hitStop([int milliseconds = 45])`
  - Pauses engine for `milliseconds` and then resumes if not game over.

### 4. Ship Selector UI (`lib/views/start_menu_page.dart` / `lib/widgets/ship_selector.dart`)
- Visual card showing ship preview icon, name, and attributes.
- Left / Right toggle arrows with `ScaleTransition` / tactile micro-scaling.
- Saves selection to `PersistentData.saveSelectedShip(id)`.

## Risks & Mitigations

- **Camera Drift on Shake**: If shake timer ends abruptly, camera might remain displaced.
  - *Mitigation*: Explicitly reset `camera.viewfinder.position = Vector2.zero()` at the end of the shake sequence.

# Proposal

## Why

Following the technical roadmap established in `docs/auditoria/migrar-corona-a-flame.md`, the visual assets (`character1.png`, `effects_skills.png`) and engine dependencies are now ready. The current `GameScope` (`lib/game/game_scope.dart`) only renders placeholder static shapes. This change implements the core gameplay mechanics (player horizontal control, laser firing, asteroid waves, and collision resolution) to deliver a playable Proof of Concept (PoC) in Flame matching the mechanics of `TecISC/game.lua`.

## What Changes

- Create `PlayerComponent` using the 64x64 spritesheet from `assets/images/character1.png` with animations (`shot`, `left`, `right`), horizontal drag movement clamped to viewport bounds, and tap-to-fire mechanic.
- Create `LaserComponent` using `assets/images/effects_skills.png` that moves vertically upward and auto-removes off-screen.
- Create `AsteroidComponent` using the 34x34 animated `"woosh"` sequence from `effects_skills.png`, spawned perimetrically with random linear velocities and rotational torque.
- Implement `AsteroidSpawner` component using a periodic timer to spawn asteroid waves and clean up off-screen entities.
- Enable `HasCollisionDetection` in `GameScope`. When a `LaserComponent` intersects an `AsteroidComponent`, both entities are removed and the game score increases by 100 points.

## Capabilities

### New Capabilities
- `core-gameplay`: Core arcade gameplay loop featuring player movement, laser projectiles, perimeter asteroid spawning, and reactive collision detection with scoring.

### Modified Capabilities
<!-- None -->

## Impact

- `lib/game/game_scope.dart`: Refactored to include `HasCollisionDetection`, integrate `PlayerComponent` and `AsteroidSpawner`.
- `lib/game/components/`: New modular components (`player_component.dart`, `laser_component.dart`, `asteroid_component.dart`, `asteroid_spawner.dart`).
- Existing Flutter UI screens and navigation remain unchanged.

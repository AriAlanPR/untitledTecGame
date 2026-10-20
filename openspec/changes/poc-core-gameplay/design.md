# Design

## Context

The audit `docs/auditoria/migrar-corona-a-flame.md` traced the core gameplay from `TecISC/game.lua:82-254, 280-312`.
With `character1.png` and `effects_skills.png` available in `assets/images/`, this change implements the Flame Component System (FCS) architecture to replace the placeholder implementation in `lib/game/game_scope.dart`.

## Goals / Non-Goals

**Goals:**
- Modular Flame components: `PlayerComponent`, `LaserComponent`, `AsteroidComponent`, `AsteroidSpawner`.
- Horizontal drag control and tap firing using Flame's input callbacks (`DragCallbacks`, `TapCallbacks`).
- Native collision detection with `flame/collisions.dart` (`HasCollisionDetection`, `CircleHitbox`, `RectangleHitbox`).
- Score tracking updated on laser-asteroid collision (+100 points).

**Non-Goals:**
- Player life cycle, 3 lives, damage blinking, and game over sequence (deferred to `game-lifecycle-hud-and-scores`).
- HUD overlay and persistence to SharedPreferences (deferred to `game-lifecycle-hud-and-scores`).
- Audio playback (deferred to `audio-and-polish`).

## Decisions

- **Native Collision Detection over Box2D**: Use `HasCollisionDetection` with hitboxes instead of Box2D (`flame_forge2d`). Corona SDK used `physics.setGravity(0, 0)` with constant linear velocities; native hitboxes provide the same functionality with zero overhead and simpler state management.
- **Flame Component System (FCS)**: Decouple entities into dedicated classes under `lib/game/components/`:
  - `PlayerComponent`: Manages player state, sprite animations (`SpriteAnimationGroupComponent`), input callbacks.
  - `LaserComponent`: Moves with linear velocity `(0, -speed)` with a `RectangleHitbox`.
  - `AsteroidComponent`: Moves with `(vx, vy)` and angular rotation `dt * torque`, using a `CircleHitbox`.
  - `AsteroidSpawner`: Uses `TimerComponent` firing every 500-700ms to instantiate asteroids and sweep off-screen entities.

## Risks / Trade-offs

- **Viewport Dimensions**: Viewport sizing differs between web and mobile devices. Clamping player coordinates and perimeter spawning must use `gameRef.size` or camera resolution to remain consistent across screen ratios.

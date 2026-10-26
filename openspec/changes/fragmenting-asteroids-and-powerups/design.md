# Design: fragmenting-asteroids-and-powerups

## Context

`AsteroidComponent` currently uses a uniform 85px bounding box and circle hitbox (`radius: 35`).
`PlayerComponent` has standard single-laser shooting and linear life decrement on collision.
This design refactors `AsteroidComponent` to support size scaling, introduces `PowerUpComponent`, and integrates shield and triple-shot mechanics into `PlayerComponent`.

## Architecture & Components

```
                          [ AsteroidComponent (Large) ]
                                       |
                              (Hit by laser)
                                       v
                    +------------------+------------------+
                    |                                     |
         [ AsteroidComponent (Medium) ]        [ AsteroidComponent (Medium) ]
                    |                                     |
              (Hit by laser)                        (Hit by laser)
                    v                                     v
         [ 2x AsteroidComponent (Small) ]      [ 2x AsteroidComponent (Small) ]
                    |
              (20% drop chance)
                    v
          [ PowerUpComponent ] ----(Player collision)----> [ PlayerComponent ]
             (Shield / TripleShot)                           (hasShield / hasTripleShot)
```

### 1. `AsteroidSize` & Fragmentation
- Enum `AsteroidSize { large, medium, small }`:
  - `large`: scale `1.4` (~120px), radius `45`, points `150`.
  - `medium`: scale `1.0` (~85px), radius `32`, points `100`.
  - `small`: scale `0.6` (~50px), radius `18`, points `50`.
- In `hitByLaser()`:
  - If `large`: instantiates 2 `medium` asteroids at current position with velocity rotated by +35° and -35°.
  - If `medium`: instantiates 2 `small` asteroids with velocity rotated by +45° and -45°.
  - Rolls a random chance (`0.20`) to spawn a `PowerUpComponent`.

### 2. `PowerUpComponent` (`lib/game/components/power_up_component.dart`)
- Subclasses `PositionComponent` with `CollisionCallbacks`.
- `enum PowerUpType { shield, tripleShot }`.
- Drifts downward at `velocity = Vector2(0, 150.0)`.
- Has circular hitbox (`radius: 20`).
- On collision with `PlayerComponent`:
  - Calls `player.applyPowerUp(type)`.
  - Plays `AudioManager.instance.playPowerUp()`.
  - Removes itself from parent.

### 3. Player Power-Up Mechanics
- **Shield (`hasShield = true`)**:
  - Draws or adds a child `CircleComponent` ring around the player with cyan/blue glow.
  - In `takeDamage()`:
    - If `hasShield`: set `hasShield = false`, play shield break sound / damage SFX, trigger invulnerability, but **do not decrement `lives`**!
- **Triple Shot (`hasTripleShot = true`, duration `8.0s`)**:
  - When firing:
    - Spawns central laser (standard).
    - Spawns left laser with velocity angled -15° (or offset X -20).
    - Spawns right laser with velocity angled +15° (or offset X +20).
  - Timer decrements in `update(dt)` until returning to single shot.

## Risks & Mitigations

- **Entity Count Explosion**: Spawning multiple fragments could overwhelm screen or frame rate.
  - *Mitigation*: Limit spawner interval for large asteroids and ensure off-screen out-of-bounds recycling removes stray fragments.

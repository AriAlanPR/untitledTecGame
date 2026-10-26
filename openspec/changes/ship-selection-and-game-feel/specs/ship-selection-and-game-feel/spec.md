# Spec Delta: ship-selection-and-game-feel

## Purpose
Governs player ship selection, persistence of chosen model, and tactile game feel effects (screen shake and hit stop).

## ADDED Requirements

### Requirement: Player Ship Selection
The player MUST be able to choose between available ship models (`alpha_scout` and `beta_interceptor`), and the selection MUST persist and be applied when spawning the player in `TecGame`.

#### Scenario: Selected ship determines player sprite and properties
- **WHEN** the player selects a ship model and starts a game
- **THEN** the `PlayerComponent` loads the corresponding spritesheet and attributes.

#### Scenario: Ship selection persists across game sessions
- **WHEN** a ship model is selected
- **THEN** the selection is saved to persistent storage and reloaded on app launch.

### Requirement: Screen Shake Effect
The camera MUST execute a dampening screen shake when the player suffers damage from an asteroid.

#### Scenario: Taking damage triggers camera screen shake
- **WHEN** the player takes damage from a collision
- **THEN** the camera viewfinder executes a shake effect and returns to its original position.

### Requirement: Hit Stop Effect
The game engine MUST trigger a brief micro-pause (hit stop) on destructive laser-asteroid collisions to convey physical impact weight.

#### Scenario: Destructive collision triggers hit stop
- **WHEN** a laser destroys an asteroid
- **THEN** a brief hit stop freeze is executed before resuming normal frame updates.

# Spec Delta

## Purpose
Establishes the interactive 2D arcade shooter mechanics in Flame, including player motion, laser shooting, asteroid hazards, and projectile-obstacle collisions.

## ADDED Requirements

### Requirement: Player Movement and Firing
The player component MUST respond to horizontal drag gestures clamped within viewport bounds and trigger laser projectiles on tap.

#### Scenario: Player moves horizontally with drag gesture
- **WHEN** the player component receives a drag update along the X axis
- **THEN** its horizontal position updates following the gesture, clamped within game screen boundaries.

#### Scenario: Player fires laser on tap
- **WHEN** the player component receives a tap event
- **THEN** a `LaserComponent` is spawned at the player position traveling upward and the player activates the shot animation.

### Requirement: Asteroid Spawning and Trajectory
The game MUST spawn animated asteroids from the screen perimeter with random linear velocity and angular torque, recycling them when out of bounds.

#### Scenario: Asteroids spawn and travel across screen
- **WHEN** the spawner timer fires
- **THEN** an `AsteroidComponent` is added to the game world from the perimeter with non-zero linear velocity.

#### Scenario: Off-screen asteroids are recycled
- **WHEN** an asteroid drifts more than 100 pixels beyond the game viewport bounds
- **THEN** it is removed from the game world.

### Requirement: Laser-Asteroid Collision Resolution
When a laser projectile collides with an asteroid, both entities MUST be destroyed and the player score MUST increase by 100.

#### Scenario: Laser destroys asteroid and awards points
- **WHEN** a `LaserComponent` hitbox intersects an `AsteroidComponent` hitbox
- **THEN** both the laser and the asteroid are removed from the game world and the score increases by 100.

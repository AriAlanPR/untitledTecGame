# Spec Delta: asteroids-and-powerups

## Purpose
Governs asteroid size tiers, fragmentation upon laser impact, and collectible power-up drops (protective shield and temporary triple shot).

## ADDED Requirements

### Requirement: Asteroid Size Hierarchy and Fragmentation
Asteroids MUST support three distinct size tiers (large, medium, small). When destroyed by player lasers, large asteroids MUST split into two medium asteroids, and medium asteroids MUST split into two small asteroids, while small asteroids are completely destroyed.

#### Scenario: Large asteroid splits into two medium asteroids
- **WHEN** a large asteroid is destroyed by a laser
- **THEN** it is removed and spawns two medium asteroids with diverging velocities.

#### Scenario: Medium asteroid splits into two small asteroids
- **WHEN** a medium asteroid is destroyed by a laser
- **THEN** it is removed and spawns two small asteroids with diverging velocities.

### Requirement: Power-Up Item Dropping and Collection
Destroying asteroids MUST have a chance to drop collectible power-up items (shield or triple shot) that drift downwards and activate when collected by the player.

#### Scenario: Player collects shield power-up
- **WHEN** the player collides with a dropped shield power-up
- **THEN** an energy shield is activated around the player that absorbs the next damage collision without life loss.

#### Scenario: Player collects triple shot power-up
- **WHEN** the player collides with a dropped triple shot power-up
- **THEN** triple laser firing is activated for a timed duration of 8 seconds.

#### Scenario: Shield absorbs collision damage
- **WHEN** a shielded player collides with an asteroid
- **THEN** the shield breaks, the asteroid is destroyed, and player lives remain unchanged.

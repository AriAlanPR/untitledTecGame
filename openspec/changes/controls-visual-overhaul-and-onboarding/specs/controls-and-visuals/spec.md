# Spec Delta: controls-and-visuals

## ADDED Requirements

### Requirement: Relative Touch Control and Screen Firing
The game engine MUST capture horizontal drag gestures across the playfield without requiring direct contact on the player ship sprite, shifting the ship horizontally by the relative drag delta (`deltaX`) clamped within screen boundaries, and MUST fire lasers when tapping anywhere on the active playfield.

#### Scenario: Relative touch drag moves ship horizontally without finger occlusion
- **GIVEN** a running game session with the player ship at horizontal position X
- **WHEN** the player performs a horizontal drag gesture in the lower half of the screen by a delta of +50 px
- **THEN** the player ship moves horizontally to X + 50 px without requiring contact on the ship sprite.

#### Scenario: Tap anywhere on screen fires laser with manual cadence
- **GIVEN** a running game session with the player ship idle
- **WHEN** the player taps on an empty area of the screen away from the ship
- **THEN** the ship transitions to shooting state, plays the laser sound effect, and spawns a laser projectile.

### Requirement: Dynamic Parallax Starfield and Projectile Contrast
The game MUST render a procedural multi-layer scrolling starfield that creates depth and speed, and MUST render laser projectiles with an emissive visual glow to ensure crisp readability against the moving background.

#### Scenario: Starfield background renders parallax star layers during gameplay
- **GIVEN** the game world is active and updating
- **WHEN** the game advances across consecutive update cycles
- **THEN** multiple layers of background stars scroll vertically at distinct speeds creating a parallax effect.

### Requirement: Onboarding and Player Instructions
The game MUST provide an easily accessible instructions view from the main menu detailing game controls, asteroid fragmentation, and power-ups, and MUST display a transient guidance prompt at the beginning of each play session.

#### Scenario: How to play modal displays instructions from start menu
- **GIVEN** the user is on the main start menu
- **WHEN** the user selects the "Cómo Jugar" / "How to Play" button
- **THEN** an instructional modal is displayed presenting visual guide cards for movement, shooting, asteroids, and power-ups.

#### Scenario: Start of game displays transient guidance prompt
- **GIVEN** a new game session starts
- **WHEN** the game HUD is mounted
- **THEN** a guidance prompt indicating how to drag and tap is displayed and automatically dismisses after 2.5 seconds.

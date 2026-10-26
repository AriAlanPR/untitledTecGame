# Spec Delta: archer-thematics-and-ui

## ADDED Requirements

### Requirement: Arrow Projectile Rendering
Player projectiles MUST render with arrow visual characteristics including an arrowhead point, a central shaft, rear fletching fins, and an emissive glow trail, matching the player's archer character animation.

#### Scenario: Player fires arrow projectiles with visible arrowhead and fletching
- **GIVEN** an active game session
- **WHEN** the player fires a shot
- **THEN** a projectile is spawned rendering an arrowhead, shaft, fletching, and an emissive energy trail.

### Requirement: Earth Defense Platform Ground
The game world MUST render a terrestrial landscape platform at the base of the screen depicting mountains, trees, and grass, providing visual grounding and narrative context for defending the Earth from falling asteroids.

#### Scenario: Earth defense platform renders at the bottom of the playfield
- **GIVEN** the game world is mounted
- **WHEN** the playfield is rendered
- **THEN** a terrestrial platform with trees and terrain is positioned at the base of the screen below the player.

### Requirement: Score Menu Navigation and Medal Ranking
The score menu MUST provide navigation back to the main start menu in addition to playing again, and MUST present top scores with medal distinctions for the top three ranks.

#### Scenario: Score menu provides navigation back to main start menu
- **GIVEN** the user is viewing the score menu page
- **WHEN** the user selects the "Menú Principal" action
- **THEN** navigation returns the user directly to the main start menu.

#### Scenario: Score menu displays top scores with styled medal ranking
- **GIVEN** the user is viewing the score menu page with recorded high scores
- **WHEN** the scores list is displayed
- **THEN** the top three entries feature distinct gold, silver, and bronze rank badges.

### Requirement: Visual Overhaul of Configuration and Start Menus
The configuration and start menu pages MUST render with coherent theme tokens, styled volume sliders, and consistent arcade neon card styling.

#### Scenario: Configuration page renders styled audio and profile controls
- **GIVEN** the user opens the configuration page
- **WHEN** the view renders
- **THEN** audio volume sliders with percentage indicators and theme-aligned switches are displayed without hardcoded inconsistent colors.

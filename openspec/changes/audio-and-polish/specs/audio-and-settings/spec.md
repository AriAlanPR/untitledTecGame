# Spec Delta: audio-and-settings

## Purpose
Governs sound effect feedback for game actions, looping background music during play, and user-configurable audio preferences.

## ADDED Requirements

### Requirement: Audio Manager Sound Effects
The audio system MUST provide sound effect playback for laser shot, asteroid explosion, player damage, and game over, respecting user muting and volume configuration.

#### Scenario: Laser shot triggers laser sound effect
- **WHEN** the player fires a laser and SFX is enabled
- **THEN** the laser audio sound effect is triggered.

#### Scenario: Asteroid explosion triggers explosion sound effect
- **WHEN** an asteroid is destroyed by a laser and SFX is enabled
- **THEN** the explosion audio sound effect is triggered.

#### Scenario: Player damage triggers damage sound effect
- **WHEN** the player takes damage from an asteroid and SFX is enabled
- **THEN** the damage audio sound effect is triggered.

#### Scenario: Game over triggers game over sound effect
- **WHEN** the game transitions to game over and SFX is enabled
- **THEN** the game over audio sound effect is triggered.

### Requirement: Background Music Playback
The system MUST loop background music during gameplay when BGM is enabled, and pause or stop when navigating away or muted.

#### Scenario: Gameplay starts background music
- **WHEN** the game session begins and BGM is enabled
- **THEN** the background music starts playing in a continuous loop.

### Requirement: Audio Settings Configuration and Persistence
The system MUST allow users to toggle and persist BGM and SFX volume and mute state in `PersistentData`.

#### Scenario: Toggling audio setting persists configuration
- **WHEN** a user modifies audio preferences in configuration
- **THEN** the new settings are saved to persistent storage and applied to audio playback.

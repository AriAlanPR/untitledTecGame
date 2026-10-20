# Spec Delta

## Purpose
Governs player vitality, damage invulnerability, in-game HUD indicators, game over state transitions, and persistent top 10 high scores ranking.

## ADDED Requirements

### Requirement: Player Lives and Damage Invulnerability
The player MUST start with 3 lives. Colliding with an asteroid while vulnerable MUST decrement 1 life and grant temporary invulnerability with visual blinking.

#### Scenario: Asteroid collision decrements player life
- **WHEN** an asteroid collides with the player while vulnerable
- **THEN** the player loses 1 life, enters an invulnerable state, and the asteroid is destroyed.

#### Scenario: Invulnerable player does not take damage
- **WHEN** an asteroid collides with the player while invulnerable
- **THEN** the player lives do not decrease and the collision is ignored.

### Requirement: Game Over Transition
When lives reach 0, the game MUST transition to the Game Over state and persist the final score into the top 10 ranking.

#### Scenario: Reaching zero lives triggers game over
- **WHEN** the player loses their last life
- **THEN** the game transitions to Game Over and the score is saved to persistent storage.

### Requirement: Top 10 High Scores Persistence
The system MUST store and sort up to 10 high scores in descending order using persistent storage.

#### Scenario: New high score is saved in sorted order
- **WHEN** a new score is saved to persistent data
- **THEN** the score list is sorted from highest to lowest and truncated to 10 entries.

#### Scenario: Score menu displays top 10 scores
- **WHEN** the score menu page is loaded
- **THEN** it displays the 10 scores retrieved from persistent storage.

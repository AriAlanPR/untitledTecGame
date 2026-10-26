# Spec Delta: boss-encounter

## ADDED Requirements

### Requirement: Dual Activation Condition and Entrance Sequence
The game MUST monitor player survival duration and accumulated score, triggering the boss encounter only when the session has lasted at least 45 seconds AND the player has earned at least 1500 points, pausing regular asteroid spawning and displaying an alert banner.

#### Scenario: Boss spawns after 45 seconds and reaching 1500 points
- **GIVEN** an active game session
- **WHEN** the elapsed time reaches at least 45 seconds and the score reaches at least 1500 points
- **THEN** regular asteroid spawning is suspended and the Metal Shark boss component enters the playfield with an alert banner.

### Requirement: Hostile Plasma Projectiles and Laser Interception
The boss MUST periodically emit hostile plasma projectiles aimed toward the player that inflict collision damage, and player laser projectiles MUST be able to intercept and destroy these plasma projectiles upon impact.

#### Scenario: Boss fires destructible plasma projectiles at player
- **GIVEN** an active boss encounter in Phase 1
- **WHEN** the boss attack timer expires
- **THEN** a plasma projectile is spawned moving toward the player, which inflicts damage upon hitting the player and is destroyed when struck by a player laser.

### Requirement: Boss Damage and Reactive Health Bar
Laser projectiles striking the boss MUST reduce the boss health pool and update the reactive boss health bar in the HUD overlay.

#### Scenario: Laser impacts damage boss and update boss health bar
- **GIVEN** the boss is active with initial 40 HP
- **WHEN** a player laser collides with the boss hitbox
- **THEN** the boss takes 1 damage, the laser is destroyed, and the boss health bar updates to reflect the remaining health percentage.

### Requirement: Phase Shift and Dive Bomb Pattern
When the boss health drops below 50%, the boss MUST enter an enraged state characterized by increased horizontal speed and periodic vertical dive bombing charges toward the player.

#### Scenario: Boss below half health triggers dive bomb attack pattern
- **GIVEN** the boss has less than 20 remaining HP (below 50%)
- **WHEN** the attack cycle triggers
- **THEN** the boss executes a rapid vertical dive bomb charge toward the player position before retreating back to the upper area.

### Requirement: Boss Defeat and Scaling Loop Continuation
Upon depleting boss health to zero, the boss MUST be destroyed with a score reward of +1000 bonus points, and regular asteroid spawning MUST resume with a permanent 1.35x speed multiplier.

#### Scenario: Defeating boss awards bonus points and increases asteroid difficulty
- **GIVEN** the boss receives a fatal laser impact reducing its HP to 0
- **WHEN** the defeat sequence executes
- **THEN** +1000 points are added to the player score, the boss is removed from the world, and asteroid spawning resumes with a 1.35x velocity multiplier.

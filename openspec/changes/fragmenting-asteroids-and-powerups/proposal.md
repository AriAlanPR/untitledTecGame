# Proposal: fragmenting-asteroids-and-powerups

## Motivation

In classic arcade shooters (e.g., Asteroids, Galaga), targets are not monolithic: breaking larger celestial bodies into smaller, faster fragments forces players to manage screen traffic strategically.
Additionally, rewarding accurate combat with tactical power-up drops (protective shields, multi-directional weapon fire) creates dynamic gameplay pacing and power-fantasy moments.

## Proposed Changes

1. **Asteroid Size Tiers & Fragmentation**:
   - `AsteroidSize` enum (`large: 120px`, `medium: 75px`, `small: 45px`).
   - Laser destruction of `large` asteroids spawns 2 `medium` asteroids with angular offsets (±30°).
   - Laser destruction of `medium` asteroids spawns 2 `small` asteroids with angular offsets (±45°).
   - `small` asteroids are eliminated without spawning further fragments.
   - Distinct score yields: large (+150 pts), medium (+100 pts), small (+50 pts).
2. **Power-Up Items**:
   - `PowerUpComponent` drifting downwards towards the bottom of the screen.
   - Types:
     - **Shield**: Grants 1-hit invulnerability barrier that absorbs an asteroid collision without decrementing player life.
     - **Triple Shot**: Fires 3 converging/diverging lasers per trigger for an 8-second duration.
   - Spawns upon asteroid destruction with a configurable drop rate (~20%).
3. **Audio & Visual Feedback**:
   - Audio feedback (`sfx/powerup.wav`) upon item pickup.
   - Energy shield visual ring rendered around the player ship when active.

## Non-Goals

- Permanent weapon upgrades across runs (items are tactical temporary power-ups within a match).
- Complex physics bouncing off other asteroids.
- Enemy boss ships (deferred to `boss-encounter-metalshark`).

## Decisions & Alternatives

- **Deterministic Angular Split**: Rather than purely random vector dispersal, fragments scatter at ±35° relative to the parent trajectory to ensure predictable, dodgeable gameplay patterns.
- **Single Hit Shield**: A simple binary shield (on/off) avoids the complexity of shield hit-point bars while providing immediate, understandable player protection.

# Proposal

## Why

Following the technical roadmap established in `docs/auditoria/migrar-corona-a-flame.md`, the core gameplay mechanics (player motion, laser shooting, asteroid spawning, and laser-asteroid collisions) are complete and tested in `poc-core-gameplay`. However, the game currently lacks a complete play session lifecycle: the player cannot lose lives, there is no in-game visual feedback for current score or health, and no Game Over sequence with persistent ranking. This change replicates the life cycle and top 10 scoring from `TecISC/game.lua:256-334` and `TecISC/highscores.lua:20-55`.

## What Changes

- Add collision detection between `PlayerComponent` and `AsteroidComponent`.
- Implement a 3-lives management system in `TecGame`:
  - When the player takes damage, lives decrement by 1, and the player enters an invulnerability state with a visual blinking effect for 2.5 seconds, ignoring collisions while invulnerable.
  - When lives reach 0, the game transitions to the Game Over state.
- Create an in-game HUD as a Flutter Overlay (`GameHudOverlay`) rendered over `GameWidget`, reactively displaying remaining lives and current score.
- Create a Game Over overlay (`GameOverOverlay`) displaying the final score, offering restart and score leaderboard navigation.
- Add `getHighScores()` and `saveHighScore()` to `PersistentData` to manage the top 10 scores sorted in descending order.
- Update `ScoreMenuPage` to load and display the real persistent top 10 ranking.

## Capabilities

### New Capabilities
- `lifecycle-and-scoring`: Manages player lives, damage invulnerability, game over transitions, in-game HUD overlay, and persistent top 10 high scores ranking.

### Modified Capabilities
<!-- None -->

## Impact

- `lib/game/components/player_component.dart`: Added asteroid collision handling, invulnerability timer, and blinking effect.
- `lib/game/tec_game.dart`: Added `lives` management, reactive notifiers, and `gameOver()` handler.
- `lib/game/game_app_wrapper.dart`: Registered overlays `hud` and `gameOver` on `GameWidget`.
- `lib/widgets/`: New overlay widgets `game_hud_overlay.dart` and `game_over_overlay.dart`.
- `lib/utils/persistent_data.dart`: Added leaderboard persistence methods.
- `lib/views/score_menu_page.dart`: Updated to consume persistent high scores.

# Design

## Context

The audit `docs/auditoria/migrar-corona-a-flame.md` identified that `TecISC/game.lua:256-334` handled lives (3), death/invulnerability sequence, and game over with transition to `highscores.lua:20-55`.
In `untitledTecGame`, [score_menu_page.dart](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/views/score_menu_page.dart#L11-L14) already defines a placeholder array of 10 scores with a `//TODO - keep latest 10 scores`.
This design addresses the complete game lifecycle and leaderboard persistence.

## Goals / Non-Goals

**Goals:**
- 3 lives managed by `TecGame` with reactive notifiers (`livesNotifier`, `scoreNotifier`).
- Player collision with asteroids triggering life loss, asteroid destruction, and 2.5s invulnerability with opacity blinking.
- In-game HUD overlay on `GameWidget` displaying lives and score.
- Game Over overlay displaying final score and actions (Restart / High Scores).
- Persistent top 10 leaderboard using `PersistentData` with JSON serialization in `SharedPreferences`.
- Connect `ScoreMenuPage` to load and display the stored top 10 scores.

**Non-Goals:**
- Audio sound effects and background music (deferred to `audio-and-polish`).
- Additional ship selection or secondary skins (deferred to `multiple-ship-selection`).

## Decisions

- **Flutter Overlays over Flame Canvas Text**: Use `GameWidget.overlayBuilderMap` to mount `GameHudOverlay` and `GameOverOverlay`. This allows reusing Flutter's Material theme tokens (`AppColors`), typography, and reactive `ValueListenableBuilder` widgets without polluting the Flame game loop.
- **Top 10 Storage Format**: Store high scores as a JSON array of integers (`[1000, 800, 500, ...]`) under the key `'high_scores'` in `SharedPreferences`. Padded with zeroes up to 10 entries to match Corona's default structure.
- **Invulnerability Blinking**: Implement using a timer and toggling opacity in `PlayerComponent.update(dt)`.

## Risks / Trade-offs

- **Game Pausing on Game Over**: When Game Over triggers, `game.pauseEngine()` is called to freeze gameplay action behind the `GameOverOverlay`.

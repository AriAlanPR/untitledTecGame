# Design: audio-and-polish

## Context

The game has complete core mechanics (movement, shooting, asteroid spawning, collisions, lives, HUD, game over, top 10 leaderboard). However, there is zero audio feedback.
`pubspec.yaml:31` already has `flame_audio: ^2.1.9` and `pubspec.yaml:83-84` includes `assets/audio/music/` and `assets/audio/sfx/`.

## Architecture & Components

```
                   +------------------------+
                   |   PersistentData       |
                   +-----------+------------+
                               |
                               v
                     +-------------------+
                     |   AudioManager    | <------- ConfigurationPage (UI controls)
                     +---------+---------+
                               |
         +---------------------+---------------------+
         |                     |                     |
         v                     v                     v
  PlayerComponent       AsteroidComponent         TecGame
  (laser, damage)          (explosion)          (bgm, game_over)
```

### 1. `AudioManager` (`lib/services/audio_manager.dart`)
- Singleton pattern or service class with static convenience access.
- Exposes:
  - `Future<void> init()`: loads persisted preferences from `PersistentData`.
  - `void playLaser()`: plays `sfx/laser.wav` if `sfxEnabled`.
  - `void playExplosion()`: plays `sfx/explosion.wav` if `sfxEnabled`.
  - `void playDamage()`: plays `sfx/damage.wav` if `sfxEnabled`.
  - `void playGameOver()`: plays `sfx/game_over.wav` if `sfxEnabled`.
  - `void startBgm()`: loops `music/space_theme.mp3` with `bgmVolume` if `bgmEnabled`.
  - `void stopBgm()`, `pauseBgm()`, `resumeBgm()`.
  - Setters for `sfxEnabled`, `bgmEnabled`, `sfxVolume`, `bgmVolume` that update preferences.
- Uses an injectable `AudioPlayerDelegate` to decouple FlameAudio platform channels during unit and widget tests.

### 2. Gameplay Audio Triggers
- `PlayerComponent.fireLaser()` -> `AudioManager.instance.playLaser()`.
- `PlayerComponent.takeDamage()` -> `AudioManager.instance.playDamage()`.
- `AsteroidComponent.hitByLaser()` -> `AudioManager.instance.playExplosion()`.
- `TecGame.triggerGameOver()` -> `AudioManager.instance.playGameOver()`.
- `TecGame.onMount()` / `onLoad()` -> `AudioManager.instance.startBgm()`.
- `TecGame.onRemove()` -> `AudioManager.instance.stopBgm()`.

### 3. UI Configuration (`lib/views/configuration_page.dart`)
- Add form controls:
  - BGM toggle Switch (`Key('config_bgm_switch')`).
  - SFX toggle Switch (`Key('config_sfx_switch')`).
  - BGM Volume Slider (`Key('config_bgm_slider')`).
  - SFX Volume Slider (`Key('config_sfx_slider')`).
- Persist in `PersistentData` on save or change.

## Risks & Mitigations

- **Audio Driver in Unit Tests**: FlameAudio depends on `audioplayers` platform channels which fail in headless test environments.
  - *Mitigation*: The `AudioPlayerDelegate` interface allows test mocks/fakes so tests verify logic without triggering native audio hardware.

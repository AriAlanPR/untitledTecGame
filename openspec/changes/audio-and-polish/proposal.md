# Proposal: audio-and-polish

## Motivation

In the original Corona project `TecISC`, audio files were absent from the repository. The discovery audit (`docs/auditoria/migrar-corona-a-flame.md`, §3.3) and roadmap Fase 4 established that a production-quality arcade game requires an immersive audiovisual experience:
- Sound effects (SFX) providing tactical feedback for shooting, asteroid explosions, player damage, and game over.
- Looping background music (BGM) to establish atmosphere.
- Audio preference controls in `ConfigurationPage` (enabling/disabling BGM and SFX, adjusting volume) backed by `PersistentData`.

## Proposed Changes

1. **Audio Assets**:
   - Provide royalty-free / synthesized retro chiptune assets in `assets/audio/sfx/` (`laser.wav`, `explosion.wav`, `damage.wav`, `game_over.wav`) and `assets/audio/music/` (`space_theme.mp3`).
2. **Audio Service (`AudioManager`)**:
   - Create a decoupled `AudioManager` abstraction using `flame_audio` (`FlameAudio.play`, `FlameAudio.bgm.play`).
   - Support independent volume and toggle switches for BGM and SFX.
   - Expose injectable delegates for testing without native audio drivers.
3. **Gameplay Integration**:
   - Trigger SFX in `PlayerComponent.fireLaser()`, `AsteroidComponent.hitByLaser()`, `PlayerComponent.takeDamage()`, and `TecGame.triggerGameOver()`.
   - Control BGM during game start, pause, resume, and teardown.
4. **Configuration Page Enhancements**:
   - Add BGM and SFX switches and volume sliders in `ConfigurationPage`.
   - Persist settings via `PersistentData`.
   - Symmetric localization in `en_US.json` and `es_MX.json`.

## Non-Goals

- Custom sound synthesis engine at runtime (pre-rendered WAV/MP3 files are sufficient).
- Spatial/3D positional audio (the game is 2D fixed resolution).
- Multiple ship selection or weapon upgrades (deferred to Fase 5).

## Decisions & Alternatives

- **Use `flame_audio` over custom player**: `flame_audio` is already added to `pubspec.yaml` (`^2.1.9`) and integrates smoothly with Flame game lifecycle.
- **Injectable Audio Interface**: Allow mock/stub implementations for automated widget and unit tests to prevent headless test runner failures on CI/local environments without sound cards.
- **Local Persistence via `PersistentData`**: Store `bgm_enabled` (bool), `sfx_enabled` (bool), `bgm_volume` (double), and `sfx_volume` (double) alongside existing user data.

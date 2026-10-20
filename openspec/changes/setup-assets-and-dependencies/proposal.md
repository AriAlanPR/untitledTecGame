# Proposal

## Why

The project is preparing to migrate the arcade shooter game from Corona SDK (`TecISC`) to Flutter + Flame, as documented in the discovery audit (`docs/auditoria/migrar-corona-a-flame.md`). Before implementing player, obstacle, and collision components in Flame, the project requires the original spritesheets and backgrounds on disk, as well as a clean package dependency tree. Currently, `intl: ^0.19.0` conflicts with the Flutter SDK's `flutter_localizations` (`^0.20.3`), blocking `flutter pub get` and preventing the installation of `flame_audio`.

## What Changes

- Update `intl` constraint to `^0.20.3` in `pubspec.yaml` to restore compatibility with `flutter_localizations`.
- Add `flame_audio: ^2.1.9` to `dependencies` in `pubspec.yaml` to establish audio support for the game engine.
- Import core graphical assets from `GameCoronaTec/TecISC/assets/images/` into `assets/images/`:
  - `character1.png` (player spritesheet with 64x64 frames)
  - `effects_skills.png` (asteroids and laser spritesheet with 34x34 frames)
  - `mountain_group.png` (mountain background layer)
  - `mountain_trees.png` (trees foreground layer)
- Ensure all imported assets are declared under `flutter.assets` in `pubspec.yaml`.
- Verify static analysis and dependency resolution with `flutter pub get` and `flutter analyze`.

## Capabilities

### New Capabilities
- `assets-and-dependencies`: Provides the visual assets (spritesheets and background layers) and resolves the core package dependencies required by Flame for subsequent gameplay implementation.

### Modified Capabilities
<!-- None -->

## Impact

- `pubspec.yaml`: updated `intl` version and added `flame_audio`.
- `assets/images/`: 4 new image files copied from `GameCoronaTec`.
- No breaking changes to existing UI views or routes.

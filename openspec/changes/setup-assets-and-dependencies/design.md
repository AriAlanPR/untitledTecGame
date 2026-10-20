# Design

## Context

The audit `docs/auditoria/migrar-corona-a-flame.md` identified that migrating `TecISC` from Corona SDK requires importing its original 2D assets and resolving package conflicts. Specifically:
- `pubspec.yaml` currently locks `intl: ^0.19.0`, which causes `flutter pub upgrade` to fail because the Flutter SDK's `flutter_localizations` requires `intl ^0.20.3`.
- `GameCoronaTec/TecISC/assets/images/` contains the spritesheets needed for the player (`character1.png`) and obstacle/lasers (`effects_skills.png`).

## Goals / Non-Goals

**Goals:**
- Update `pubspec.yaml` to use `intl: ^0.20.3` and add `flame_audio: ^2.1.9`.
- Ensure `flutter pub get` completes cleanly.
- Copy the core visual game assets (`character1.png`, `effects_skills.png`, `mountain_group.png`, `mountain_trees.png`) from `GameCoronaTec` into `assets/images/`.
- Ensure all assets are loaded and verified by Flutter tools.

**Non-Goals:**
- Implementing Flame gameplay components, drag/tap movement, or collisions (covered in `poc-core-gameplay`).
- Implementing sound playback or audio stubs (covered in `poc-core-gameplay` / `audio-and-polish`).

## Decisions

- **Keep original asset filenames**: Retaining `character1.png` and `effects_skills.png` allows referencing the exact frame coordinates mapped in the audit (64x64 for player, 34x34 for asteroids/lasers).
- **Include `flame_audio` now**: Resolving all core game dependencies in Increment 1 avoids later dependency conflicts when audio components are introduced.

## Risks / Trade-offs

- **Platform asset bloat**: Adding images increases binary size slightly, but these four images total less than 300 KB combined, which is negligible.

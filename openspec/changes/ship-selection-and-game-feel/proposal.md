# Proposal: ship-selection-and-game-feel

## Motivation

Following the successful completion of the core gameplay, HUD/scoring, and audio systems, Phase 5 of the project roadmap focuses on game depth, tactile feel ("juice"), and replayability:
- Players currently have only a single ship model (`character1.png`). The asset pipeline already includes `character2.png` (Beta Interceptor), which features a distinctive red/gold visual style and higher firing cadence.
- Arcade combat needs visceral physical feedback: a screen shake on damage and a micro-pause ("hit stop") on destructive projectile impacts turn basic collisions into satisfying tactile moments.

## Proposed Changes

1. **Ship Selection System**:
   - Model `ShipConfig` representing playable spacecraft:
     - **Alpha Scout** (`character1.png`): Balanced speed and standard firing cadence (600ms).
     - **Beta Interceptor** (`character2.png`): High agility and rapid fire cadence (400ms).
   - Dynamic spritesheet loading in `PlayerComponent` based on active `ShipConfig`.
   - Persistence of selected ship identifier in `PersistentData` under key `'selected_ship'`.
2. **Game Feel ("Juice") in Flame**:
   - Screen Shake: Camera viewfinder offset jitter with exponential dampening in `TecGame` triggered upon receiving damage.
   - Hit Stop: A controlled 40-50ms engine micro-pause upon laser-asteroid impact.
3. **UI Selector & Localization**:
   - Ship carousel/selector in `StartMenu` with tactile touch micro-scaling adhering to `flutter-movimiento` standards.
   - Symmetric localization in `en_US.json` and `es_MX.json`.

## Non-Goals

- Weapon pickup or power-up drop items (deferred to next change).
- Boss battle encounters (deferred to `boss-encounter-metalshark`).
- Multiplayer or co-op ship control.

## Decisions & Alternatives

- **Camera Viewfinder Shake over Canvas Offset**: Flame's `CameraComponent.viewfinder.position` provides native camera control without modifying world coordinates or breaking collision hitboxes.
- **Micro-pause via Engine Timer over Sleep**: Flame's `pauseEngine()` with a short timer (`Future.delayed`) prevents blocking the Flutter OS UI thread while pausing physics simulation.

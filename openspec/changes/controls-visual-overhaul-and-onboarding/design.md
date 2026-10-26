# Design Document: controls-visual-overhaul-and-onboarding

## 1. Arquitectura y Componentes Técnicos

### 1.1 Sistema de Entrada Táctil Desacoplado (TouchControlComponent)
- **Problema previo**: [`PlayerComponent`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/player_component.dart) implementaba `DragCallbacks` y `TapCallbacks` directamente, requiriendo que los eventos táctiles cayeran dentro de su `CircleHitbox(radius: 40)`.
- **Nuevo diseño**:
  - Se añade un componente de control global [`TouchControlComponent`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/touch_control_component.dart) en [`FirstWorld`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/first_world.dart) que cubre el área de juego.
  - Implementa `DragCallbacks` y `TapCallbacks`.
  - En `onDragUpdate`: calcula `event.localDelta.x` y delega a `player.dragBy(deltaX)` con su factor de sensibilidad. El jugador puede arrastrar desde el tercio o mitad inferior de la pantalla manteniendo su dedo completamente fuera de la nave.
  - En `onTapDown`: verifica si no hay cooldown de disparo y delega a `player.fireLaser()`.
  - Mantiene compatibilidad directa con `PlayerComponent.dragBy()` y `PlayerComponent.fireLaser()`.

### 1.2 Parallax Starfield y Contraste de Proyectiles
- **Componente**: [`StarfieldComponent`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/starfield_component.dart) insertado como el primer hijo de [`FirstWorld`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/first_world.dart) (`priority: -10`).
  - Capa 1: 45 micro-estrellas distantes (radio 1.0 - 1.5 px, color blanco translúcido `0x99FFFFFF`, velocidad vertical 60 px/s).
  - Capa 2: 25 estrellas medianas más cercanas (radio 2.0 - 3.0 px, color cian/azul claro `0xEE80D8FF`, velocidad vertical 140 px/s).
  - Al salir de la base de la pantalla (`y > gameHeight`), reaparecen arriba con `x` aleatorio, garantizando 0 asignaciones de memoria en tiempo de ejecución.
- **Resplandor de Láseres**: En [`LaserComponent.render()`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/laser_component.dart), se dibuja un halo exterior translúcido cian/neón con `MaskFilter.blur(BlurStyle.normal, 3.0)` previo al render del sprite, haciéndolo resaltar vívidamente contra las estrellas.

### 1.3 Onboarding e Instrucciones ("Cómo Jugar")
- **Modal de Instrucciones**: [`HowToPlayDialog`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/widgets/how_to_play_dialog.dart) como bottom sheet modal estilizado.
  - Cuatro tarjetas con iconografía retro:
    1. **Movimiento**: "Desliza en la zona inferior para moverte sin tapar la nave."
    2. **Disparo**: "Toca cualquier parte de la pantalla para disparar con destreza."
    3. **Asteroides**: "Los grandes se dividen en medianos, y estos en pequeños."
    4. **Power-Ups**: "Escudo (azul) absorbe 1 golpe · Triple Láser (verde) 8 segundos de ráfaga."
- **Prompt Flotante en HUD**:
  - En [`GameHudOverlay`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/overlays/game_hud_overlay.dart), se muestra un chip semi-transparente en el tercio inferior central durante los primeros 2.5 segundos: *"Desliza para moverte · Toca para disparar"*.
  - Desvanece con curva `Curves.easeOutCubic` (250 ms) cumpliendo los estándares de `flutter-movimiento`.

### 1.4 Estética Retro Arcade en StartMenu
- Botones con gradientes de neón y efecto de micro-escala `0.95` al presionar.
- Inclusión del botón de acción "¿Cómo Jugar?" con icono `Icons.help_outline`.

---

## 2. Archivos Afectados

- `lib/game/components/touch_control_component.dart` (Nuevo)
- `lib/game/components/starfield_component.dart` (Nuevo)
- `lib/widgets/how_to_play_dialog.dart` (Nuevo)
- `lib/game/components/first_world.dart`
- `lib/game/components/player_component.dart`
- `lib/game/components/laser_component.dart`
- `lib/game/overlays/game_hud_overlay.dart`
- `lib/views/start_menu_page.dart`
- `assets/i18n/es_MX.json` y `assets/i18n/en_US.json`
- `test/controls_and_visuals_test.dart` (Nuevo)

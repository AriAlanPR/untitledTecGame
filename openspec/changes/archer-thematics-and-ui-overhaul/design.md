# Design Document: archer-thematics-and-ui-overhaul

## 1. Arquitectura y Componentes Técnicos

### 1.1 Proyectiles de Flechas Míticas (`LaserComponent` / Renderizado de Flecha)
- **Ubicación**: [`lib/game/components/laser_component.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/laser_component.dart)
- **Renderizado Vectorial en Canvas**:
  - Punta de flecha triangular en `(size.x / 2, 0)` con color de energía cian/dorado.
  - Asta cilíndrica central de 3 px de ancho desde la punta hasta la base.
  - Plumas de culata (*fletching*) angulares a los lados en la base de la flecha.
  - Aura de resplandor (*glow*) cian translúcida (`MaskFilter.blur(BlurStyle.normal, 4.0)`).
  - En disparo triple, se generan 3 flechas simultáneas con orientación angular en abanico.

### 1.2 Plataforma Terrestre de Defensa (`EarthDefensePlatform`)
- **Ubicación**: [`lib/game/components/earth_defense_platform.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/earth_defense_platform.dart)
- **Asset**: [`assets/images/mountain_trees.png`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/assets/images/mountain_trees.png) (544 × 160 px).
- **Posición**: Posicionado en la base del mundo `y = gameHeight - 160`, con repetición horizontal continua para cubrir `gameWidth` y césped en la base inferior.
- **Prioridad**: `priority = -5` (detrás del jugador y proyectiles, pero sobre las estrellas).

### 1.3 Navegación y Podio en `ScoreMenuPage`
- **Ubicación**: [`lib/views/score_menu_page.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/views/score_menu_page.dart)
- **Navegación**:
  - Botón «Menú Principal» con `Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);`.
  - Botón «Jugar de nuevo» con `Navigator.of(context).pushReplacementNamed('/game');`.
- **Podio con Medallas**:
  - Rango 1: Medalla dorada (`Colors.amber`) con icono `Icons.military_tech`.
  - Rango 2: Medalla plateada (`Colors.blueGrey.shade200`).
  - Rango 3: Medalla de bronce (`Colors.brown.shade300`).
  - Rangos 4 a 10: Numeración estilizada con tokens de tema.

### 1.4 Renovación Estética de `ConfigurationPage` y `StartMenu`
- **Ubicaciones**: [`lib/views/configuration_page.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/views/configuration_page.dart) y [`lib/views/start_menu_page.dart`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/views/start_menu_page.dart).
- Eliminación de colores crudos hardcodeados (como `Colors.green.shade800`) en favor de `theme.colorScheme.primary`, `surfaceContainerHighest`, etc.
- Sliders con etiquetas de valor porcentual (`${(val * 100).toInt()}%`) y feedback háptico sutil.

---

## 2. Archivos Afectados

- `lib/game/components/earth_defense_platform.dart` (Nuevo)
- `lib/game/components/laser_component.dart` (Renderizado de flecha)
- `lib/game/components/first_world.dart`
- `lib/views/score_menu_page.dart`
- `lib/views/configuration_page.dart`
- `lib/views/start_menu_page.dart`
- `assets/i18n/es_MX.json` y `assets/i18n/en_US.json`
- `test/archer_and_ui_test.dart` (Nuevo)

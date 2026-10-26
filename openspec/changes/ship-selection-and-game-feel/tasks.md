# Tasks

## 1. Modelo de Naves, Configuración y Persistencia

- [x] 1.1 Definir modelo `ShipConfig` (spritesheet, cadencia de disparo, velocidad) y catálogo (`character1`, `character2`)
- [x] 1.2 Adaptar `PlayerComponent` para instanciarse dinámicamente según el `ShipConfig` activo
- [x] 1.3 Agregar persistencia de la nave seleccionada en `PersistentData` (`'selected_ship'`)

## 2. Game Feel: Screen Shake y Hit Stop en el Motor

- [x] 2.1 Implementar efecto de `shakeScreen()` en `TecGame` usando el viewfinder de la cámara
- [x] 2.2 Implementar micro-pausa de impacto (`hitStop()`) ante colisiones destructivas
- [x] 2.3 Vincular daño del jugador con `shakeScreen()` y colisión de láser con `hitStop()`

## 3. UI del Selector de Naves y Tests de Paridad

- [x] 3.1 Crear widget selector de nave en `StartMenu` con micro-escalado táctil (criterio `flutter-movimiento`)
- [x] 3.2 Añadir cadenas de localización para nombres y atributos de naves en `en_US.json` y `es_MX.json`
- [x] 3.3 Escribir tests unitarios y de widgets con paridad estricta para los 4 escenarios de la spec

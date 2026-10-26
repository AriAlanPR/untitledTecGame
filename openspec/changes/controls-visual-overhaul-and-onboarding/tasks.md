# Tasks: controls-visual-overhaul-and-onboarding

## 1. Controles Táctiles Relativos y Disparo Libre

- [x] 1.1 Crear `TouchControlComponent` con captura de gestos `DragCallbacks` y `TapCallbacks` para delegar arrastre horizontal relativo y disparo
- [x] 1.2 Adaptar `FirstWorld` para montar `TouchControlComponent` y desacoplar callbacks táctiles directos de `PlayerComponent`
- [x] 1.3 Verificar que el arrastre en la mitad inferior desplaza la nave sin oclusión y que el tap en cualquier zona dispara el láser

## 2. Parallax Starfield y Visibilidad de Proyectiles

- [ ] 2.1 Implementar `StarfieldComponent` con 2 capas procedurales de estrellas a diferentes velocidades de desplazamiento vertical
- [ ] 2.2 Integrar `StarfieldComponent` en `FirstWorld` con prioridad de fondo y reciclaje vertical de partículas
- [ ] 2.3 Añadir efecto de resplandor / halo cian (`glow`) en `LaserComponent.render()` para contraste óptimo contra el fondo estrellado

## 3. Onboarding, Start Menu Arcade y Tests de Paridad

- [ ] 3.1 Crear `HowToPlayDialog` con tarjetas visuales explicativas de movimiento, disparo, fragmentación y power-ups
- [ ] 3.2 Añadir botón "¿Cómo Jugar?" y renovar la UI del `StartMenu` con diseño retro arcade neón y micro-interacciones táctiles
- [ ] 3.3 Añadir prompt transitorio animado (2.5s) en `GameHudOverlay` al inicio de cada partida
- [ ] 3.4 Actualizar claves de localización en `es_MX.json` y `en_US.json` de forma simétrica
- [ ] 3.5 Escribir tests de paridad estricta para los 5 escenarios en `test/controls_and_visuals_test.dart`

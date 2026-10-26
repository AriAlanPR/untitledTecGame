# Tasks: archer-thematics-and-ui-overhaul

## 1. Proyectiles de Flechas Míticas y Plataforma Terrestre de Defensa

- [x] 1.1 Transformar el renderizado de proyectiles en `LaserComponent` a flechas míticas con punta, asta, plumas y glow
- [x] 1.2 Implementar `EarthDefensePlatform` usando `mountain_trees.png` en la base del mundo
- [x] 1.3 Integrar `EarthDefensePlatform` en `FirstWorld` con prioridad visual y posicionamiento adecuado debajo del arquero

## 2. Navegación y Renovación Visual de ScoreMenuPage

- [x] 2.1 Añadir botón «Menú Principal» en `ScoreMenuPage` para regresar limpiamente a la pantalla de inicio
- [x] 2.2 Rediseñar la presentación de puntajes con podio y medallas (oro, plata, bronce) para el top 3
- [x] 2.3 Estilizar las tarjetas de puntuación con tokens de tema (`Theme.of(context)`) sin colores fijos

## 3. Renovación Visual de StartMenu, ConfigurationPage y Tests de Paridad

- [ ] 3.1 Renovar `ConfigurationPage` con sliders porcentuales y componentes estilizados con tokens de tema
- [ ] 3.2 Renovar `StartMenu` con botones arcade de neón, mejor espaciado y micro-interacciones suaves
- [ ] 3.3 Mantener simetría de i18n en `es_MX.json` y `en_US.json`
- [ ] 3.4 Escribir tests de paridad estricta para los 5 escenarios en `test/archer_and_ui_test.dart`

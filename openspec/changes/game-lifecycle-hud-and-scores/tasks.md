# Tasks

## 1. Vidas del Jugador, Daño e Invulnerabilidad

- [x] 1.1 Agregar gestión de 3 vidas y notificador reactivo (`livesNotifier`) en `TecGame`
- [x] 1.2 Implementar colisión asteroide-jugador con pérdida de 1 vida y destrucción del asteroide
- [x] 1.3 Implementar estado de invulnerabilidad temporal (2.5s) y efecto de parpadeo en `PlayerComponent`

## 2. HUD en Tiempo Real y Pantalla de Game Over

- [x] 2.1 Crear widget `GameHudOverlay` con visualizador reactivo de vidas y puntaje
- [x] 2.2 Crear widget `GameOverOverlay` con puntaje final, botón de reinicio y botón hacia puntuaciones
- [x] 2.3 Registrar overlays en `GameWidget` dentro de `lib/game/game_app_wrapper.dart`

## 3. Persistencia del Top 10 y Pantalla de Puntuaciones

- [ ] 3.1 Agregar métodos `getHighScores()` y `saveHighScore()` en `lib/utils/persistent_data.dart`
- [ ] 3.2 Conectar `ScoreMenuPage` para cargar y mostrar los 10 puntajes reales desde `PersistentData`
- [ ] 3.3 Guardar el puntaje final en `PersistentData` al detonar Game Over en `TecGame`
- [ ] 3.4 Escribir tests unitarios de paridad para los escenarios de la spec

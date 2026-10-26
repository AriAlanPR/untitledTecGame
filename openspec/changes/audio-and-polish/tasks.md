# Tasks

## 1. Servicio de Audio y Assets de Sonido

- [x] 1.1 Incorporar assets de audio retro (SFX: laser, explosion, damage, game_over; BGM: space_loop) en `assets/audio/`
- [x] 1.2 Implementar servicio `AudioManager` desacoplado con control de volumen, muting y reproducción vía `FlameAudio`
- [x] 1.3 Conectar persistencia de configuración de audio (`bgm_enabled`, `sfx_enabled`, `bgm_volume`, `sfx_volume`) en `PersistentData`

## 2. Integración de Audio en Gameplay y Ciclo de Vida

- [ ] 2.1 Conectar disparo de láser con SFX de láser en `PlayerComponent`
- [ ] 2.2 Conectar destrucción de asteroide con SFX de explosión en `AsteroidComponent`
- [ ] 2.3 Conectar daño al jugador y Game Over con sus respectivos SFX en `PlayerComponent` y `TecGame`
- [ ] 2.4 Controlar inicio, pausa y reanudación de música de fondo (BGM) en el ciclo de vida del juego

## 3. Controles de Configuración de Audio y Tests de Paridad

- [ ] 3.1 Integrar controles interactivos de BGM y SFX (switches de activación y sliders de volumen) en `ConfigurationPage`
- [ ] 3.2 Añadir cadenas de localización simétricas en `en_US.json` y `es_MX.json` para las opciones de audio
- [ ] 3.3 Escribir tests unitarios y de widgets con paridad estricta para los 6 escenarios de la spec

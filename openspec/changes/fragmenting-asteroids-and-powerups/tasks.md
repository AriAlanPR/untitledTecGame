# Tasks

## 1. Jerarquía y Fragmentación de Asteroides

- [x] 1.1 Extender `AsteroidComponent` con enum `AsteroidSize` (large, medium, small), radios de colisión y puntajes diferenciados
- [x] 1.2 Implementar lógica de fragmentación en `AsteroidComponent.hitByLaser()` para generar sub-asteroides divergentes
- [x] 1.3 Adaptar `AsteroidSpawner` para generar asteroides con distribución de tamaños

## 2. Componentes de Power-Up y Efectos en el Jugador

- [x] 2.1 Crear componente `PowerUpComponent` (tipos: shield, tripleShot) con desplazamiento descendente y hitbox de recolección
- [x] 2.2 Integrar estado de escudo (`hasShield`) en `PlayerComponent` que absorba 1 golpe directo sin restar vidas
- [x] 2.3 Integrar modo de disparo triple (`hasTripleShot`, temporizador 8s) con 3 láseres en abanico en `PlayerComponent`
- [x] 2.4 Generación aleatoria de power-up en `AsteroidComponent` al destruirse

## 3. Feedback Audiovisual, HUD y Tests de Paridad

- [x] 3.1 Añadir indicador de power-up activo y anillo visual de escudo en `PlayerComponent` y `GameHudOverlay`
- [x] 3.2 Añadir SFX de recolección de power-up (`powerup.wav`) en `AudioManager` y `assets/audio/sfx/`
- [x] 3.3 Escribir tests unitarios y de widgets con paridad estricta para los 5 escenarios de la spec

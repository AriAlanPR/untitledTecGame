# Tasks

## 1. Componente de Jugador y Disparo Láser

- [x] 1.1 Crear `PlayerComponent` con animaciones de `character1.png` (64x64: `shot`, `left`, `right`)
- [x] 1.2 Implementar control táctil por arrastre horizontal con límites de pantalla (`DragCallbacks`)
- [x] 1.3 Crear `LaserComponent` con movimiento vertical hacia arriba y auto-destrucción fuera de pantalla
- [x] 1.4 Conectar evento de tap (`TapCallbacks`) en el jugador para instanciar proyectiles láser

## 2. Generación de Asteroides y Bucle de Spawn

- [x] 2.1 Crear `AsteroidComponent` con animación `"woosh"` de `effects_skills.png` (34x34) y rotación angular
- [x] 2.2 Implementar `AsteroidSpawner` periódico (spawn perimétrico aleatorio con velocidades lineales)
- [x] 2.3 Implementar reciclaje y remoción de asteroides fuera de los límites del viewport

## 3. Detección de Colisiones y Puntuación

- [ ] 3.1 Habilitar `HasCollisionDetection` en `GameScope`
- [ ] 3.2 Agregar `RectangleHitbox` a `LaserComponent` y `CircleHitbox` a `AsteroidComponent`
- [ ] 3.3 Resolver colisión láser-asteroide en `CollisionCallbacks`: destrucción de ambas entidades e incremento de +100 puntos
- [ ] 3.4 Escribir tests unitarios de paridad para los escenarios de la spec

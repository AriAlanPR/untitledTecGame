# Tasks: boss-encounter-metalshark

## 1. Activación Dual y Componente BossComponent con Animación

- [x] 1.1 Implementar `BossComponent` con spritesheet animado de 6 frames (`metalshark.png`) y 40 HP iniciales
- [x] 1.2 Extender `TecGame` para acumular tiempo de sesión y evaluar la condición dual (45s y 1,500 pts)
- [x] 1.3 Adaptar `AsteroidSpawner` con soporte de pausa durante el encuentro del Boss

## 2. Proyectiles Hostiles, Intercepción con Láseres y Patrón de Embestida

- [x] 2.1 Crear `BossPlasmaComponent` dirigido hacia la posición del jugador con hitbox de colisión
- [x] 2.2 Integrar lógica en `LaserComponent` y `BossPlasmaComponent` para permitir destruir el plasma con disparos del jugador
- [x] 2.3 Implementar patrón de embestida vertical (*dive bomb*) en `BossComponent` al caer por debajo del 50% de HP
- [x] 2.4 Integrar daño por colisión de láser al Boss con destello visual y deducción de vida

## 3. HUD con Barra de Vida, Recompensa de Derrota, Escalamiento y Tests de Paridad

- [ ] 3.1 Añadir indicador de barra de vida del Boss y banner de alerta en `GameHudOverlay` sincronizado con `bossHpNotifier`
- [ ] 3.2 Implementar secuencia de derrota (+1,000 pts de bonificación y eliminación del Boss)
- [ ] 3.3 Reanudar `AsteroidSpawner` tras la derrota con escalamiento permanente de velocidad en 1.35x
- [ ] 3.4 Actualizar localización en `es_MX.json` y `en_US.json` y escribir tests de paridad estricta para los 5 escenarios

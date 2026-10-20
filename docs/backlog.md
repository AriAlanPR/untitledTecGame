# Backlog — untitledTecGame

Este archivo mantiene el estado y orden de trabajo del proyecto, derivado de la auditoría de descubrimiento ([docs/auditoria/migrar-corona-a-flame.md](auditoria/migrar-corona-a-flame.md)).

---

## 1. Changes Activos y Planificados

| # | Change | Estado | Objetivo | Dependencias |
|---|---|---|---|---|
| 1 | `setup-assets-and-dependencies` | **En preparación** | Actualizar `intl: ^0.20.3`, agregar `flame_audio: ^2.1.9` y copiar spritesheets de `TecISC` a `assets/images/`. | Ninguna |
| 2 | `poc-core-gameplay` | Por redactar | Implementar `PlayerComponent` (arrastre/tap), `AsteroidComponent`, `LaserComponent` y colisiones con puntaje (+100). | `setup-assets-and-dependencies` |
| 3 | `game-lifecycle-hud-and-scores` | Por redactar | Ciclo de 3 vidas, reaparición con invulnerabilidad temporal, HUD overlay de Flutter y persistencia del top 10 en `ScoreMenuPage`. | `poc-core-gameplay` |
| 4 | `audio-and-polish` | Por redactar | Servicio `AudioManager`, integración con `ConfigurationPage` e incorporación de nuevos audios libres o generados con IA. | `game-lifecycle-hud-and-scores` |

---

## 2. Expansiones de Juego Completo (Siguientes Fases)

| # | Change propuesto | Estado | Objetivo |
|---|---|---|---|
| 5 | `multiple-ship-selection` | Backlog | Menú de selección y soporte para naves con estadísticas distintas (`character1`, `character2`, `metalshark`). |
| 6 | `powerups-and-weapons` | Backlog | Sistema de drops de power-ups (escudo temporal, disparo disperso, bombas EMP). |
| 7 | `wave-progression-and-bosses` | Backlog | Dificultad escalable por oleadas y enemigos tipo jefe con patrones de ataque. |
| 8 | `multiplatform-controls` | Backlog | Soporte híbrido: teclado/WASD en Web y desktop, soporte de mando Bluetooth y respuesta háptica. |

---

## 3. Ideas y Mejoras Adicionales

- [ ] **Efectos de Partículas Avanzados**: Explosiones dinámicas y estelas de propulsión de la nave con el sistema de partículas de Flame.
- [ ] **Logros y Estadísticas**: Seguimiento de asteroides destruidos, precisión de tiro y partidas jugadas.
- [ ] **Efectos de Game Over**: Celebraciones con `flutter_confetti` al romper un récord histórico.

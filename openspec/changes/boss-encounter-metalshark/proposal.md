# Proposal: boss-encounter-metalshark

## 1. Motivación y Contexto

Hasta ahora el juego cuenta con mecánicas de movimiento relativo, fragmentación de asteroides, recolección de power-ups y game feel pulido. Sin embargo, para convertirse en un juego arcade completo y gratificante, requiere un clímax de combate: un **jefe final (Boss Fight)** que ponga a prueba los reflejos y la destreza del jugador.

En los recursos del proyecto existe el spritesheet retro [`assets/images/metalshark.png`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/assets/images/metalshark.png) (610 × 560 px con 6 cuadros de animación). Este change integra al temible **Metal Shark** con mecánicas de combate completas, fases progresivas, proyectiles hostiles destructibles y escalamiento de dificultad posterior.

---

## 2. Qué Cambia

1. **Condición de Aparición y Alerta Previa**:
   - El Boss se activa cuando se cumplen **ambas condiciones simultáneamente**: haber sobrevivido al menos **45 segundos** y haber acumulado al menos **1,500 puntos**.
   - Al activarse, los asteroides habituales dejan de generarse temporalmente y en el HUD aparece un aviso parpadeante: *"¡ALERTA: METAL SHARK DETECTADO!"*.
2. **Componente de Jefe (`BossComponent`)**:
   - Spritesheet animado de 6 frames en bucle continuo de oscilación biomecánica.
   - Barra de vida en el HUD ([`GameHudOverlay`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/overlays/game_hud_overlay.dart)) con 40 puntos de resistencia.
   - Los impactos de los láseres del jugador producen destellos de daño (*damage flash*) y reducen la barra de vida.
3. **Patrones de Ataque y Fases**:
   - **Fase 1 (100% - 50% HP)**: Desplazamiento horizontal continuo en el tercio superior de la pantalla, disparando periódicamente proyectiles de plasma hostil ([`BossPlasmaComponent`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/boss_plasma_component.dart)) en dirección hacia la posición del jugador.
   - **Proyectiles destructibles**: El jugador puede esquivar el plasma o **destruirlo** disparándole con sus propios láseres.
   - **Fase 2 (<50% HP - Furia)**: Mayor velocidad de movimiento lateral y patrón de embestida vertical (*dive bomb charge*) donde desciende velozmente hacia la posición horizontal del jugador y regresa a la cima.
4. **Derrota, Recompensa y Bucle de Alta Dificultad**:
   - Al llegar a 0 HP: secuencia de multi-explosiones, sacudida de pantalla, sonido de destrucción y **+1,000 puntos de bonificación**.
   - El juego continúa en bucle infinito: el generador de asteroides se reactiva con **velocidad aumentada en 1.35x**, incrementando el reto progresivo.

---

## 3. Fuera de Alcance (Non-goals)

- Segundo tipo de jefe o naves nodrizas secundarias (guardado para expansiones posteriores).
- Escenas cinemáticas de video prerenderizadas.
- Modos de juego alternativos (se integra en la partida estándar).

---

## 4. Decisiones y Alternativas Descartadas

- **Decisión de Activación**: Condición dual (45s de tiempo transcurrido Y 1,500 puntos mínimos).
  - *Alternativa descartada*: Solo tiempo (podría aparecer cuando un jugador principiante aún no domina el disparo) o solo puntos (un jugador veloz lo forzaría muy temprano).
- **Decisión de Proyectiles**: Orbes de plasma hostil destructibles con láseres del jugador.
  - *Alternativa descartada*: Proyectiles indestructibles (reduciría la interacción a solo esquivar; permitir destruirlos fomenta la destreza y precisión de tiro).
- **Decisión Post-Derrota**: Continuación inmediata en bucle infinito con asteroides 1.35x más rápidos y +1,000 pts.
  - *Alternativa descartada*: Fin abrupto de la partida (rompería la emoción arcade de perseguir un récord máximo).

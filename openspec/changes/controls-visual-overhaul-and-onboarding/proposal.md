# Proposal: controls-visual-overhaul-and-onboarding

## 1. Motivación y Contexto

Durante las pruebas en dispositivos reales y simuladores se identificaron problemas clave de experiencia de usuario y jugabilidad:
1. **Oclusión táctil (Finger Occlusion)**: Actualmente el jugador debe arrastrar y tocar directamente encima del sprite de la nave (80x80 px). En pantallas táctiles, el pulgar tapa completamente la nave, sus animaciones de disparo y los asteroides que descienden hacia ella.
2. **Fatiga de disparo y control manual**: El tap encima de la nave resulta frustrante. Se requiere una mecánica de control táctil relativo donde el pulgar pueda posicionarse cómodamente debajo de la nave mientras cualquier toque en la pantalla libre active el disparo con destreza y cadencia manual (manteniendo el reto arcade).
3. **Contraste y ambientación espacial**: El fondo azul marino uniforme carece de profundidad espacial y no ofrece suficiente contraste contra los proyectiles láser.
4. **Falta de inducción ("Cómo Jugar")**: Los jugadores nuevos no tienen indicaciones claras sobre la mecánica de movimiento, fragmentación de asteroides ni power-ups.
5. **Estética de Menú Principal**: La interfaz previa al juego requiere un tratamiento visual arcade retro con mejor jerarquía y estilo neón.

---

## 2. Qué Cambia

1. **Controles Arcade de Destreza (Opción C)**:
   - Desacoplar `DragCallbacks` y `TapCallbacks` del sprite directo de `PlayerComponent`.
   - Incorporar un gestor de entrada táctil en el canvas (`TouchControlComponent` / zona de captura) que permita arrastre horizontal relativo (`deltaX`) en la mitad inferior de la pantalla sin tapar la nave.
   - Permitir disparo manual inmediato al hacer tap en cualquier zona libre del área de juego.
2. **Escenario Espacial Dinámico (Parallax Starfield)**:
   - Crear `StarfieldComponent` con dos capas procedurales de estrellas (fondo lento con micro-estrellas + plano medio más dinámico) para generar sensación de velocidad y profundidad.
   - Mejorar el renderizado de `LaserComponent` con resplandor neón (*glow*) para garantizar contraste nítido sobre cualquier punto del escenario.
3. **Instrucciones y Onboarding ("Cómo Jugar")**:
   - Modal bottom sheet accesible desde `StartMenu` con tarjetas visuales explicativas (movimiento relativo, disparo manual, jerarquía de asteroides, escudos y triple láser).
   - Prompt temporal animado (2.5 segundos) al inicio de la partida en `GameHudOverlay` indicando "Desliza abajo para moverte · Toca para disparar".
4. **Renovación Visual del Menú Principal**:
   - Tipografía retro, bordes neón, micro-escalas de botón y composición espacial estilizada.

---

## 3. Fuera de Alcance (Non-goals)

- Encuentro con Boss final `metalshark.png` (se mantiene reservado para el change `boss-encounter-metalshark`).
- Auto-disparo continuo (descartado deliberadamente a favor de la destreza y coordinación manual requerida por el usuario).
- Tablas de puntuación en la nube o multijugador online.
- Joystick o cruceta virtual invasiva (el arrastre relativo directo es más intuitivo y limpio).

---

## 4. Decisiones y Alternativas Descartadas

- **Decisión de Controles**: Se adopta el esquema de **Arrastre Relativo + Tap libre para disparar**.
  - *Alternativa descartada*: Auto-disparo continuo al tocar (descartado porque el usuario solicitó explícitamente mantener el reto de destreza manual y coordinación de un shmup clásico).
- **Decisión de Fondo**: *Parallax Starfield* procedural ligero dentro del loop de Flame.
  - *Alternativa descartada*: Video MP4 de fondo o GIFs pesados (descartados por impacto de memoria y riesgo de pérdida de 60 FPS en móviles).
- **Decisión de Onboarding**: Modal accesible desde el menú principal con tarjetas concisas + micro-prompt de 2.5s en el HUD al inicio.
  - *Alternativa descartada*: Nivel de tutorial bloqueante obligatorio antes de jugar (descartado por romper el ritmo arcade inmediato).

# Proposal: archer-thematics-and-ui-overhaul

## 1. Motivación y Contexto

Durante la evolución del juego, la interacción y las mecánicas centrales se consolidaron, pero aún existían discordancias temáticas y detalles de navegación clave:
1. **Discordancia de Proyectiles**: El personaje jugable es un arquero con arco y flechas animados (frames 122..132), pero disparaba rayos energéticos genéricos. Modificar los proyectiles para que sean **flechas míticas con punta afilada, asta y plumas de culata (*fletching*)** otorga total coherencia narrativa y artística.
2. **Contexto de la Plataforma Base**: El área inferior debajo del arquero se sentía vacía y desvinculada. En el diseño original de `TecISC`, el arquero se encuentra defendiendo la superficie de la Tierra de la lluvia de asteroides. Contamos con los recursos de montañas y árboles ([`assets/images/mountain_trees.png`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/assets/images/mountain_trees.png)) para dar vida a la plataforma terrestre de defensa.
3. **Brecha de Navegación en Puntajes**: Al terminar una partida y abrir la pantalla de puntajes ([`ScoreMenuPage`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/views/score_menu_page.dart)), el jugador solo puede "Jugar de nuevo", careciendo de un botón para regresar al Menú Principal.
4. **Renovación Visual Cohesiva**: Las pantallas previas y posteriores al juego (`StartMenu`, `ConfigurationPage`, `ScoreMenuPage`) requieren un salto de calidad visual, alineándose con tokens de tema (`Theme.of(context)`), tarjetas de neón, podium con medallas para el top 3 y micro-interacciones táctiles suaves.

---

## 2. Qué Cambia

1. **Proyectiles de Flechas Míticas**:
   - Renderizado vectorial/sprite de flecha con punta afilada, asta de madera/energía, plumas de culata y estela luminosa.
   - En disparo triple, se proyectan 3 flechas en abanico.
2. **Plataforma Terrestre de Defensa (`EarthDefensePlatform`)**:
   - Componente estático en el fondo de [`FirstWorld`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/lib/game/components/first_world.dart) posicionado en la base (`y = gameHeight - 160`) con siluetas de montañas, árboles y césped ([`mountain_trees.png`](file:///Volumes/Cauldron/Projects/personal/untitledTecGame/assets/images/mountain_trees.png)), dando el contexto de defensa planetaria.
3. **Navegación en `ScoreMenuPage`**:
   - Incorporación de botón destacado «Menú Principal» con retorno suave (`Navigator.popUntil` o `pushNamedAndRemoveUntil`) y botón «Jugar de nuevo».
4. **Renovación Visual Integral de UI**:
   - **ScoreMenuPage**: Podio estilizado con medallas (oro, plata, bronce) para el top 3 y lista arcade de registros.
   - **ConfigurationPage**: Sliders de volumen retro arcade con etiquetas de porcentaje, switches estilizados con tokens de tema y formulario de nombre limpio.
   - **StartMenu**: Composición balanceada, tarjetas arcade con bordes neón y micro-escalas al pulsar.

---

## 3. Fuera de Alcance (Non-goals)

- Integración de servidores remotos de leaderboard en la nube.
- Creación de nuevos niveles o mundos adicionales (se mantiene en FirstWorld).

---

## 4. Decisiones y Alternativas Descartadas

- **Decisión de Proyectil**: Dibujo estilizado de flecha con path vectorial y glow luminiscente sobre el canvas de Flame.
  - *Alternativa descartada*: Sprite 34x34 pixelado (descartado porque a alta velocidad un render vectorial nítido con asta y plumas se aprecia mucho mejor en pantallas de alta densidad).
- **Decisión de Plataforma**: Plataforma con imagen de árboles y montañas original (`mountain_trees.png`).
  - *Alternativa descartada*: Línea plana verde dibujada con Paint (descartado por desentonar con el arte del juego).

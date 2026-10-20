# Auditoría — Migrar juego de Corona SDK (GameCoronaTec) a Flutter + Flame (untitledTecGame)

- Repo destino: `untitledTecGame` · rama `main` · commit `590cb40` · 2026-10-19
- Repo origen: `GameCoronaTec` · rama `dev` · commit `0b92041`
- Alcance: Migración de la lógica de juego, entidades y mecánicas desde Corona SDK (`TecISC` / `starExplorer`) hacia el motor Flame en Flutter (`untitledTecGame`), integrándolo con la UI de Flutter preexistente.
- Estado: fases 8/8

## Resumen
El juego original (`TecISC` en Corona SDK) es un shooter arcade 2D en vista vertical con movimiento táctil por arrastre, disparo de láseres, oleadas perimétricas de asteroides, 3 vidas y ranking top 10 local. La interfaz existente en Flutter (`untitledTecGame`) ya cuenta con menús, rutas y persistencia con SharedPreferences, por lo que se mantiene como cascarón principal. La lógica de juego se migra a Flame usando detección de colisiones nativa (`HasCollisionDetection`) sin la sobrecarga de Box2D, aprovechando los spritesheets originales (64x64 y 34x34) y desacoplando el audio con stubs para incorporar los nuevos efectos libres o generados por IA a través de un plan de 4 incrementos.

## 1. Inventario

### Herramienta y fuentes
- Comando ejecutado en destino: `python3 .agents/skills/ciclo-descubrir/scripts/inventario.py --repo /Volumes/Cauldron/Projects/personal/untitledTecGame` (206 archivos en `git ls-files`).
- Comando ejecutado en origen: `python3 /Volumes/Cauldron/Projects/personal/untitledTecGame/.agents/skills/ciclo-descubrir/scripts/inventario.py --repo /Volumes/Cauldron/Projects/personal/GameCoronaTec` (635 archivos en `git ls-files`).

### Repositorio destino (`untitledTecGame`)
- **Lenguajes**: Dart (33 archivos, 2,106 líneas), XML (10 / 162), C++ (8 / 619), C/C++ headers (8 / 219), JSON (7 / 170), Swift (6 / 73), YAML (3 / 143), Groovy (3 / 87), Markdown (2 / 49), Kotlin (1 / 5), HTML (1 / 108).
- **Estructura principal**:
  - `lib/game/`: Capa de juego Flame (`game_app.dart`, `game_scope.dart`, `components/player.dart`, `components/character.dart`, `components/first_world.dart`).
  - `lib/views/`: Pantallas de Flutter (`start_menu_page.dart`, `score_menu_page.dart`, `configuration_page.dart`).
  - `lib/widgets/`: Componentes UI reutilizables (`particles.dart`, `gradient_button.dart`, `easytext.dart`, `toast.dart`, etc.).
  - `lib/utils/`: Servicios y helpers (`persistent_data.dart` con SharedPreferences, `navigate.dart`, `app_colors.dart`, `constants.dart`).
- **Build y manifiestos**: `pubspec.yaml` incluye `flame: ^1.19.0`, `shared_preferences: ^2.3.2`, `localization: ^2.1.1`, `flutter_confetti: ^0.3.4`, `flutter_native_splash: ^2.4.2`.
- **Tests**: 1 test básico (`test/widget_test.dart`). Sin tests unitarios para lógica de juego.
- **CI**: Sin flujos de CI configurados.

### Repositorio origen (`GameCoronaTec`)
- **Lenguajes**: Lua (24 archivos, 5,465 líneas de lógica en `TecISC` y proyectos auxiliares), Markdown (3 / 681), JSON (7 / 366).
- **Proyectos identificados**:
  - `TecISC/`: Implementación principal y más completa (5,465 líneas Lua).
    - `TecISC/main.lua` (23 líneas): Inicialización de Composer, orientación y volumen de audio.
    - `TecISC/menu.lua` (129 líneas): Pantalla de título, botones "Play" y "High Scores", fondos decorativos.
    - `TecISC/game.lua` (496 líneas): Bucle de juego, física Box2D sin gravedad (`physics.setGravity(0, 0)`), spritesheets animados (`character1.png`, `effects_skills.png`), generación de asteroides con trayectorias e impulsos aleatorios, disparo y movimiento de láseres (`transition.to`), control táctil por arrastre (`dragMainCharacter`), ciclo de vidas (3), puntaje (+100 por asteroide) y control de colisiones.
    - `TecISC/highscores.lua` (179 líneas): Lectura, ordenamiento y persistencia del top 10 de puntuaciones en `scores.json` (`system.DocumentsDirectory`).
    - `TecISC/helpers/`: Definición de animaciones y frames de spritesheets (`character1.lua`, `character2.lua`, `effects_skills.lua`, `metalshark.lua`).
    - `TecISC/assets/`: 497 archivos de imágenes (spritesheets de personajes, efectos, fondo, montañas, árboles). Los audios están excluidos por `.gitignore` y ausentes en disco.
  - `starExplorer/`: Proyecto base de tutorial (Asteroids básico).
  - `G1Explorer/`: Experimento de estructura MVC con `tamerController.lua` y `level1.lua`.
  - `Balloon/`: Proyecto introductorio inicial.

### Módulos y responsabilidades en la migración
1. **Interfaz y navegación (Conservar en Flutter)**:
   - `lib/views/start_menu_page.dart`: Menú principal con efectos de partículas y navegación.
   - `lib/views/score_menu_page.dart`: Vista de puntuaciones persistentes.
   - `lib/views/configuration_page.dart`: Vista de ajustes (audio, dificultad, etc.).
   - `lib/utils/persistent_data.dart`: Almacenamiento local mediante `SharedPreferences`.
2. **Motor de juego (Migrar a Flame en `lib/game/`)**:
   - Reemplazar los componentes temporales (`Player`, `Character` de círculos simples) en `lib/game/game_scope.dart`.
   - Implementar componentes Flame: `PlayerComponent` (con `SpriteAnimationComponent`, `HasGameRef`, `CollisionCallbacks`, arrastre táctil), `AsteroidComponent` (spawn perimétrico, rotación y velocidad aleatoria), `LaserComponent` (proyectil con velocidad vertical).
   - Manejo de ciclo de juego: HUD con vidas y puntaje, estado de juego (Playing, Dying, GameOver), efectos de sonido con `flame_audio` o integración nativa.

### Arranque y núcleo a conservar
- **Arranque**: `lib/main.dart` configura pantalla completa y orientación vertical fija con `Flame.device.fullScreen()` y `Flame.device.setPortrait()`, arrancando `GameApp`.
- **Núcleo del juego**: El bucle y reglas de `TecISC/game.lua` (movimiento horizontal de jugador por drag, disparo continuo o por tap, oleadas de asteroides con física, colisiones láser-asteroide y asteroide-jugador con 3 vidas, y ranking top 10 al morir).

### Casos representativos elegidos para trazar en Fase 2
1. **Caso 1 (Entrada y Movimiento / Disparo del Jugador)**: `dragMainCharacter` + `fireLaser` en `TecISC/game.lua:140-218`. Traza de evento táctil en pantalla -> cálculo de desplazamiento horizontal con límites -> animación del personaje ("left", "right", "shot") -> creación del proyectil láser.
2. **Caso 2 (Bucle de Obstáculos y Detección de Colisiones)**: `createAsteroid` + `onCollision` en `TecISC/game.lua:82-138, 280-335`. Traza de timer periódico -> generación en bordes (izq, sup, der) con impulso lineal y torque -> detección de impacto contra proyectil -> descarte de entidades, efecto visual/sonoro y aumento de puntaje.
3. **Caso 3 (Ciclo de Vida, Muerte y Persistencia de Puntaje)**: `onCollision` (jugador-asteroide) + `restoremaincharacter` + `endGame` en `TecISC/game.lua:313-334, 256-279` y `TecISC/highscores.lua:23-55`. Traza de pérdida de vida -> animación/reaparición con invulnerabilidad temporal -> al llegar a 0 vidas, fin de partida -> guardado del nuevo récord en persistencia -> transición a pantalla de puntajes.

## 2. Contratos y flujos clave

### Contratos centrales y ciclo de vida
1. **Configuración de Escena y Física (`TecISC/game.lua:21-43`)**:
   - `physics.start()` y `physics.setGravity(0, 0)` (`TecISC/game.lua:25-26`). Las entidades se mueven con velocidades lineales directas y no requieren aceleración gravitacional.
   - Hojas de sprites de TexturePacker: `character1.png` (frames de 64x64, `TecISC/helpers/character1.lua:20-50`) y `effects_skills.png` (frames de 34x34, `TecISC/helpers/effects_skills.lua:20-50`).
   - Estado de partida en variables de módulo: `lives = 3`, `score = 0`, `died = false`, `asteroidsTable = {}` (`TecISC/game.lua:38-42`).
   - Grupos visuales jerárquicos: `backGroup` (fondo, montañas, árboles), `mainGroup` (jugador, proyectiles, asteroides), `uiGroup` (puntaje y vidas) (`TecISC/game.lua:49-51, 369-376`).
2. **Ciclo de vida de Escena Composer (`TecISC/game.lua:340-485`)**:
   - `scene:create`: pausa la física preliminarmente (`TecISC/game.lua:348`), construye fondos (`TecISC/game.lua:380-394`), inicializa sprite animado de jugador con secuencias `shot`, `left`, `right` (`TecISC/game.lua:398-405`) y vincula listeners de tap y drag (`TecISC/game.lua:406-407`).
   - `scene:show (phase == "did")`: reactiva física (`TecISC/game.lua:430`), inicia timer de spawn de asteroides cada 500ms (`TecISC/game.lua:438`) y registra listener global de colisiones `Runtime:addEventListener("collision", onCollision)` (`TecISC/game.lua:439`).
   - `scene:hide (phase == "will")`: cancela el timer de bucle (`TecISC/game.lua:455`) y remueve el listener de colisiones (`TecISC/game.lua:459`).

### Traza de Casos Clave

#### Caso 1: Entrada, Movimiento y Disparo del Jugador
- **Entrada táctil**:
  - `maincharacter:addEventListener("touch", dragMainCharacter)` (`TecISC/game.lua:407`).
  - Al iniciar el toque (`phase == "began"`, `TecISC/game.lua:193-197`), se establece el foco del escenario y se calcula el desplazamiento inicial `touchOffsetX = event.x - maincharacter.x`.
  - Durante el arrastre (`phase == "moved"`, `TecISC/game.lua:198-223`), se evalúa `newposition = event.x - maincharacter.touchOffsetX`. Si `newposition < maincharacter.x`, activa secuencia `"left"`; si `newposition > maincharacter.x`, activa `"right"`. Se actualiza `maincharacter.x = newposition`.
  - Al soltar (`phase == "ended" / "cancelled"`, `TecISC/game.lua:224-229`), se libera el foco táctil.
- **Disparo de láser**:
  - `maincharacter:addEventListener("tap", fireLaser)` (`TecISC/game.lua:406`).
  - Ejecuta `fireLaser()` (`TecISC/game.lua:142-172`): reproduce audio de disparo, activa animación `"shot"` de 11 frames (`TecISC/game.lua:146-147`).
  - Crea proyectil `newLaser` con frame index 118 de `effectSheet`, define cuerpo sensor dinámico (`shape = {-9,-17, 9,-17, 9,17, -9,17}`, `TecISC/game.lua:150`), `isBullet = true` y nombre `laser`.
  - Se sitúa en `(maincharacter.x, maincharacter.y)` y se traslada hacia arriba con `transition.to(newLaser, {y = -40, time = 800, onComplete = display.remove})` (`TecISC/game.lua:169-170`).

#### Caso 2: Ciclo de Asteroides y Colisión con Láser
- **Generación perimétrica**:
  - `gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)` (`TecISC/game.lua:438`).
  - `gameLoop()` invoca `createAsteroid()` (`TecISC/game.lua:234-237`).
  - `createAsteroid()` (`TecISC/game.lua:82-138`) instancia `newAsteroid` con secuencia `"woosh"` (frames 132, 31, 64, 14, 129, 73, 2, 36; time = 900ms) y escala `2.5x` (`TecISC/game.lua:84-92`).
  - Asigna cuerpo Box2D dinámico `{radius = 40, bounce = 0.7}` y `myName = "asteroid"` (`TecISC/game.lua:96, 102`).
  - Posicionamiento aleatorio en 3 cuadrantes perimétricos (`TecISC/game.lua:105-125`):
    - Izquierda: `x = -60`, `y = random(500)`, velocidad `(random(40,120), random(20,60))`.
    - Superior: `x = random(contentWidth)`, `y = -60`, velocidad `(random(-40,40), random(40,120))`.
    - Derecha: `x = contentWidth + 60`, `y = random(500)`, velocidad `(random(-120,-40), random(20,60))`.
  - Aplica torque rotacional `random(-6, 6)` (`TecISC/game.lua:136`) y lo almacena en `asteroidsTable`.
- **Limpieza de pantalla**: `gameLoop()` barre `asteroidsTable` en orden inverso eliminando cualquier asteroide que supere un margen de 100px fuera de la pantalla (`TecISC/game.lua:239-253`).
- **Colisión Láser-Asteroide**:
  - En `onCollision(event)` (`TecISC/game.lua:280-312`), cuando coinciden `laser` y `asteroid`:
  - Se destruyen ambos objetos visuales (`TecISC/game.lua:295-296`).
  - Se remueve la referencia de `asteroidsTable` (`TecISC/game.lua:301-306`).
  - Se incrementa puntaje en +100 y actualiza texto HUD (`TecISC/game.lua:309-310`).

#### Caso 3: Ciclo de Vidas, Game Over y Persistencia de Récords
- **Colisión Asteroide-Jugador**:
  - En `onCollision` (`TecISC/game.lua:313-333`), si `maincharacter` colisiona con `asteroid` y `died == false`:
  - Marca `died = true`, resta una vida `lives = lives - 1` y actualiza HUD (`TecISC/game.lua:315, 321-322`).
  - Si `lives > 0`: oculta al personaje (`alpha = 0`) y programa `restoremaincharacter` a los 1000ms (`TecISC/game.lua:330-331`).
  - `restoremaincharacter()` (`TecISC/game.lua:256-271`) desactiva el cuerpo físico, reposiciona al centro inferior `(contentCenterX, contentHeight + 100)` y realiza fade-in con `transition.to` durante 4000ms, al término del cual reactiva el cuerpo físico y restablece `died = false`.
- **Game Over**:
  - Si `lives == 0`: destruye visualmente al jugador y tras 2000ms invoca `endGame()` (`TecISC/game.lua:325-328`).
  - `endGame()` (`TecISC/game.lua:273-283`) asigna `composer.setVariable("finalScore", score)` y navega con crossFade a la escena `highscores`.
- **Persistencia en Ranking**:
  - `TecISC/highscores.lua:20-68` carga `scores.json` desde `system.DocumentsDirectory`.
  - Agrega `finalScore` al arreglo `scoresTable` (`TecISC/highscores.lua:83`).
  - Ordena de mayor a menor con función de comparación (`TecISC/highscores.lua:57-59, 86`).
  - Trunca a un máximo de 10 posiciones y reescribe `scores.json` (`TecISC/highscores.lua:42-55`).

## 3. Dependencias

### Mapeo de librerías y subsistemas

| Dependencia Origen (Corona SDK) | Versión / Tipo | Dónde se usa en origen | Clasificación | Alternativa en Destino (Flutter/Flame) |
|---|---|---|---|---|
| `composer` | Interno Solar2D | `TecISC/main.lua:10`, `menu.lua:2`, `game.lua:2`, `highscores.lua:2` | Requiere reemplazo | `Navigator` de Flutter (ya usado en `lib/game/game_app.dart:91-104`) o Flame Router |
| `physics` (Box2D) | Interno Solar2D | `TecISC/game.lua:21-26, 96, 150` | Requiere reemplazo | `flame/collisions.dart` (`HasCollisionDetection`, `CircleHitbox`, `RectangleHitbox`) |
| `graphics.newImageSheet` | Interno Solar2D | `TecISC/game.lua:34-35` | Requiere reemplazo | `SpriteSheet` / `SpriteAnimationData` de Flame |
| `audio` | Interno Solar2D | `TecISC/main.lua:18-21`, `game.lua:410-483` | Requiere reemplazo | `flame_audio` o `audioplayers` |
| `json` | Interno Solar2D | `TecISC/highscores.lua:14, 27, 50` | Portable (concepto) | `dart:convert` (`jsonDecode` / `jsonEncode`) |
| `system.pathForFile` | Interno Solar2D | `TecISC/highscores.lua:18` | Requiere reemplazo | `shared_preferences: ^2.3.2` vía `PersistentData` (`lib/utils/persistent_data.dart`) |
| `timer` / `transition` | Interno Solar2D | `TecISC/game.lua:169, 266, 438` | Requiere reemplazo | `TimerComponent` y `MoveEffect` / `EffectController` de Flame |

### Paquetes instalados en destino (`pubspec.yaml:36-47`)
- `flame: ^1.19.0`: Motor de juego 2D (usado en `lib/game/game_app.dart`, `game_scope.dart`, `components/character.dart`).
- `shared_preferences: ^2.3.2`: Almacenamiento clave-valor local (usado en `lib/utils/persistent_data.dart`).
- `localization: ^2.1.1` e `intl: ^0.19.0`: Soporte multi-idioma (usado en vistas de menús y utilidades).
- `flutter_confetti: ^0.3.4`: Efectos visuales de confeti en UI (usado en `lib/widgets/particles.dart`).
- `loading_animation_widget: ^1.3.0` y `cube_transition_plus: ^2.0.1`: Transiciones de interfaz.
- **Faltante clave identificado**: `flame_audio` no está declarado en `pubspec.yaml` (`grep -rn "flame_audio" pubspec.yaml` → 0).

## 4. Funcionalidades y datos

### Matriz de Funcionalidades

| Funcionalidad | Dónde vive (Origen) | Qué depende de plataforma | Destino en Flutter + Flame |
|---|---|---|---|
| Menú de inicio y navegación | `TecISC/menu.lua:1-129` | Ninguno (UI pura) | Se conserva en Flutter: `lib/views/start_menu_page.dart` |
| Vista de Puntuaciones (Top 10) | `TecISC/highscores.lua:1-179` | Guardado en disco | Se conecta en Flutter: `lib/views/score_menu_page.dart` con `PersistentData` |
| Vista de Configuración | *No existía en Corona* | Ninguno (UI pura) | Se conserva en Flutter: `lib/views/configuration_page.dart` |
| Canvas y Viewport de juego | `TecISC/game.lua:340-405` | Resolución y escalado | Se rediseña en Flame: `GameScope` (`lib/game/game_scope.dart`) |
| Control del Jugador (Drag y Tap) | `TecISC/game.lua:184-232, 406` | Touch multi-touch | `PlayerComponent` con mixin `DragCallbacks` y `TapCallbacks` |
| Animaciones del Jugador | `TecISC/helpers/character1.lua` (frames 64x64) | Manejo de textura | `SpriteAnimationGroupComponent` con estados `shot`, `left`, `right` |
| Oleadas de Asteroides | `TecISC/game.lua:82-138, 234-254` | Timer de bucle | `SpawnComponent` de Flame o `TimerComponent` en `GameScope` |
| Animación de Asteroides | `TecISC/helpers/effects_skills.lua` (frames 34x34) | Manejo de textura | `AsteroidComponent` con `SpriteAnimationComponent` |
| Proyectiles Láser | `TecISC/game.lua:140-172` | Detección de colisión | `LaserComponent` con `RectangleHitbox` y velocidad hacia arriba |
| Colisiones Láser-Asteroide | `TecISC/game.lua:280-312` | Box2D contacts | `CollisionCallbacks` en `LaserComponent` y `AsteroidComponent` |
| Ciclo de Vidas y Reaparición | `TecISC/game.lua:256-271, 313-334` | Timers y transiciones | Máquina de estado en `PlayerComponent` (vidas, parpadeo/invulnerabilidad) |
| Marcador y HUD en juego | `TecISC/game.lua:67-79, 309, 322` | Texto en canvas | Componente HUD (`TextComponent`) o Flutter Overlay sobre el `GameWidget` |
| Sonidos y Música de fondo | `TecISC/main.lua:18-22, game.lua:410-483` | Canales de audio | Servicio `AudioManager` usando `flame_audio` con assets propios/IA |

### Datos y Estado
- **Formato y Ubicación**:
  - Origen: Archivo `scores.json` en `system.DocumentsDirectory` con formato `[1000, 800, 500, ...]`.
  - Destino: Clave `'high_scores'` en `PersistentData` (`SharedPreferences`), serializado como lista de enteros o JSON.
- **Migración de datos existentes**: No aplica migración de usuarios previos; se inicia con la lista predeterminada de 10 ceros `[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]`.

## 5. Riesgos

### Hechos
- `untitledTecGame/lib/game/game_scope.dart:9-66` sólo añade dos círculos (`Player`, `Character`) sin lógica de movimiento, proyectiles, asteroides ni detección de colisiones (`grep -rn "Collision" lib/game` → 0 resultados).
- `TecISC/game.lua:25-26` inicializa física con gravedad en cero `physics.setGravity(0, 0)`.
- Los frames de `character1.png` son cuadrículas de 64x64 px (`TecISC/helpers/character1.lua:23-45`) y los de `effects_skills.png` son de 34x34 px (`TecISC/helpers/effects_skills.lua:23-45`).
- Los audios originales de `GameCoronaTec` no existen en disco debido a `.gitignore:6,8` (`ls TecISC/assets/audio` → error: No such file or directory).
- La dependencia de audio `flame_audio` no está incluida actualmente en `pubspec.yaml:30-48`.

### Inferencias
- La física Box2D usada en Corona es completamente prescindible: el juego no usa uniones complejas ni masa real; únicamente trayectorias lineales y colisiones de círculo/caja, las cuales se implementan de forma más eficiente y con menor sobrecarga usando `flame/collisions.dart` (`HasCollisionDetection`).
- Los 497 assets gráficos de `TecISC/assets/images/` pueden trasladarse a `untitledTecGame/assets/images/` y consumirse directamente a través de `flame` usando `SpriteSheet.fromColumnsAndRows` o mapeando los índices de TexturePacker.
- La pantalla `ScoreMenuPage` (`lib/views/score_menu_page.dart:11`) ya tiene preconfigurado un array de 10 ceros (`scores = const [0,0,0,0,0,0,0,0,0,0]`) y un `//TODO - keep latest 10 scores` en la línea 14, lo que indica que la UI fue diseñada explícitamente para emular la estructura de `scores.json` de Corona.
- La ausencia de los audios no frena la migración: se puede estructurar un contrato `AudioService` desacoplado que admita modo silencioso o placeholders hasta incorporar los nuevos efectos de audio generados con IA o libres de regalías.

### No verificado
- Calibración exacta de velocidad y dificultad en pantallas móviles con diferentes densidades de píxeles (DPI) respecto a los valores fijos de Corona SDK.

### Verificado durante la auditoría
- `flutter pub add flame_audio` y `flutter pub upgrade --dry-run`: Se comprobó que `intl: ^0.19.0` en `pubspec.yaml:37` bloquea la resolución porque el SDK Flutter (`flutter_localizations`) exige `intl: ^0.20.3`. La actualización de `intl` a `^0.20.3` es requisito para instalar `flame_audio`.

### Descartados
- Uso de `flame_forge2d`: Descartado porque la gravedad es cero y las colisiones son reactivas sin dinámica de cuerpos rígidos; agregar Box2D aumentaría complejidad innecesaria.
- Migración de proyectos secundarios (`Balloon`, `starExplorer`, `G1Explorer`): Descartado tras confirmación del usuario, concentrando el 100% del alcance en `TecISC`.

## 6. Alternativas

### Alternativa 1: Motor de física Box2D (`flame_forge2d`) vs. Colisiones nativas de Flame (`flame/collisions.dart`)
- **Evaluación**: En `TecISC/game.lua:25-26`, `physics.setGravity(0, 0)` desactiva la gravedad del mundo. Los asteroides usan impulsos lineales constantes y los proyectiles son sensores cinemáticos. No hay articulaciones, fricción dinámica ni restitución compleja.
- **Veredicto**: Gana **Colisiones nativas de Flame**. Menor huella de memoria, API declarativa directa (`CollisionCallbacks`, `CircleHitbox`, `RectangleHitbox`) y cero dependencias binarias pesadas de C++/Wasm. (Juicio apoyado en KISS y en la evidencia de `TecISC/game.lua`).

### Alternativa 2: Marcador/HUD en Canvas Flame (`TextComponent`) vs. Flutter Overlay
- **Evaluación**: Dibujar texto en el canvas de Flame requiere gestionar fuentes tipográficas, redimensionamiento y repintados en el bucle del juego. Flutter Overlay permite superponer widgets nativos de Flutter directamente sobre el `GameWidget`.
- **Veredicto**: Gana **Flutter Overlay**. Permite reutilizar el sistema de temas (`AppColors`), componentes existentes (`Easytext`) y el soporte de localización multi-idioma (`localization`) ya configurado en `lib/game/game_app.dart`.

### Alternativa 3: Monolito en `GameScope` vs. Componentes Modulares Flame (FCS)
- **Evaluación**: Corona concentraba toda la lógica en un solo archivo de 496 líneas (`TecISC/game.lua`). Mantener todo en `GameScope` generaría una clase monolítica propensa a errores y difícil de probar.
- **Veredicto**: Gana **Componentes Modulares**. Se estructuran clases separadas: `PlayerComponent`, `AsteroidComponent`, `LaserComponent` y `WorldComponent`, cumpliendo el Principio de Responsabilidad Única (SRP) y las reglas de arquitectura del proyecto.

## 7. Plan incremental

### Incrementos propuestos

| # | Incremento (change propuesto) | Depende de | Alcance | No incluye |
|---|---|---|---|---|
| 1 | `setup-assets-and-dependencies` | Ninguno | Resolver `intl: ^0.20.3`, preparar integración de audio (`flame_audio` / stubs), migrar assets visuales de `TecISC` a `assets/images/` y registrar en `pubspec.yaml`. | Lógica de juego o componentes de Flame. |
| 2 | `poc-core-gameplay` | 1 | PoC de jugabilidad: `PlayerComponent` (movimiento táctil por drag, tap para disparo), `LaserComponent` y `AsteroidComponent` (spawn perimétrico, rotación, reciclaje), con `HasCollisionDetection` y puntuación (+100). | Ciclo de vidas, Game Over y audio final. |
| 3 | `game-lifecycle-hud-and-scores` | 2 | Colisión asteroide-nave, 3 vidas, invulnerabilidad temporal con parpadeo, Game Over, HUD overlay de vidas/score y guardado/lectura del ranking top 10 en `PersistentData` conectado a `ScoreMenuPage`. | Efectos de sonido finales. |
| 4 | `audio-and-polish` | 3 | Servicio de audio `AudioManager` integrado al juego y a `ConfigurationPage`, incorporando nuevos efectos de sonido libres de regalías o generados con IA. | Cambios en la mecánica de juego base. |

### MVP frente a diferible
- **MVP (Incrementos 1, 2 y 3)**: Juego 100% operativo, con paridad de mecánicas respecto a `TecISC`, interfaz de usuario conectada y ranking persistente.
- **Diferible (Incremento 4 y posteriores)**: Música y efectos finales de audio, selección de naves secundarias (`character2.png` / `metalshark.png`) y logros adicionales.

### PoC (Incremento 2: `poc-core-gameplay`)
- **Qué valida**: Comportamiento cinemático de asteroides, respuesta táctil del jugador y detección precisa de colisiones en Flame sin retrasos ni pérdidas de frames.
- **Criterios de aceptación**:
  1. El jugador responde al arrastre horizontal manteniéndose dentro de los límites visibles de la pantalla.
  2. Los asteroides aparecen aleatoriamente por los bordes (izquierdo, superior, derecho) cruzando el área de juego y reciclándose al salir de pantalla.
  3. Al tocar la nave o la pantalla se genera un proyectil láser hacia arriba.
  4. La colisión entre láser y asteroide destruye a ambos y aumenta el puntaje en 100 puntos comprobable en consola o pantalla.
- **Qué no resuelve**: Fin de partida, persistencia de puntuaciones ni reproducción de sonidos.

## 8. Decisiones
- a) ¿Creamos un change de OpenSpec para el Incremento 1 (`setup-assets-and-dependencies`) para dejar la base técnica lista y verificada, o prefieres abordar 1 y 2 en una sola tanda? — si respondes sólo con un número: se crea el change acotado para el Incremento 1 (`setup-assets-and-dependencies`).
- b) Audio en la PoC: ¿Usamos stubs de audio desacoplados en `AudioManager` para no frenar el avance de la jugabilidad mientras se generan los audios definitivos? — si respondes sólo con un número: se usan stubs de audio sin reproducir sonido real hasta el Incremento 4.

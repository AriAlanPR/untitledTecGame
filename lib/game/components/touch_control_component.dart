import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

/// Captures full-screen or bottom-half gestures (drag and tap) and forwards them
/// to [player] without requiring the user's finger to occlude the ship sprite.
class TouchControlComponent extends PositionComponent
    with HasGameRef<TecGame>, DragCallbacks, TapCallbacks {
  final PlayerComponent player;

  TouchControlComponent({required this.player})
      : super(
          position: Vector2.zero(),
          size: Vector2(gameWidth, gameHeight),
          priority: -1,
        );

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (gameRef.isGameOver) return;
    player.dragBy(event.localDelta.x);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (player.playerState != PlayerState.shot) {
      player.playerState = PlayerState.idle;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (player.playerState != PlayerState.shot) {
      player.playerState = PlayerState.idle;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameRef.isGameOver) return;
    player.fireLaser();
  }
}

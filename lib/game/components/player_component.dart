import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

enum PlayerState { idle, left, right, shot }

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<TecGame>, DragCallbacks, TapCallbacks, CollisionCallbacks {
  static const double playerWidth = 128.0;
  static const double playerHeight = 128.0;
  static const double minX = playerWidth / 2;
  static const double maxX = gameWidth - (playerWidth / 2);

  double _shotTimer = 0.0;

  PlayerComponent({
    Vector2? position,
  }) : super(
          position: position ?? Vector2(gameWidth / 2, gameHeight - 250),
          size: Vector2(playerWidth, playerHeight),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await gameRef.images.load('character1.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(64, 64),
    );

    // Frame indices from TecISC/helpers/character1.lua (0-based)
    // idle: first frame
    final idleAnimation = SpriteAnimation.spriteList(
      [spriteSheet.getSpriteById(0)],
      stepTime: 1.0,
      loop: true,
    );

    // left: frames 69..76 (count 8, 600ms)
    final leftAnimation = SpriteAnimation.spriteList(
      [for (int i = 69; i < 69 + 8; i++) spriteSheet.getSpriteById(i)],
      stepTime: 0.6 / 8,
      loop: true,
    );

    // right: frames 87..94 (count 8, 600ms)
    final rightAnimation = SpriteAnimation.spriteList(
      [for (int i = 87; i < 87 + 8; i++) spriteSheet.getSpriteById(i)],
      stepTime: 0.6 / 8,
      loop: true,
    );

    // shot: frames 122..132 (count 11, 600ms)
    final shotAnimation = SpriteAnimation.spriteList(
      [for (int i = 122; i < 122 + 11; i++) spriteSheet.getSpriteById(i)],
      stepTime: 0.6 / 11,
      loop: false,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.left: leftAnimation,
      PlayerState.right: rightAnimation,
      PlayerState.shot: shotAnimation,
    };

    current = PlayerState.idle;

    add(CircleHitbox(radius: 40, anchor: Anchor.center, position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (current == PlayerState.shot) {
      _shotTimer += dt;
      if (_shotTimer >= 0.6) {
        _shotTimer = 0.0;
        current = PlayerState.idle;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.x += event.localDelta.x;
    position.x = position.x.clamp(minX, maxX);

    if (current != PlayerState.shot) {
      if (event.localDelta.x < -0.5) {
        current = PlayerState.left;
      } else if (event.localDelta.x > 0.5) {
        current = PlayerState.right;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (current != PlayerState.shot) {
      current = PlayerState.idle;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (current != PlayerState.shot) {
      current = PlayerState.idle;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    fireLaser();
  }

  void fireLaser() {
    current = PlayerState.shot;
    _shotTimer = 0.0;

    final laser = LaserComponent(
      position: Vector2(position.x, position.y - (size.y / 2)),
    );
    parent?.add(laser);
  }
}

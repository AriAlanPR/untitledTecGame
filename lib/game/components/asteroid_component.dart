import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class AsteroidComponent extends SpriteAnimationComponent
    with HasGameRef<TecGame>, CollisionCallbacks {
  static const double baseSize = 85.0;

  final Vector2 velocity;
  final double torque;
  bool _isDestroyed = false;

  bool get isDestroyed => _isDestroyed;
  bool get isOutOfBounds =>
      position.x < -150 ||
      position.x > gameWidth + 150 ||
      position.y < -150 ||
      position.y > gameHeight + 150;

  AsteroidComponent({
    required Vector2 position,
    required this.velocity,
    this.torque = 0.0,
  }) : super(
          position: position,
          size: Vector2.all(baseSize),
          anchor: Anchor.center,
        );

  void hitByLaser() {
    if (_isDestroyed) return;
    _isDestroyed = true;
    removeFromParent();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await gameRef.images.load('effects_skills.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(34, 34),
    );

    // "woosh" sequence from TecISC/game.lua (0-based frames)
    final wooshFrames = [131, 30, 63, 13, 128, 72, 1, 35];
    animation = SpriteAnimation.spriteList(
      [for (final frame in wooshFrames) spriteSheet.getSpriteById(frame)],
      stepTime: 0.9 / wooshFrames.length,
      loop: true,
    );

    add(CircleHitbox(radius: 35, anchor: Anchor.center, position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;
    angle += torque * dt;

    if (isOutOfBounds) {
      removeFromParent();
    }
  }
}

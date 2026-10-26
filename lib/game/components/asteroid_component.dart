import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/components/power_up_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/constants.dart';

enum AsteroidSize { large, medium, small }

class AsteroidComponent extends SpriteAnimationComponent
    with HasGameRef<TecGame>, CollisionCallbacks {
  final AsteroidSize asteroidSize;
  final Vector2 velocity;
  final double torque;
  bool _isDestroyed = false;
  final TecGame? customGame;

  bool get isDestroyed => _isDestroyed;
  TecGame get effectiveGame => customGame ?? gameRef;

  static double sizeFor(AsteroidSize size) {
    switch (size) {
      case AsteroidSize.large:
        return 120.0;
      case AsteroidSize.medium:
        return 85.0;
      case AsteroidSize.small:
        return 50.0;
    }
  }

  static double radiusFor(AsteroidSize size) {
    switch (size) {
      case AsteroidSize.large:
        return 45.0;
      case AsteroidSize.medium:
        return 32.0;
      case AsteroidSize.small:
        return 18.0;
    }
  }

  int get scorePoints {
    switch (asteroidSize) {
      case AsteroidSize.large:
        return 150;
      case AsteroidSize.medium:
        return 100;
      case AsteroidSize.small:
        return 50;
    }
  }

  bool get isOutOfBounds =>
      position.x < -150 ||
      position.x > gameWidth + 150 ||
      position.y < -150 ||
      position.y > gameHeight + 150;

  AsteroidComponent({
    required Vector2 position,
    required this.velocity,
    this.torque = 0.0,
    this.asteroidSize = AsteroidSize.medium,
    this.customGame,
  }) : super(
          position: position,
          size: Vector2.all(sizeFor(asteroidSize)),
          anchor: Anchor.center,
        );

  void hitByLaser() {
    if (_isDestroyed) return;
    _isDestroyed = true;
    AudioManager.instance.playExplosion();

    // Spawn fragments
    if (asteroidSize == AsteroidSize.large) {
      _spawnFragments(AsteroidSize.medium, 35 * pi / 180);
    } else if (asteroidSize == AsteroidSize.medium) {
      _spawnFragments(AsteroidSize.small, 45 * pi / 180);
    }

    // 20% drop chance for power-up
    if (Random().nextDouble() < 0.20) {
      final pType = Random().nextBool() ? PowerUpType.shield : PowerUpType.tripleShot;
      parent?.add(PowerUpComponent(position: position.clone(), type: pType));
    }

    removeFromParent();
  }

  void _spawnFragments(AsteroidSize childSize, double angleRad) {
    final v1 = _rotateVector(velocity, angleRad) * 1.15;
    final v2 = _rotateVector(velocity, -angleRad) * 1.15;

    final child1 = AsteroidComponent(
      position: position.clone(),
      velocity: v1,
      torque: torque * 1.2,
      asteroidSize: childSize,
      customGame: customGame,
    );
    final child2 = AsteroidComponent(
      position: position.clone(),
      velocity: v2,
      torque: -torque * 1.2,
      asteroidSize: childSize,
      customGame: customGame,
    );

    parent?.add(child1);
    parent?.add(child2);
  }

  Vector2 _rotateVector(Vector2 v, double rad) {
    final c = cos(rad);
    final s = sin(rad);
    return Vector2(v.x * c - v.y * s, v.x * s + v.y * c);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isDestroyed) return;

    if (other is PlayerComponent) {
      if (!other.isInvulnerable) {
        hitByLaser();
        other.takeDamage();
      }
    }
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

    add(CircleHitbox(
      radius: radiusFor(asteroidSize),
      anchor: Anchor.center,
      position: size / 2,
    ));
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

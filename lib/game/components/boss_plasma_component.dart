import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/constants.dart';

/// Hostile plasma projectile fired by the Metal Shark boss toward the player.
/// Can be destroyed by player lasers or dodged.
class BossPlasmaComponent extends PositionComponent
    with HasGameRef<TecGame>, CollisionCallbacks {
  final Vector2 velocity;
  final TecGame? customGame;
  bool _isDestroyed = false;

  static final Paint _corePaint = Paint()
    ..color = const Color(0xFFFF3D00)
    ..style = PaintingStyle.fill;

  static final Paint _glowPaint = Paint()
    ..color = const Color(0x88FF9100)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

  bool get isDestroyed => _isDestroyed;

  bool get isOutOfBounds =>
      position.y > gameHeight + 60 ||
      position.y < -60 ||
      position.x < -60 ||
      position.x > gameWidth + 60;

  TecGame? get effectiveGame {
    if (customGame != null) return customGame;
    try {
      return isMounted ? gameRef : null;
    } catch (_) {
      return null;
    }
  }

  BossPlasmaComponent({
    required Vector2 position,
    required this.velocity,
    this.customGame,
  }) : super(
          position: position,
          size: Vector2.all(24),
          anchor: Anchor.center,
          priority: 4,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(CircleHitbox(
      radius: 12,
      position: size / 2,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (isOutOfBounds) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = Offset(size.x / 2, size.y / 2);
    // Outer glow
    canvas.drawCircle(center, 12, _glowPaint);
    // Core
    canvas.drawCircle(center, 7, _corePaint);
  }

  void destroyByLaser() {
    if (_isDestroyed) return;
    _isDestroyed = true;
    AudioManager.instance.playExplosion();
    removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isDestroyed) return;

    if (other is LaserComponent) {
      other.removeFromParent();
      destroyByLaser();
    } else if (other is PlayerComponent) {
      if (!other.isInvulnerable) {
        other.takeDamage();
        _isDestroyed = true;
        removeFromParent();
      }
    }
  }
}

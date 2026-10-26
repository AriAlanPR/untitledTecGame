import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/boss_component.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

class LaserComponent extends SpriteComponent with HasGameRef<TecGame>, CollisionCallbacks {
  static const double speed = 900.0;
  bool _hasCollided = false;
  final TecGame? customGame;

  static final Paint _glowPaint = Paint()
    ..color = const Color(0x9900E5FF)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

  bool get hasCollided => _hasCollided;
  bool get isOutOfBounds => position.y < -50;

  LaserComponent({
    required Vector2 position,
    this.customGame,
  }) : super(
          position: position,
          size: Vector2(34, 40),
          anchor: Anchor.center,
        );

  TecGame get effectiveGame => customGame ?? gameRef;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-2, -2, size.x + 4, size.y + 4),
        const Radius.circular(6),
      ),
      _glowPaint,
    );
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Laser frame is index 117 (0-based) from effects_skills.png (34x34)
    final image = await gameRef.images.load('effects_skills.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(34, 34),
    );
    sprite = spriteSheet.getSpriteById(117);

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= speed * dt;

    if (isOutOfBounds) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (_hasCollided) return;

    if (other is AsteroidComponent) {
      _hasCollided = true;
      removeFromParent();
      effectiveGame.addScore(other.scorePoints);
      other.hitByLaser();
      effectiveGame.hitStop();
    } else if (other is BossPlasmaComponent) {
      _hasCollided = true;
      removeFromParent();
      other.destroyByLaser();
    } else if (other is BossComponent) {
      _hasCollided = true;
      removeFromParent();
      other.takeDamage(1);
    }
  }
}

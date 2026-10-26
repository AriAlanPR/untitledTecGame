import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/boss_component.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

class LaserComponent extends PositionComponent with HasGameRef<TecGame>, CollisionCallbacks {
  static const double speed = 900.0;
  bool _hasCollided = false;
  final TecGame? customGame;

  static final Paint _arrowHeadPaint = Paint()
    ..color = const Color(0xFF00E5FF)
    ..style = PaintingStyle.fill;

  static final Paint _shaftPaint = Paint()
    ..color = const Color(0xFFD7CCC8)
    ..strokeWidth = 3.5
    ..style = PaintingStyle.stroke;

  static final Paint _fletchingPaint = Paint()
    ..color = const Color(0xFF80D8FF)
    ..style = PaintingStyle.fill;

  static final Paint _arrowGlowPaint = Paint()
    ..color = const Color(0x6600E5FF)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

  bool get hasCollided => _hasCollided;
  bool get isOutOfBounds => position.y < -50;
  bool get isArrow => true;

  LaserComponent({
    required Vector2 position,
    this.customGame,
  }) : super(
          position: position,
          size: Vector2(20, 48),
          anchor: Anchor.center,
        );

  TecGame get effectiveGame => customGame ?? gameRef;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final cx = size.x / 2;

    // Glowing aura
    final glowPath = Path()
      ..moveTo(cx, -2)
      ..lineTo(cx + 10, 16)
      ..lineTo(cx + 3, size.y)
      ..lineTo(cx - 3, size.y)
      ..lineTo(cx - 10, 16)
      ..close();
    canvas.drawPath(glowPath, _arrowGlowPaint);

    // Arrow Shaft
    canvas.drawLine(Offset(cx, 12), Offset(cx, size.y - 2), _shaftPaint);

    // Arrowhead (Tip)
    final headPath = Path()
      ..moveTo(cx, 0)
      ..lineTo(cx + 8, 14)
      ..lineTo(cx, 11)
      ..lineTo(cx - 8, 14)
      ..close();
    canvas.drawPath(headPath, _arrowHeadPaint);

    // Fletching (Left & Right Feathers)
    final fletchLeft = Path()
      ..moveTo(cx - 1, size.y - 14)
      ..lineTo(cx - 7, size.y - 2)
      ..lineTo(cx - 2, size.y - 6)
      ..close();
    canvas.drawPath(fletchLeft, _fletchingPaint);

    final fletchRight = Path()
      ..moveTo(cx + 1, size.y - 14)
      ..lineTo(cx + 7, size.y - 2)
      ..lineTo(cx + 2, size.y - 6)
      ..close();
    canvas.drawPath(fletchRight, _fletchingPaint);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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

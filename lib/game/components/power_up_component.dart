import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/constants.dart';

enum PowerUpType { shield, tripleShot }

class PowerUpComponent extends PositionComponent
    with HasGameRef<TecGame>, CollisionCallbacks {
  final PowerUpType type;
  final Vector2 velocity;
  bool _isCollected = false;

  bool get isCollected => _isCollected;
  bool get isOutOfBounds => position.y > gameHeight + 100;

  PowerUpComponent({
    required Vector2 position,
    required this.type,
    Vector2? velocity,
  })  : velocity = velocity ?? Vector2(0, 160.0),
        super(
          position: position,
          size: Vector2.all(40.0),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(CircleHitbox(radius: 20, anchor: Anchor.center, position: size / 2));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = type == PowerUpType.shield
          ? const Color(0xFF00E5FF)
          : const Color(0xFFFFD600);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 16, paint);

    final corePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 7, corePaint);
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
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isCollected) return;

    if (other is PlayerComponent) {
      _isCollected = true;
      other.applyPowerUp(type);
      AudioManager.instance.playPowerUp();
      removeFromParent();
    }
  }
}

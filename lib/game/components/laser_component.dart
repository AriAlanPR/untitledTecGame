import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

class LaserComponent extends SpriteComponent with HasGameRef<TecGame>, CollisionCallbacks {
  static const double speed = 900.0;
  bool _hasCollided = false;
  final TecGame? customGame;

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
      other.hitByLaser();
      effectiveGame.addScore(100);
      effectiveGame.hitStop();
    }
  }
}

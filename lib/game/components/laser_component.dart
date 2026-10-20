import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

class LaserComponent extends SpriteComponent with HasGameRef<TecGame>, CollisionCallbacks {
  static const double speed = 900.0;

  LaserComponent({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(34, 40),
          anchor: Anchor.center,
        );

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

    if (position.y < -50) {
      removeFromParent();
    }
  }
}

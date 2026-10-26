import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

/// Terrestrial platform anchored at the base of the screen representing the
/// Earth's surface with mountains and trees that the player is defending.
class EarthDefensePlatform extends PositionComponent with HasGameRef<TecGame> {
  Sprite? _mountainSprite;

  static const double platformHeight = 160.0;

  EarthDefensePlatform()
      : super(
          position: Vector2(0, gameHeight - platformHeight),
          size: Vector2(gameWidth, platformHeight),
          priority: -5,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      final image = await gameRef.images.load('mountain_trees.png');
      _mountainSprite = Sprite(image);
    } catch (_) {
      // Fallback for headless tests where image loading is mocked
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_mountainSprite != null) {
      // Tile mountains across gameWidth (each tile is 544px wide)
      const tileWidth = 544.0;
      double currentX = 0;
      while (currentX < size.x) {
        _mountainSprite!.render(
          canvas,
          position: Vector2(currentX, 0),
          size: Vector2(tileWidth, platformHeight),
        );
        currentX += tileWidth;
      }
    } else {
      // Fallback stylized terrain bed
      final paint = Paint()..color = const Color(0xFF1B5E20);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    }

    // Lush grass top highlight border
    final grassPaint = Paint()
      ..color = const Color(0xFF4CAF50).withValues(alpha: 0.7)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, platformHeight - 2), Offset(size.x, platformHeight - 2), grassPaint);
  }
}

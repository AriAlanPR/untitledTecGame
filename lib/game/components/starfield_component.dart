import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class Star {
  double x;
  double y;
  final double radius;
  final double speed;

  Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
  });
}

/// Procedural multi-layer starfield rendering scrolling stars with parallax effect.
class StarfieldComponent extends Component {
  final List<Star> _distantStars = [];
  final List<Star> _nearStars = [];
  final Random _random = Random();
  final int distantCount;
  final int nearCount;

  late final Paint _distantPaint = Paint()
    ..color = const Color(0x99B0BEC5)
    ..style = PaintingStyle.fill;

  late final Paint _nearPaint = Paint()
    ..color = const Color(0xEE80D8FF)
    ..style = PaintingStyle.fill;

  StarfieldComponent({
    this.distantCount = 50,
    this.nearCount = 25,
    int priority = -20,
  }) : super(priority: priority) {
    _initStars();
  }

  void _initStars() {
    _distantStars.clear();
    _nearStars.clear();

    // Distant stars: slow, smaller, subtle greyish-blue
    for (int i = 0; i < distantCount; i++) {
      _distantStars.add(Star(
        x: _random.nextDouble() * gameWidth,
        y: _random.nextDouble() * gameHeight,
        radius: 1.0 + _random.nextDouble() * 0.8,
        speed: 45.0 + _random.nextDouble() * 35.0,
      ));
    }

    // Near stars: faster, brighter, neon cyan
    for (int i = 0; i < nearCount; i++) {
      _nearStars.add(Star(
        x: _random.nextDouble() * gameWidth,
        y: _random.nextDouble() * gameHeight,
        radius: 2.0 + _random.nextDouble() * 1.5,
        speed: 130.0 + _random.nextDouble() * 80.0,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final star in _distantStars) {
      star.y += star.speed * dt;
      if (star.y > gameHeight + 10) {
        star.y = -10;
        star.x = _random.nextDouble() * gameWidth;
      }
    }

    for (final star in _nearStars) {
      star.y += star.speed * dt;
      if (star.y > gameHeight + 10) {
        star.y = -10;
        star.x = _random.nextDouble() * gameWidth;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final star in _distantStars) {
      canvas.drawCircle(Offset(star.x, star.y), star.radius, _distantPaint);
    }
    for (final star in _nearStars) {
      canvas.drawCircle(Offset(star.x, star.y), star.radius, _nearPaint);
    }
  }

  List<Star> get distantStars => _distantStars;
  List<Star> get nearStars => _nearStars;
}

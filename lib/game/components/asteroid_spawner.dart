import 'dart:math';
import 'package:flame/components.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class AsteroidSpawner extends Component with HasGameRef<TecGame> {
  final Random _random = Random();
  final double spawnInterval;
  late final Timer _timer;

  AsteroidSpawner({this.spawnInterval = 0.7}) {
    _timer = Timer(
      spawnInterval,
      onTick: _spawnAsteroid,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void _spawnAsteroid() {
    final whereFrom = _random.nextInt(3); // 0: left, 1: top, 2: right
    late final Vector2 spawnPosition;
    late final Vector2 velocity;

    switch (whereFrom) {
      case 0: // Left perimeter
        spawnPosition = Vector2(-60, _random.nextDouble() * (gameHeight * 0.45));
        velocity = Vector2(
          100.0 + _random.nextDouble() * 200.0,
          50.0 + _random.nextDouble() * 150.0,
        );
        break;
      case 1: // Top perimeter
        spawnPosition = Vector2(_random.nextDouble() * gameWidth, -60);
        velocity = Vector2(
          -120.0 + _random.nextDouble() * 240.0,
          150.0 + _random.nextDouble() * 250.0,
        );
        break;
      case 2: // Right perimeter
      default:
        spawnPosition = Vector2(gameWidth + 60, _random.nextDouble() * (gameHeight * 0.45));
        velocity = Vector2(
          -(100.0 + _random.nextDouble() * 200.0),
          50.0 + _random.nextDouble() * 150.0,
        );
        break;
    }

    final torque = -3.0 + _random.nextDouble() * 6.0;

    final asteroid = AsteroidComponent(
      position: spawnPosition,
      velocity: velocity,
      torque: torque,
    );

    parent?.add(asteroid);
  }
}

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('core-gameplay', () {
    test('Player moves horizontally with drag gesture', () {
      final player = PlayerComponent(position: Vector2(500, 1000));
      expect(player.position.x, 500);

      // Drag to the right
      player.dragBy(40.0);
      expect(player.position.x, 540);
      expect(player.playerState, PlayerState.right);

      // Drag beyond right boundary
      player.dragBy(2000.0);
      expect(player.position.x, PlayerComponent.maxX);

      // Drag to the left
      player.dragBy(-100.0);
      expect(player.position.x, PlayerComponent.maxX - 100.0);
      expect(player.playerState, PlayerState.left);
    });

    test('Player fires laser on tap', () {
      final game = TecGame();
      final player = PlayerComponent(position: Vector2(500, 1000));
      game.world.add(player);

      player.fireLaser();
      expect(player.playerState, PlayerState.shot);

      final lasers = game.world.children.whereType<LaserComponent>();
      expect(lasers.length, 1);
      final laser = lasers.first;
      expect(laser.position.x, 500);
      expect(laser.position.y, 1000 - (PlayerComponent.playerHeight / 2));
    });

    test('Asteroids spawn and travel across screen', () {
      final asteroid = AsteroidComponent(
        position: Vector2(100, 100),
        velocity: Vector2(200, 150),
        torque: 1.5,
      );

      expect(asteroid.position, Vector2(100, 100));
      expect(asteroid.angle, 0.0);

      asteroid.update(1.0);
      expect(asteroid.position.x, 300);
      expect(asteroid.position.y, 250);
      expect(asteroid.angle, 1.5);
    });

    test('Off-screen asteroids are recycled', () {
      final asteroid = AsteroidComponent(
        position: Vector2(gameWidth + 200, 100),
        velocity: Vector2(10, 0),
      );

      expect(asteroid.isOutOfBounds, isTrue);
      asteroid.update(0.1);
      expect(asteroid.isOutOfBounds, isTrue);
    });

    test('Laser destroys asteroid and awards points', () {
      final game = TecGame();
      final laser = LaserComponent(
        position: Vector2(300, 400),
        customGame: game,
      );
      final asteroid = AsteroidComponent(
        position: Vector2(300, 400),
        velocity: Vector2(0, 0),
      );

      expect(game.score, 0);

      laser.onCollisionStart({Vector2(300, 400)}, asteroid);

      expect(laser.hasCollided, isTrue);
      expect(asteroid.isDestroyed, isTrue);
      expect(game.score, 100);
    });
  });
}

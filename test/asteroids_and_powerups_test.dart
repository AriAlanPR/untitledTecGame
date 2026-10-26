import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/components/power_up_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PersistentData.init();
  });

  group('asteroids-and-powerups', () {
    test('Large asteroid splits into two medium asteroids', () {
      final game = TecGame();
      final large = AsteroidComponent(
        position: Vector2(300, 300),
        velocity: Vector2(100, 100),
        asteroidSize: AsteroidSize.large,
        customGame: game,
      );
      game.world.add(large);

      large.hitByLaser();

      expect(large.isDestroyed, isTrue);
      final fragments = game.world.children.whereType<AsteroidComponent>().toList();
      expect(fragments.length, 2);
      expect(fragments[0].asteroidSize, AsteroidSize.medium);
      expect(fragments[1].asteroidSize, AsteroidSize.medium);
    });

    test('Medium asteroid splits into two small asteroids', () {
      final game = TecGame();
      final medium = AsteroidComponent(
        position: Vector2(300, 300),
        velocity: Vector2(100, 100),
        asteroidSize: AsteroidSize.medium,
        customGame: game,
      );
      game.world.add(medium);

      medium.hitByLaser();

      expect(medium.isDestroyed, isTrue);
      final fragments = game.world.children.whereType<AsteroidComponent>().toList();
      expect(fragments.length, 2);
      expect(fragments[0].asteroidSize, AsteroidSize.small);
      expect(fragments[1].asteroidSize, AsteroidSize.small);
    });

    test('Player collects shield power-up', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      final powerUp = PowerUpComponent(
        position: Vector2(500, 1000),
        type: PowerUpType.shield,
      );

      expect(player.hasShield, isFalse);
      expect(powerUp.isCollected, isFalse);

      powerUp.onCollisionStart({Vector2(500, 1000)}, player);

      expect(player.hasShield, isTrue);
      expect(powerUp.isCollected, isTrue);
      expect(game.activePowerUpNotifier.value, 'shield');
    });

    test('Player collects triple shot power-up', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      final powerUp = PowerUpComponent(
        position: Vector2(500, 1000),
        type: PowerUpType.tripleShot,
      );

      expect(player.hasTripleShot, isFalse);
      expect(powerUp.isCollected, isFalse);

      powerUp.onCollisionStart({Vector2(500, 1000)}, player);

      expect(player.hasTripleShot, isTrue);
      expect(powerUp.isCollected, isTrue);
      expect(game.activePowerUpNotifier.value, 'tripleShot');
    });

    test('Shield absorbs collision damage', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      player.applyPowerUp(PowerUpType.shield);

      final asteroid = AsteroidComponent(
        position: Vector2(500, 1000),
        velocity: Vector2.zero(),
        customGame: game,
      );

      expect(game.lives, 3);
      expect(player.hasShield, isTrue);

      asteroid.onCollisionStart({Vector2(500, 1000)}, player);

      // Lives MUST NOT decrease because shield absorbed the damage
      expect(game.lives, 3);
      expect(player.hasShield, isFalse);
      expect(player.isInvulnerable, isTrue);
      expect(asteroid.isDestroyed, isTrue);
    });
  });
}

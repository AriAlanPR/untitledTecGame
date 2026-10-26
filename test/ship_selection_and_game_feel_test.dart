import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PersistentData.init();
  });

  group('ship-selection-and-game-feel', () {
    test('Selected ship determines player sprite and properties', () {
      final playerAlpha = PlayerComponent(
        config: ShipConfig.alphaScout,
        position: Vector2(500, 1000),
      );
      expect(playerAlpha.config.id, 'alpha_scout');
      expect(playerAlpha.config.spriteSheet, 'character1.png');
      expect(playerAlpha.config.shotCooldown, 0.6);
      expect(playerAlpha.config.speedMultiplier, 1.0);

      final playerBeta = PlayerComponent(
        config: ShipConfig.betaInterceptor,
        position: Vector2(500, 1000),
      );
      expect(playerBeta.config.id, 'beta_interceptor');
      expect(playerBeta.config.spriteSheet, 'character2.png');
      expect(playerBeta.config.shotCooldown, 0.4);
      expect(playerBeta.config.speedMultiplier, 1.25);

      // Verify drag movement applies speed multiplier
      playerBeta.dragBy(10.0);
      expect(playerBeta.position.x, 500 + (10.0 * 1.25));
    });

    test('Ship selection persists across game sessions', () async {
      expect(await PersistentData.getSelectedShip(), 'alpha_scout');

      await PersistentData.saveSelectedShip('beta_interceptor');
      expect(await PersistentData.getSelectedShip(), 'beta_interceptor');

      final loadedShip = ShipConfig.fromId(await PersistentData.getSelectedShip());
      expect(loadedShip.id, 'beta_interceptor');
      expect(loadedShip.spriteSheet, 'character2.png');
    });

    test('Taking damage triggers camera screen shake', () {
      final game = TecGame();
      expect(game.isShaking, isFalse);
      expect(game.camera.viewfinder.position, Vector2.zero());

      game.shakeScreen(duration: 0.2, intensity: 10.0);
      expect(game.isShaking, isTrue);

      // Advance game during shake
      game.update(0.1);
      expect(game.isShaking, isTrue);

      // Advance game beyond duration
      game.update(0.15);
      expect(game.isShaking, isFalse);
      expect(game.camera.viewfinder.position, Vector2.zero());
    });

    test('Destructive collision triggers hit stop', () async {
      final game = TecGame();
      expect(game.isHitStopping, isFalse);

      game.hitStop(30);
      expect(game.isHitStopping, isTrue);

      await Future.delayed(const Duration(milliseconds: 40));
      expect(game.isHitStopping, isFalse);
    });
  });
}

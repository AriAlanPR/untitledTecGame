import 'package:flutter_test/flutter_test.dart';
import 'package:untitled_tec_game/game/components/earth_defense_platform.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/constants.dart';
import 'package:flame/extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('archer-thematics-and-ui', () {
    test('Player fires arrow projectiles with visible arrowhead and fletching', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        config: ShipConfig.alphaScout,
      );
      game.world.add(player);

      player.fireLaser();
      final lasers = game.world.children.whereType<LaserComponent>();
      expect(lasers.length, 1);
      final arrow = lasers.first;
      expect(arrow.isArrow, isTrue);
      expect(arrow.size.y, greaterThan(arrow.size.x)); // Elongated arrow shape
    });

    test('Earth defense platform renders at the bottom of the playfield', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      final platforms = world.children.whereType<EarthDefensePlatform>();
      expect(platforms.length, 1);
      final platform = platforms.first;
      expect(platform.position.y, gameHeight - EarthDefensePlatform.platformHeight);
      expect(platform.size.x, gameWidth);
      expect(platform.priority, -5);
    });
  });
}

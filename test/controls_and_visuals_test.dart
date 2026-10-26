import 'package:flutter_test/flutter_test.dart';
import 'package:flame/extensions.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/components/starfield_component.dart';
import 'package:untitled_tec_game/game/components/touch_control_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('controls-and-visuals', () {
    test('Relative touch drag moves ship horizontally without finger occlusion', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        config: ShipConfig.alphaScout,
      );
      game.world.add(player);
      final touchControl = TouchControlComponent(player: player);
      game.world.add(touchControl);

      final initialX = player.position.x;
      // Relative drag of +50 px without finger on ship
      player.dragBy(50.0);
      expect(player.position.x, initialX + 50.0);
      expect(player.playerState, PlayerState.right);

      // Drag left
      player.dragBy(-80.0);
      expect(player.position.x, initialX - 30.0);
      expect(player.playerState, PlayerState.left);
    });

    test('Tap anywhere on screen fires laser with manual cadence', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        config: ShipConfig.alphaScout,
      );
      game.world.add(player);
      final touchControl = TouchControlComponent(player: player);
      game.world.add(touchControl);

      expect(player.playerState, PlayerState.idle);

      // Simulate tap on screen forwarded to fireLaser()
      player.fireLaser();
      expect(player.playerState, PlayerState.shot);

      final lasers = game.world.children.whereType<LaserComponent>();
      expect(lasers.length, 1);
    });

    test('Starfield background renders parallax star layers during gameplay', () {
      final starfield = StarfieldComponent(distantCount: 20, nearCount: 10);
      expect(starfield.distantStars.length, 20);
      expect(starfield.nearStars.length, 10);

      final initialDistantY = starfield.distantStars.first.y;
      final initialNearY = starfield.nearStars.first.y;

      starfield.update(0.5);

      final distantDelta = starfield.distantStars.first.y - initialDistantY;
      final nearDelta = starfield.nearStars.first.y - initialNearY;

      expect(distantDelta, greaterThan(0));
      expect(nearDelta, greaterThan(0));
      // Near stars travel faster than distant stars (parallax)
      expect(nearDelta, greaterThan(distantDelta));
    });
  });
}

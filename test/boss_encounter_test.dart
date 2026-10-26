import 'package:flutter_test/flutter_test.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/game/components/boss_component.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:flame/extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('boss-encounter', () {
    test('Boss spawns after 45 seconds and reaching 1500 points', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      // Initial state: no boss, spawner active
      expect(game.bossSpawned, isFalse);
      expect(game.bossWarningNotifier.value, isFalse);
      expect(world.spawner.isPaused, isFalse);

      // Advance time to 44 seconds with 1400 points (conditions NOT met)
      game.addScore(1400);
      game.sessionTime = 44.0;
      game.update(0.1);
      expect(game.bossSpawned, isFalse);
      expect(world.spawner.isPaused, isFalse);

      // Reaching 45s but score still < 1500 (conditions NOT met)
      game.sessionTime = 46.0;
      game.update(0.1);
      expect(game.bossSpawned, isFalse);

      // Add score to reach 1500 points -> condition met!
      game.addScore(100);
      expect(game.score, 1500);
      game.update(0.1);

      expect(game.bossSpawned, isTrue);
      expect(game.bossWarningNotifier.value, isTrue);
      expect(world.spawner.isPaused, isTrue);

      // Trigger immediate boss spawn for test
      game.triggerBossEncounter(immediate: true);
      final bosses = world.children.whereType<BossComponent>();
      expect(bosses.length, 1);
      final boss = bosses.first;
      expect(boss.currentHp, BossComponent.maxHp);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/game/components/boss_component.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

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

    test('Boss fires destructible plasma projectiles at player', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      final boss = BossComponent(customGame: game);
      world.add(boss);

      expect(world.children.whereType<BossPlasmaComponent>(), isEmpty);

      // Trigger plasma shot
      boss.firePlasma();
      final plasmas = world.children.whereType<BossPlasmaComponent>();
      expect(plasmas.length, 1);
      final plasma = plasmas.first;
      expect(plasma.isDestroyed, isFalse);

      // Laser collides with plasma
      final laser = LaserComponent(position: plasma.position.clone(), customGame: game);
      world.add(laser);

      laser.onCollisionStart({plasma.position}, plasma);
      expect(plasma.isDestroyed, isTrue);
    });

    test('Laser impacts damage boss and update boss health bar', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      final boss = BossComponent(customGame: game);
      world.add(boss);
      await boss.onLoad();

      expect(boss.currentHp, 40);
      expect(game.bossHpNotifier.value, 1.0);

      // Simulate laser hitting the boss
      final laser = LaserComponent(position: boss.position.clone(), customGame: game);
      world.add(laser);

      laser.onCollisionStart({boss.position}, boss);
      expect(boss.currentHp, 39);
      expect(game.bossHpNotifier.value, 39 / 40);
    });

    test('Boss below half health triggers dive bomb attack pattern', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      final boss = BossComponent(customGame: game);
      world.add(boss);
      boss.state = BossState.strafe;

      // Boss with full health does not dive
      expect(boss.isEnraged, isFalse);

      // Reduce health below 50% (less than 20 HP)
      boss.takeDamage(22);
      expect(boss.currentHp, 18);
      expect(boss.isEnraged, isTrue);

      // Advance time to trigger dive bomb pattern
      boss.update(6.1);
      expect(boss.state, BossState.diveBomb);

      // In dive bomb state, boss descends rapidly
      final initialY = boss.position.y;
      boss.update(0.1);
      expect(boss.position.y, greaterThan(initialY));
    });

    test('Defeating boss awards bonus points and increases asteroid difficulty', () async {
      final game = TecGame();
      final world = game.world as FirstWorld;
      await world.onLoad();

      world.spawner.isPaused = true;
      world.spawner.speedMultiplier = 1.0;

      final boss = BossComponent(customGame: game);
      world.add(boss);
      boss.currentHp = 1;

      expect(game.score, 0);

      // Final fatal shot
      final laser = LaserComponent(position: boss.position.clone(), customGame: game);
      world.add(laser);

      laser.onCollisionStart({boss.position}, boss);

      // Defeated state
      expect(boss.isDefeated, isTrue);
      expect(boss.state, BossState.defeated);

      // Score bonus awarded
      expect(game.score, 1000);

      // Spawner resumed with 1.35x speed
      expect(world.spawner.isPaused, isFalse);
      expect(world.spawner.speedMultiplier, 1.35);
    });
  });
}

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';
import 'package:untitled_tec_game/views/score_menu_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('lifecycle-and-scoring', () {
    test('Asteroid collision decrements player life', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      final asteroid = AsteroidComponent(
        position: Vector2(500, 1000),
        velocity: Vector2.zero(),
        customGame: game,
      );

      expect(game.lives, 3);
      expect(player.isInvulnerable, isFalse);
      expect(asteroid.isDestroyed, isFalse);

      asteroid.onCollisionStart({Vector2(500, 1000)}, player);

      expect(game.lives, 2);
      expect(player.isInvulnerable, isTrue);
      expect(asteroid.isDestroyed, isTrue);
    });

    test('Invulnerable player does not take damage', () {
      final game = TecGame();
      final player = PlayerComponent(
        position: Vector2(500, 1000),
        customGame: game,
      );
      final asteroid1 = AsteroidComponent(
        position: Vector2(500, 1000),
        velocity: Vector2.zero(),
        customGame: game,
      );
      final asteroid2 = AsteroidComponent(
        position: Vector2(500, 1000),
        velocity: Vector2.zero(),
        customGame: game,
      );

      // First collision makes player invulnerable and drops life to 2
      asteroid1.onCollisionStart({Vector2(500, 1000)}, player);
      expect(game.lives, 2);
      expect(player.isInvulnerable, isTrue);

      // Second collision while invulnerable should be ignored
      asteroid2.onCollisionStart({Vector2(500, 1000)}, player);
      expect(game.lives, 2);
      expect(asteroid2.isDestroyed, isFalse);
    });

    test('Reaching zero lives triggers game over', () {
      final game = TecGame();
      expect(game.lives, 3);
      expect(game.isGameOver, isFalse);

      game.takeDamage();
      expect(game.lives, 2);
      expect(game.isGameOver, isFalse);

      game.takeDamage();
      expect(game.lives, 1);
      expect(game.isGameOver, isFalse);

      game.takeDamage();
      expect(game.lives, 0);
      expect(game.isGameOver, isTrue);
    });

    test('New high score is saved in sorted order', () async {
      SharedPreferences.setMockInitialValues({});
      await PersistentData.init();

      final scoresToInsert = [200, 500, 100, 900, 300, 400, 600, 700, 800, 50, 1000];
      for (final s in scoresToInsert) {
        await PersistentData.saveHighScore(s);
      }

      final top10 = await PersistentData.getHighScores();
      expect(top10.length, 10);
      expect(top10, [1000, 900, 800, 700, 600, 500, 400, 300, 200, 100]);
    });

    testWidgets('Score menu displays top 10 scores', (WidgetTester tester) async {
      final scores = [1000, 900, 800, 700, 600, 500, 400, 300, 200, 100];

      await tester.pumpWidget(
        MaterialApp(
          home: ScoreMenuPage(scores: scores),
        ),
      );

      for (final s in scores) {
        expect(find.text(s.toString()), findsOneWidget);
      }
    });
  });
}

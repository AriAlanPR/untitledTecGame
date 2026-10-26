import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled_tec_game/game/components/earth_defense_platform.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/constants.dart';
import 'package:untitled_tec_game/views/configuration_page.dart';
import 'package:untitled_tec_game/views/score_menu_page.dart';
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

    testWidgets('Score menu provides navigation back to main start menu', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const Scaffold(body: Text('START_MENU_PAGE')),
            '/scores': (context) => ScoreMenuPage(scores: const [100, 50]),
          },
          initialRoute: '/scores',
        ),
      );
      await tester.pumpAndSettle();

      final mainMenuBtn = find.byKey(const Key('score_menu_main_menu_btn'));
      expect(mainMenuBtn, findsOneWidget);

      await tester.tap(mainMenuBtn);
      await tester.pumpAndSettle();

      expect(find.text('START_MENU_PAGE'), findsOneWidget);
    });

    testWidgets('Score menu displays top scores with styled medal ranking', (tester) async {
      final scores = [1500, 1200, 900, 600, 300];
      await tester.pumpWidget(
        MaterialApp(
          home: ScoreMenuPage(scores: scores),
        ),
      );
      await tester.pumpAndSettle();

      // Verify top 3 have distinct rank badges
      expect(find.byKey(const Key('score_rank_badge_1')), findsOneWidget);
      expect(find.byKey(const Key('score_rank_badge_2')), findsOneWidget);
      expect(find.byKey(const Key('score_rank_badge_3')), findsOneWidget);
      expect(find.byKey(const Key('score_rank_badge_4')), findsOneWidget);

      for (final s in scores) {
        expect(find.text(s.toString()), findsOneWidget);
      }
    });

    testWidgets('Configuration page renders styled audio and profile controls', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConfigurationPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('config_player_name_field')), findsOneWidget);
      expect(find.byKey(const Key('config_save_name_btn')), findsOneWidget);
      expect(find.byKey(const Key('config_bgm_switch')), findsOneWidget);
      expect(find.byKey(const Key('config_sfx_switch')), findsOneWidget);
      expect(find.byKey(const Key('config_bgm_slider')), findsOneWidget);
      expect(find.byKey(const Key('config_sfx_slider')), findsOneWidget);
    });
  });
}

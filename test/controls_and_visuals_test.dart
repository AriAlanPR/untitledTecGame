import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/components/starfield_component.dart';
import 'package:untitled_tec_game/game/components/touch_control_component.dart';
import 'package:untitled_tec_game/game/overlays/game_hud_overlay.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/views/start_menu_page.dart';

Widget _buildTestApp(Widget child) {
  LocalJsonLocalization.delegate.directories = ['assets/i18n'];
  return MaterialApp(
    supportedLocales: const [Locale('es', 'MX'), Locale('en', 'US')],
    locale: const Locale('es', 'MX'),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      LocalJsonLocalization.delegate,
    ],
    home: Material(child: child),
  );
}

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

    testWidgets('How to play modal displays instructions from start menu', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(_buildTestApp(const StartMenu()));
      await tester.pumpAndSettle();

      final howToPlayBtn = find.byKey(const Key('start_menu_how_to_play_btn'));
      expect(howToPlayBtn, findsOneWidget);

      await tester.tap(howToPlayBtn);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('how_to_play_sheet')), findsOneWidget);
      expect(find.byKey(const Key('how_to_play_title')), findsOneWidget);
      expect(find.byKey(const Key('how_to_play_close_btn')), findsOneWidget);

      // Close modal
      await tester.tap(find.byKey(const Key('how_to_play_close_btn')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('how_to_play_sheet')), findsNothing);
    });

    testWidgets('Start of game displays transient guidance prompt', (tester) async {
      final game = TecGame();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: GameHudOverlay(game: game)),
        ),
      );
      await tester.pump();

      expect(find.byType(GameHudOverlay), findsOneWidget);
      final promptFinder = find.byKey(const Key('hud_guidance_prompt'));
      expect(promptFinder, findsOneWidget);

      final animatedOpacity = tester.widget<AnimatedOpacity>(promptFinder);
      expect(animatedOpacity.opacity, 1.0);

      // Advance time past 2.5s timer
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pump(const Duration(milliseconds: 300));

      final fadedOpacity = tester.widget<AnimatedOpacity>(promptFinder);
      expect(fadedOpacity.opacity, 0.0);
    });
  });
}

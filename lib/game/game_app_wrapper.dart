//NOTE: scaffold wrapper
//NOTE: this widget will represent a container as a scaffold that wraps the game scope
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/game/overlays/game_hud_overlay.dart';
import 'package:untitled_tec_game/game/overlays/game_over_overlay.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/views/configuration_page.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/views/score_menu_page.dart';
import 'package:untitled_tec_game/views/start_menu_page.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/navigate.dart';

class GameAppWrapper extends StatefulWidget {
  const GameAppWrapper({super.key});

  @override
  State<GameAppWrapper> createState() => _GameAppWrapperState();
}

class _GameAppWrapperState extends State<GameAppWrapper> with ValidateMixin {
  String currentRoute = '/';

  Widget _gameWidget({ShipConfig? ship}) {
    final activeShip = ship ?? ShipConfig.alphaScout;
    final game = isMobile ? TecGame(shipConfig: activeShip) : TecGame.web(shipConfig: activeShip);
    final gameWidget = GameWidget<TecGame>(
      game: game,
      initialActiveOverlays: const ['hud'],
      overlayBuilderMap: {
        'hud': (context, game) => GameHudOverlay(game: game),
        'gameOver': (context, game) => GameOverOverlay(game: game),
      },
    );

    return isMobile
      ? gameWidget
      : Center(
        child: FittedBox(
            child: SizedBox(
          width: defaultWidth,
          height: defaultHeight,
          child: gameWidget,
        )),
      );
  }
  
  Widget getCurrentPage(String route, {Map<String, dynamic>? arguments}) {


    switch (route) {
      case '/scores':
        return ScoreMenuPage();
      case '/configuration':
        return ConfigurationPage();
      case '/game':
        final ship = arguments?['ship'] as ShipConfig?;
        return _gameWidget(ship: ship);
      case '/':
      default: // Same as '/'
        return StartMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/i18n'];
    
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: AppColors.seed,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'MX'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        // If device language is supported for other region
        if (locale?.languageCode == 'es') {
          return const Locale('es', 'MX');
        }

        // default language
        return const Locale('en', 'US');
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      home: Material(
        child: Navigator(
          onGenerateRoute: (settings) {
            //NOTE: uncomment and use this in case is required to pass arguments dynamically
            final args = settings.arguments as Map<String, dynamic>?;
            Widget toPage = getCurrentPage(settings.name!, arguments: args);

            return Navigate(
              toPage: toPage,
              fromPage: getCurrentPage(currentRoute),
            ).route;
          },
        ),
      ),
    );
  }
}

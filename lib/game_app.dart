//NOTE: scaffold wrapper
//NOTE: this widget will represent a container as a scaffold that wraps the game scope
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/configuration_page.dart';
import 'package:untitled_tec_game/game_scope.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/score_menu_page.dart';
import 'package:untitled_tec_game/start_menu_page.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/navigate.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> with ValidateMixin {
  String currentRoute = '/';
  bool _requireAppBar = false;

  Widget _gameWidget() {
    final game = isMobile ? GameScope() : GameScope.web();
    final gameWidget = GameWidget(
      game: game,
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
        return _gameWidget();
      case '/':
      default: // Same as '/'
        return StartMenu();
    }
  }

  PreferredSizeWidget? _appBar() {
    return AppBar(
      title: Text('Tec Game'),
    );
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
      home: Scaffold(
        appBar: _requireAppBar ? _appBar() : null,
        body: Navigator(
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

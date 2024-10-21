//NOTE: scaffold wrapper
//NOTE: this widget will represent a container as a scaffold that wraps the game scope
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: AppColors.seed,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return Navigate(
              toPage: StartMenu(), 
              fromPage: widget,
            ).route;
          case '/scores':
            return Navigate(
              toPage: ScoreMenuPage(),
              fromPage: widget,
            ).route;
          case '/configuration':
            return Navigate(
              toPage: ConfigurationPage(),
              fromPage: widget,
            ).route;
          case '/game':
            return Navigate(
              toPage: _gameWidget(),
              fromPage: widget,
            ).route;
          default: //NOTE - Same as '/'
            return Navigate(
              toPage: StartMenu(), 
              fromPage: widget,
            ).route;
        }
      },
      home: Scaffold(
        appBar: AppBar(
        title: Text('My App'),
        ),
        body: StartMenu(),
      ),
    );
  }
}

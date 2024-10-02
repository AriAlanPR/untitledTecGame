//NOTE: scaffold wrapper
//NOTE: this widget will represent a container as a scaffold that wraps the game scope
import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/constants.dart';
import 'package:untitled_tec_game/game_scope.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final GameScope game;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    game = GameScope();
  }

  Widget _gameWidget() {
    return GameWidget(
      game: game,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: _isMobile
              ? _gameWidget()
              : Center(
                  child: FittedBox(
                      child: SizedBox(
                    width: gameWidth,
                    height: gameHeight,
                    child: _gameWidget(),
                  )),
                ),
        ),
      ),
    );
  }
}

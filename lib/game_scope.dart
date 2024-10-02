import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/character.dart';
import 'package:untitled_tec_game/player.dart';

class GameScope extends FlameGame {
  final Color bgColor;
  GameScope({
    super.children,
    this.bgColor = Colors.white,
  });

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    //NOTE - By default the center of the world(in this case the screen) is at position (0,0)
    final player = Player(
      position: Vector2(0, 0),
      radius: 50,
      color: Colors.red,
    );

    final character = Character(
      position: Vector2(0, 100),
      radius: 20,
      color: Colors.blue,
    );

    world.add(player);
    world.add(character);
  }

  @override
  Color backgroundColor() {
    return bgColor;
  }

  void _addCharacter() {}
}

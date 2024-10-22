import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/character.dart';
import 'package:untitled_tec_game/game/components/player.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

//NOTES - By default the center of the world(in this case the screen) is at position (0,0)

class FirstWorld extends World with HasGameRef<TecGame>{

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    _addCharacter(
      color: Colors.red,
      isPlayer: true,
    );

    _addCharacter(
      color: Colors.blue,
      isPlayer: false,
    );
  }

  //NOTE - By default the center of the world(in this case the screen) is at position (0,0)
  void _addCharacter({double x = 0, double y = 0, Color? color, bool isPlayer = false}) {
    if (isPlayer) {
      add(Player(
        position: Vector2(x, y),
        radius: 50,
        color: color ?? Colors.red,
      ));
    } else {
      add(Character(
        position: Vector2(x, y),
        radius: 20,
        color: color ?? Colors.blue,
      ));
    }
  }
}
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game_components/character.dart';
import 'package:untitled_tec_game/constants.dart';
import 'package:untitled_tec_game/game_components/player.dart';

class GameScope extends FlameGame {
  final Color bgColor;
  GameScope({
    super.children,
    this.bgColor = Colors.white,
  });

  GameScope.web({
    this.bgColor = Colors.white,
  }) : super(
            camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ));

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

  //NOTE - By default the center of the world(in this case the screen) is at position (0,0)
  void _addCharacter({double x = 0, double y = 0, Color? color, bool isPlayer = false}) {
    if (isPlayer) {
      world.add(Player(
        position: Vector2(x, y),
        radius: 50,
        color: color ?? Colors.red,
      ));
    } else {
      world.add(Character(
        position: Vector2(x, y),
        radius: 20,
        color: color ?? Colors.blue,
      ));
    }
  }
}

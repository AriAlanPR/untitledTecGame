import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class TecGame extends FlameGame with HasCollisionDetection {
  final Color bgColor;
  int score = 0;

  TecGame({
    super.children,
    this.bgColor = AppColors.navy,
  }) : super(
          world: FirstWorld(),
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          )..viewfinder.anchor = Anchor.topLeft,
        );

  TecGame.web({
    this.bgColor = AppColors.navy,
  }) : super(
          world: FirstWorld(),
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          )..viewfinder.anchor = Anchor.topLeft,
        );

  void addScore(int points) {
    score += points;
  }

  @override
  Color backgroundColor() {
    return bgColor;
  }
}
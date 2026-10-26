import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/constants.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

class TecGame extends FlameGame with HasCollisionDetection {
  final Color bgColor;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier<int>(3);
  bool isGameOver = false;

  int get score => scoreNotifier.value;
  int get lives => livesNotifier.value;

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
    scoreNotifier.value += points;
  }

  bool takeDamage() {
    if (isGameOver) return false;
    if (livesNotifier.value > 0) {
      livesNotifier.value -= 1;
      if (livesNotifier.value <= 0) {
        triggerGameOver();
      }
      return true;
    }
    return false;
  }

  void triggerGameOver() {
    if (isGameOver) return;
    isGameOver = true;
    unawaited(PersistentData.saveHighScore(score));
    pauseEngine();
    try {
      overlays.add('gameOver');
    } catch (_) {
      // Overlays are only registered when GameWidget mounts the game
    }
  }

  void resetGame() {
    isGameOver = false;
    scoreNotifier.value = 0;
    livesNotifier.value = 3;
    if (world is FirstWorld) {
      (world as FirstWorld).reset();
    }
    resumeEngine();
    try {
      overlays.remove('gameOver');
    } catch (_) {
      // Overlays are only registered when GameWidget mounts the game
    }
  }

  @override
  Color backgroundColor() {
    return bgColor;
  }
}
import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/constants.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';

class TecGame extends FlameGame with HasCollisionDetection {
  final Color bgColor;
  final ShipConfig shipConfig;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier<int>(3);
  final ValueNotifier<String?> activePowerUpNotifier = ValueNotifier<String?>(null);
  bool isGameOver = false;

  int get score => scoreNotifier.value;
  int get lives => livesNotifier.value;

  double _shakeTimer = 0.0;
  double _shakeDuration = 0.0;
  double _shakeIntensity = 0.0;
  final Random _random = Random();
  bool _isHitStopping = false;

  bool get isShaking => _shakeTimer > 0;
  bool get isHitStopping => _isHitStopping;

  void shakeScreen({double duration = 0.3, double intensity = 15.0}) {
    _shakeDuration = duration;
    _shakeTimer = duration;
    _shakeIntensity = intensity;
  }

  void hitStop([int milliseconds = 45]) {
    if (_isHitStopping || isGameOver) return;
    _isHitStopping = true;
    pauseEngine();
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _isHitStopping = false;
      if (!isGameOver) {
        resumeEngine();
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      if (_shakeTimer <= 0) {
        _shakeTimer = 0.0;
        camera.viewfinder.position = Vector2.zero();
      } else {
        final progress = _shakeTimer / _shakeDuration;
        final currentIntensity = _shakeIntensity * progress;
        final offsetX = (_random.nextDouble() * 2 - 1) * currentIntensity;
        final offsetY = (_random.nextDouble() * 2 - 1) * currentIntensity;
        camera.viewfinder.position = Vector2(offsetX, offsetY);
      }
    }
  }

  TecGame({
    super.children,
    this.bgColor = AppColors.navy,
    this.shipConfig = ShipConfig.alphaScout,
  }) : super(
          world: FirstWorld(shipConfig: shipConfig),
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          )..viewfinder.anchor = Anchor.topLeft,
        );

  TecGame.web({
    this.bgColor = AppColors.navy,
    this.shipConfig = ShipConfig.alphaScout,
  }) : super(
          world: FirstWorld(shipConfig: shipConfig),
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
    AudioManager.instance.playGameOver();
    AudioManager.instance.pauseBgm();
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
    _shakeTimer = 0.0;
    camera.viewfinder.position = Vector2.zero();
    scoreNotifier.value = 0;
    livesNotifier.value = 3;
    activePowerUpNotifier.value = null;
    if (world is FirstWorld) {
      (world as FirstWorld).reset();
    }
    resumeEngine();
    AudioManager.instance.resumeBgm();
    try {
      overlays.remove('gameOver');
    } catch (_) {
      // Overlays are only registered when GameWidget mounts the game
    }
  }

  @override
  void onMount() {
    super.onMount();
    AudioManager.instance.startBgm();
  }

  @override
  void onRemove() {
    AudioManager.instance.stopBgm();
    super.onRemove();
  }

  @override
  Color backgroundColor() {
    return bgColor;
  }
}
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/components/first_world.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/constants.dart';

enum BossState {
  entering,
  strafe,
  diveBomb,
  returning,
  defeated,
}

class BossComponent extends SpriteAnimationComponent
    with HasGameRef<TecGame>, CollisionCallbacks {
  static const int maxHp = 40;
  int currentHp = maxHp;
  final TecGame? customGame;

  BossState state = BossState.entering;
  double _strafeDirection = 1.0;
  double _strafeSpeed = 160.0;
  double _attackTimer = 0.0;
  double _diveTimer = 0.0;
  double _diveTargetX = 0.0;
  double _damageFlashTimer = 0.0;

  static const double targetAltitude = 180.0;
  static const double minX = 120.0;
  static const double maxX = gameWidth - 120.0;

  double get hpPercentage => (currentHp / maxHp).clamp(0.0, 1.0);
  bool get isDefeated => currentHp <= 0;
  bool get isEnraged => currentHp < (maxHp / 2); // Phase 2: < 50% HP

  TecGame? get effectiveGame {
    if (customGame != null) return customGame;
    try {
      return isMounted ? gameRef : null;
    } catch (_) {
      return null;
    }
  }

  BossComponent({
    Vector2? position,
    this.customGame,
  }) : super(
          position: position ?? Vector2(gameWidth / 2, -150),
          size: Vector2(200, 122),
          anchor: Anchor.center,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      final image = await (effectiveGame?.images ?? gameRef.images).load('metalshark.png');
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(305, 186),
      );

      final frames = <Sprite>[];
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 2; col++) {
          frames.add(spriteSheet.getSprite(row, col));
        }
      }

      animation = SpriteAnimation.spriteList(
        frames,
        stepTime: 0.12,
        loop: true,
      );
    } catch (_) {
      // Fallback for headless tests where asset loading isn't mocked
    }

    add(CircleHitbox(
      radius: 55,
      position: size / 2,
      anchor: Anchor.center,
    ));

    effectiveGame?.bossHpNotifier.value = hpPercentage;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_damageFlashTimer > 0) {
      _damageFlashTimer -= dt;
      if (_damageFlashTimer <= 0) {
        paint.color = Colors.white;
      }
    }

    switch (state) {
      case BossState.entering:
        position.y += 150.0 * dt;
        if (position.y >= targetAltitude) {
          position.y = targetAltitude;
          state = BossState.strafe;
        }
        break;

      case BossState.strafe:
        _updateStrafe(dt);
        _updateAttacks(dt);
        break;

      case BossState.diveBomb:
        _updateDiveBomb(dt);
        break;

      case BossState.returning:
        _updateReturning(dt);
        break;

      case BossState.defeated:
        break;
    }
  }

  void _updateStrafe(double dt) {
    position.x += _strafeDirection * _strafeSpeed * dt;
    if (position.x >= maxX) {
      position.x = maxX;
      _strafeDirection = -1.0;
    } else if (position.x <= minX) {
      position.x = minX;
      _strafeDirection = 1.0;
    }

    if (isEnraged) {
      _strafeSpeed = 260.0;
      _diveTimer += dt;
      // In phase 2, dive bomb every 6 seconds
      if (_diveTimer >= 6.0) {
        _diveTimer = 0.0;
        _startDiveBomb();
      }
    }
  }

  void _updateAttacks(double dt) {
    _attackTimer += dt;
    final attackInterval = isEnraged ? 1.4 : 2.2;
    if (_attackTimer >= attackInterval) {
      _attackTimer = 0.0;
      firePlasma();
    }
  }

  void firePlasma() {
    if (state == BossState.defeated) return;

    Vector2 playerPos = Vector2(gameWidth / 2, gameHeight - 250);
    if (parent is FirstWorld) {
      playerPos = (parent as FirstWorld).player.position;
    }

    final spawnPos = Vector2(position.x, position.y + (size.y / 2));
    final direction = (playerPos - spawnPos).normalized();

    final plasma = BossPlasmaComponent(
      position: spawnPos,
      velocity: direction * 380.0,
      customGame: effectiveGame,
    );
    parent?.add(plasma);
  }

  void _startDiveBomb() {
    state = BossState.diveBomb;
    Vector2 playerPos = Vector2(gameWidth / 2, gameHeight - 250);
    if (parent is FirstWorld) {
      playerPos = (parent as FirstWorld).player.position;
    }
    _diveTargetX = playerPos.x;
    effectiveGame?.shakeScreen(duration: 0.2, intensity: 10.0);
  }

  void _updateDiveBomb(double dt) {
    position.x += (_diveTargetX - position.x) * 4.0 * dt;
    position.y += 650.0 * dt;

    if (position.y >= gameHeight - 200) {
      state = BossState.returning;
    }
  }

  void _updateReturning(double dt) {
    position.y -= 350.0 * dt;
    if (position.y <= targetAltitude) {
      position.y = targetAltitude;
      state = BossState.strafe;
    }
  }

  void takeDamage([int amount = 1]) {
    if (state == BossState.defeated) return;

    currentHp = max(0, currentHp - amount);
    effectiveGame?.bossHpNotifier.value = hpPercentage;

    // Visual damage flash
    _damageFlashTimer = 0.08;
    paint.color = Colors.redAccent;
    AudioManager.instance.playDamage();
    effectiveGame?.shakeScreen(duration: 0.1, intensity: 6.0);

    if (currentHp <= 0) {
      _triggerDefeat();
    }
  }

  void _triggerDefeat() {
    state = BossState.defeated;
    effectiveGame?.bossHpNotifier.value = 0.0;
    AudioManager.instance.playExplosion();
    effectiveGame?.shakeScreen(duration: 0.6, intensity: 20.0);

    // Award +1000 bonus points
    effectiveGame?.addScore(1000);

    // Resume spawner with 1.35x speed multiplier
    if (effectiveGame?.world is FirstWorld) {
      final fw = effectiveGame!.world as FirstWorld;
      fw.spawner.isPaused = false;
      fw.spawner.speedMultiplier = 1.35;
    }

    effectiveGame?.bossHpNotifier.value = null;
    removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (state == BossState.defeated) return;

    if (other is LaserComponent) {
      other.removeFromParent();
      takeDamage(1);
    } else if (other is PlayerComponent) {
      if (!other.isInvulnerable) {
        other.takeDamage();
      }
    }
  }
}

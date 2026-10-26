import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/services/audio_manager.dart';
import 'package:untitled_tec_game/utils/constants.dart';

enum PlayerState { idle, left, right, shot }

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<TecGame>, DragCallbacks, TapCallbacks, CollisionCallbacks {
  static const double playerWidth = 128.0;
  static const double playerHeight = 128.0;
  static const double minX = playerWidth / 2;
  static const double maxX = gameWidth - (playerWidth / 2);

  double _shotTimer = 0.0;
  PlayerState _state = PlayerState.idle;
  bool _isInvulnerable = false;
  double _invulnerabilityTimer = 0.0;
  static const double invulnerabilityDuration = 2.5;
  double _blinkTimer = 0.0;
  static const double blinkInterval = 0.15;
  final TecGame? customGame;
  final ShipConfig config;

  bool get isInvulnerable => _isInvulnerable;
  PlayerState get playerState => _state;
  TecGame get effectiveGame => customGame ?? gameRef;

  set playerState(PlayerState newState) {
    _state = newState;
    if (animations != null) {
      current = newState;
    }
  }

  PlayerComponent({
    super.animations,
    super.current,
    Vector2? position,
    this.customGame,
    this.config = ShipConfig.alphaScout,
  }) : super(
          position: position ?? Vector2(gameWidth / 2, gameHeight - 250),
          size: Vector2(playerWidth, playerHeight),
          anchor: Anchor.center,
        );

  void takeDamage() {
    if (_isInvulnerable) return;

    final damaged = effectiveGame.takeDamage();
    if (damaged) {
      _isInvulnerable = true;
      _invulnerabilityTimer = 0.0;
      _blinkTimer = 0.0;
      AudioManager.instance.playDamage();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (animations == null || animations!.isEmpty) {
      final image = await gameRef.images.load(config.spriteSheet);
      final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(64, 64),
      );

      // Frame indices from TecISC/helpers/character1.lua (0-based)
      // idle: first frame
      final idleAnimation = SpriteAnimation.spriteList(
        [spriteSheet.getSpriteById(0)],
        stepTime: 1.0,
        loop: true,
      );

      // left: frames 69..76 (count 8, 600ms)
      final leftAnimation = SpriteAnimation.spriteList(
        [for (int i = 69; i < 69 + 8; i++) spriteSheet.getSpriteById(i)],
        stepTime: 0.6 / 8,
        loop: true,
      );

      // right: frames 87..94 (count 8, 600ms)
      final rightAnimation = SpriteAnimation.spriteList(
        [for (int i = 87; i < 87 + 8; i++) spriteSheet.getSpriteById(i)],
        stepTime: 0.6 / 8,
        loop: true,
      );

      // shot: frames 122..132 (count 11, 600ms)
      final shotAnimation = SpriteAnimation.spriteList(
        [for (int i = 122; i < 122 + 11; i++) spriteSheet.getSpriteById(i)],
        stepTime: 0.6 / 11,
        loop: false,
      );

      animations = {
        PlayerState.idle: idleAnimation,
        PlayerState.left: leftAnimation,
        PlayerState.right: rightAnimation,
        PlayerState.shot: shotAnimation,
      };

      playerState = PlayerState.idle;
    }

    add(CircleHitbox(radius: 40, anchor: Anchor.center, position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == PlayerState.shot) {
      _shotTimer += dt;
      if (_shotTimer >= config.shotCooldown) {
        _shotTimer = 0.0;
        playerState = PlayerState.idle;
      }
    }

    if (_isInvulnerable) {
      _invulnerabilityTimer += dt;
      _blinkTimer += dt;

      if (_blinkTimer >= blinkInterval) {
        _blinkTimer = 0.0;
        opacity = (opacity == 1.0) ? 0.3 : 1.0;
      }

      if (_invulnerabilityTimer >= invulnerabilityDuration) {
        _isInvulnerable = false;
        _invulnerabilityTimer = 0.0;
        opacity = 1.0;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    dragBy(event.localDelta.x);
  }

  void dragBy(double deltaX) {
    position.x += deltaX * config.speedMultiplier;
    position.x = position.x.clamp(minX, maxX);

    if (_state != PlayerState.shot) {
      if (deltaX < -0.5) {
        playerState = PlayerState.left;
      } else if (deltaX > 0.5) {
        playerState = PlayerState.right;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_state != PlayerState.shot) {
      playerState = PlayerState.idle;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_state != PlayerState.shot) {
      playerState = PlayerState.idle;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    fireLaser();
  }

  void fireLaser() {
    playerState = PlayerState.shot;
    _shotTimer = 0.0;
    AudioManager.instance.playLaser();

    final laser = LaserComponent(
      position: Vector2(position.x, position.y - (size.y / 2)),
    );
    parent?.add(laser);
  }
}

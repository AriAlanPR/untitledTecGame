import 'dart:async';
import 'package:flame/components.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/asteroid_spawner.dart';
import 'package:untitled_tec_game/game/components/boss_component.dart';
import 'package:untitled_tec_game/game/components/boss_plasma_component.dart';
import 'package:untitled_tec_game/game/components/earth_defense_platform.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/components/power_up_component.dart';
import 'package:untitled_tec_game/game/components/starfield_component.dart';
import 'package:untitled_tec_game/game/components/touch_control_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class FirstWorld extends World with HasGameRef<TecGame> {
  final ShipConfig shipConfig;
  late final PlayerComponent player;
  late final AsteroidSpawner spawner;
  late final TouchControlComponent touchControl;
  late final StarfieldComponent starfield;
  late final EarthDefensePlatform earthPlatform;

  FirstWorld({this.shipConfig = ShipConfig.alphaScout});

  void reset() {
    children.whereType<AsteroidComponent>().toList().forEach((a) => a.removeFromParent());
    children.whereType<LaserComponent>().toList().forEach((l) => l.removeFromParent());
    children.whereType<PowerUpComponent>().toList().forEach((p) => p.removeFromParent());
    children.whereType<BossComponent>().toList().forEach((b) => b.removeFromParent());
    children.whereType<BossPlasmaComponent>().toList().forEach((bp) => bp.removeFromParent());
    spawner.isPaused = false;
    spawner.speedMultiplier = 1.0;
    player.position = Vector2(gameWidth / 2, gameHeight - 250);
    player.resetState();
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    starfield = StarfieldComponent();
    add(starfield);

    earthPlatform = EarthDefensePlatform();
    add(earthPlatform);

    player = PlayerComponent(config: shipConfig);
    add(player);

    spawner = AsteroidSpawner();
    add(spawner);

    touchControl = TouchControlComponent(player: player);
    add(touchControl);
  }
}
import 'dart:async';
import 'package:flame/components.dart';
import 'package:untitled_tec_game/game/components/asteroid_component.dart';
import 'package:untitled_tec_game/game/components/asteroid_spawner.dart';
import 'package:untitled_tec_game/game/components/laser_component.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/utils/constants.dart';

class FirstWorld extends World with HasGameRef<TecGame> {
  late final PlayerComponent player;
  late final AsteroidSpawner spawner;

  void reset() {
    children.whereType<AsteroidComponent>().toList().forEach((a) => a.removeFromParent());
    children.whereType<LaserComponent>().toList().forEach((l) => l.removeFromParent());
    player.position = Vector2(gameWidth / 2, gameHeight - 250);
    player.opacity = 1.0;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    player = PlayerComponent();
    add(player);

    spawner = AsteroidSpawner();
    add(spawner);
  }
}
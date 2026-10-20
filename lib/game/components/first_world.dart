import 'dart:async';
import 'package:flame/components.dart';
import 'package:untitled_tec_game/game/components/asteroid_spawner.dart';
import 'package:untitled_tec_game/game/components/player_component.dart';
import 'package:untitled_tec_game/game/tec_game.dart';

class FirstWorld extends World with HasGameRef<TecGame> {
  late final PlayerComponent player;
  late final AsteroidSpawner spawner;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    player = PlayerComponent();
    add(player);

    spawner = AsteroidSpawner();
    add(spawner);
  }
}
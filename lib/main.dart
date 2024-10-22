import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game/game_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Hides status bar to give immersion in-game
  Flame.device.fullScreen();
  //locks device to portrait view
  Flame.device.setPortrait();

  runApp(const GameApp());
}

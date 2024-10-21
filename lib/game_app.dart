//NOTE: scaffold wrapper
//NOTE: this widget will represent a container as a scaffold that wraps the game scope
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/start_menu_page.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: AppColors.seed,
      ),
      home: const Scaffold(
        body: StartMenu(),
      ),
    );
  }
}

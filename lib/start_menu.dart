import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game_scope.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> with ValidateMixin {
  late final GameScope game;
  late final double width;
  late final double height;

  @override
  void initState() {
    super.initState();
    game = isMobile ? GameScope() : GameScope.web();
    width = calculatedWidth(context);
    height = calculatedHeight(context);
  }

  Widget _gameWidget() {
    return GameWidget(
      game: game,
    );
  }

  Widget onStart() {
    return isMobile
      ? _gameWidget()
      : Center(
          child: FittedBox(
              child: SizedBox(
            width: defaultWidth,
            height: defaultHeight,
            child: _gameWidget(),
          )),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/banner.png'),
                width: 200,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: onStart,
              child: const Text("Jugar"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("puntitos presionado");
                },
                child: const Text("Puntos"),
              ),
              ElevatedButton(
                onPressed: () {
                  print("configuracion presionado");
                }, 
                child: const Text("Configuracion"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
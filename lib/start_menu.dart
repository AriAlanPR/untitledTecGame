import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game_scope.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = calculatedWidth(context);
    height = calculatedHeight(context);
    println("height: $height width: $width");
  }


  Widget _gameWidget() {
    return GameWidget(
      game: game,
    );
  }

  Widget onStart() {
    println("starting game...");
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
          SizedBox(
            height: height * 0.1,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/banner.png'),
                width: 400,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightButtonBackground,
                elevation: 5,
              ),
              child: const Text(
                "Jugar",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    println("puntitos presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: const Text("Puntos"),
                ),
                ElevatedButton(
                  onPressed: () {
                    println("configuracion presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: const Text("Configuracion"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
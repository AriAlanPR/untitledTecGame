import 'package:flutter/material.dart';
import 'package:untitled_tec_game/game_scope.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/coolborders.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';
import 'package:untitled_tec_game/widgets/particles.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> with ValidateMixin {
  late final GameScope game;
  late double width;
  late double height;
  final double defaultButtonOpacity = 0.9;

  @override

  void initState() {
    super.initState();
    
    game = isMobile ? GameScope() : GameScope.web();
  }


  void onStart() {
    println("starting game...");
    Particles(
      context: context,
      number: 30,
    ).showStar();
  }

  @override
  Widget build(BuildContext context) {
    width = calculatedWidth(context);
    height = calculatedHeight(context);
    println("height: $height width: $width");

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
          SizedBox(),
          Row( //NOTE - banner de titulo
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/banner.png'),
                width: width * 0.67,
                height: height * 0.1,
                fit: BoxFit.fill,
              ),
            ],
          ),
          ElevatedButton( //NOTE - jugar
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 5,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: CoolBorders(
                  borderDesign: BorderDesign.all,
                  radius: 40,
                ).getRadius,
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade300.withOpacity(defaultButtonOpacity),
                    Colors.green.shade200,
                    Colors.green.shade100,
                    Colors.white.withOpacity(defaultButtonOpacity)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding( //icono de jugar
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 48.0,
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: height * 0.08,
                ),
              ),
            ),
          ),
          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton( //NOTE - puntajes
                  onPressed: () {
                    println("puntitos presionado");
                    Particles(
                      context: context,
                      vertically: 90,
                      horizontally: 20,
                    ).showConfetti();

                    Navigator.pushNamed(
                      context,
                      '/scores',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.emoji_events,
                      size: height * 0.07,
                    ),
                  ),
                ),
                ElevatedButton( //NOTE - configuracion
                  onPressed: () {
                    println("configuracion presionado");
                    Particles(
                      context: context,
                      number: 20,
                      vertically: 90,
                      horizontally: 80,
                    ).showEmoji();

                    Navigator.pushNamed(
                      context,
                      '/configuration',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.settings,
                      size: height * 0.07,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
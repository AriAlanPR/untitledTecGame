import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/configuration_page.dart';
import 'package:untitled_tec_game/game_scope.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/score_menu_page.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/coolborders.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';
import 'package:untitled_tec_game/utils/navigate.dart';
import 'package:untitled_tec_game/widgets/particles.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> with ValidateMixin {
  late final GameScope game;
  late final double width;
  late final double height;
  final double defaultButtonOpacity = 0.9;

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
    Particles(
      context: context,                      
    ).showConfetti();

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
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/banner.png'),
                width: width * 0.65,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
          ElevatedButton(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 48.0,
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: 70.0,
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
                    Particles(
                      context: context,                      
                    ).showConfetti();

                    Navigate(
                      context: context,
                      fromPage: widget,
                      toPage: ScoreMenuPage(),
                    ).animate();
                    println("puntitos presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.emoji_events,
                      size: 50.0,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Particles(
                      context: context,
                    ).showConfetti();

                    Navigate(
                      context: context,
                      fromPage: widget,
                      toPage: ConfigurationPage(),
                    ).animate();
                    println("configuracion presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.settings,
                      size: 50.0,
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
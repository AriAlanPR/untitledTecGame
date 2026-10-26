import 'package:flutter/material.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';
import 'package:untitled_tec_game/widgets/how_to_play_dialog.dart';
import 'package:untitled_tec_game/widgets/particles.dart';
import 'package:untitled_tec_game/widgets/ship_selector_widget.dart';

//TODO - consider a welcome back from saved settings
class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> with ValidateMixin {
  late double width;
  late double height;
  final double defaultButtonOpacity = 0.9;
  ShipConfig _selectedShip = ShipConfig.alphaScout;

  @override
  void initState() {
    super.initState();
  }

  void onStart() {
    println("starting game...");
    Particles(
      context: context,
      number: 30,
    ).showStar();

    Navigator.pushNamed(
      context,
      '/game',
      arguments: {'ship': _selectedShip},
    );
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
          const SizedBox(),
          Row(
            //NOTE - banner de titulo
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/images/banner.png'),
                width: width * 0.67,
                height: height * 0.1,
                fit: BoxFit.fill,
              ),
            ],
          ),
          ShipSelectorWidget(
            onShipChanged: (ship) {
              setState(() {
                _selectedShip = ship;
              });
            },
          ),
          ElevatedButton(
            //NOTE - jugar
            key: const Key('start_menu_play_btn'),
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E676).withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.black87, size: 36),
                  const SizedBox(width: 8),
                  Text(
                    "JUGAR",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton( //NOTE - puntajes
                  key: const Key('start_menu_scores_btn'),
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
                      size: height * 0.06,
                    ),
                  ),
                ),
                ElevatedButton( //NOTE - cómo jugar
                  key: const Key('start_menu_how_to_play_btn'),
                  onPressed: () {
                    println("como jugar presionado");
                    HowToPlayDialog.show(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightButtonBackground,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.help_outline,
                      size: height * 0.06,
                    ),
                  ),
                ),
                ElevatedButton( //NOTE - configuracion
                  key: const Key('start_menu_config_btn'),
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
                      size: height * 0.06,
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
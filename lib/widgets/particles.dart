import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class Particles {
  ///number of particles to show
  final int number;
  ///arc in degrees the confetti can spread from center
  final double arc;
  ///vertical percentage coordinate from top, defaults at center of the screen
  final double vertically;
  ///horizontal percentage coordinate from left, defaults at center of the screen
  final double horizontally;

  const Particles({
    this.number = 50,
    this.arc = 45,
    this.vertically = 50,
    this.horizontally = 50,
  });

  void showConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: number, 
        spread: arc, 
        y: Particles.positionFromPercent(vertically),
        x: Particles.positionFromPercent(horizontally),
      ),
    );
  }

  void showStar(BuildContext context) {
    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: number,
        spread: arc,
        y: Particles.positionFromPercent(vertically),
        x: Particles.positionFromPercent(horizontally),
      ),
      particleBuilder: (index) => Star(),
    );
  }

  static double positionFromPercent(double percent) {
    return percent / 100;
  }
}
import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';

class Navigate {
  final int milliseconds;
  final Widget toPage;
  final Widget fromPage;

  const Navigate({
    required this.toPage, 
    required this.fromPage,
    this.milliseconds = 900,
  });

  void animate(BuildContext context) {
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: toPage,
        exitPage: fromPage,
        duration: Duration(milliseconds: milliseconds),
        backgroundColor: AppColors.navy,
      ),
    );
  }

  CubePageRoute get route => CubePageRoute(
    enterPage: toPage,
    exitPage: fromPage,
    duration: Duration(milliseconds: milliseconds),
    backgroundColor: AppColors.navy,
  );
}
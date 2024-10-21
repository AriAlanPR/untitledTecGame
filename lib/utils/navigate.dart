import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';

class Navigate {
  final int milliseconds;
  final BuildContext context;
  final Widget toPage;
  final Widget fromPage;

  const Navigate({
    required this.context, 
    required this.toPage, 
    required this.fromPage,
    this.milliseconds = 900,
  });

  void animate() {
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: toPage,
        exitPage: fromPage,
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
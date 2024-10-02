import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Character extends CircleComponent {
  Character({
    required super.position,
    required double radius,
    Color color = Colors.black,
  }) : super(
          anchor: Anchor.center,
          radius: radius,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
}

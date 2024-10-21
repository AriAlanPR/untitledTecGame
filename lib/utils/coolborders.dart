import 'package:flutter/material.dart';
enum BorderDesign {
  left,
  right,
  top,
  bottom,
  all,
  none,
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

class CoolBorders {
  final double radius;
  final BorderDesign borderDesign;

  ///defaults to radius = 4.0 and borderDesign = BorderDesign.all
  CoolBorders({
    this.radius = 4.0,
    this.borderDesign = BorderDesign.all,
  });

  ///requires to give the radius and border design
  CoolBorders.having({
    required this.radius,
    required this.borderDesign,
  });

  BorderRadius get getRadius {
    final circleRadius = Radius.circular(radius);

    switch(borderDesign) {
      case BorderDesign.left:
        return BorderRadius.horizontal(
          left: circleRadius,
        );
      case BorderDesign.right:
        return BorderRadius.horizontal(
          right: circleRadius,
        );
      case BorderDesign.top:
        return BorderRadius.vertical(
          top: circleRadius,
        );
      case BorderDesign.bottom:
        return BorderRadius.vertical(
          bottom: circleRadius,
        );
      case BorderDesign.all:
        return BorderRadius.all(circleRadius,);
      case BorderDesign.topRight:
        return BorderRadius.only(
          topRight: circleRadius,
        );
      case BorderDesign.topLeft:
        return BorderRadius.only(
          topLeft: circleRadius,
        );
      case BorderDesign.bottomRight:
        return BorderRadius.only(
          bottomRight: circleRadius,
        );
      case BorderDesign.bottomLeft:
        return BorderRadius.only(
          bottomLeft: circleRadius,
        );
      case BorderDesign.none:
        return BorderRadius.zero;
    }
  }
}
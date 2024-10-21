import 'package:flutter/material.dart';

class Easytext extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool bold;

  const Easytext({
    super.key, 
    required this.text, 
    this.color = Colors.white, 
    this.size = 25, 
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration: TextDecoration.none,
      ),
    );
  }
}
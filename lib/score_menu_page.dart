import 'package:flutter/material.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';

class ScoreMenuPage extends StatelessWidget with ValidateMixin {
  final List<int> scores;
  ScoreMenuPage({
    super.key,
    this.scores = const [0,0,0,0,0,0,0,0,0,0],
  });

  Widget _text(String text, {
    Color color = Colors.white,
    double size = 32,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        decoration: TextDecoration.none,
      ),
    );
  }

  //TODO - keep latest 10 scores
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        height: calculatedHeight(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade800,
              Colors.grey.shade600.withOpacity(0.7),
              Colors.blueGrey.shade800.withOpacity(0.7),
              Colors.blueGrey.shade600.withOpacity(0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              _text("High Scores"),
              SizedBox(height: 20),
              ...scores.map((score) => _text(score.toString())),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
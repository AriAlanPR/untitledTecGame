import 'package:flutter/material.dart';
import 'package:untitled_tec_game/utils/coolborders.dart';

class ScoreMenuPage extends StatelessWidget {
  final List<int> scores;
  const ScoreMenuPage({
    super.key,
    this.scores = const [0,0,0,0,0,0,0,0,0,0],
  });

  //TODO - keep latest 10 scores
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: CoolBorders(
          borderDesign: BorderDesign.all,
          radius: 40,
        ).getRadius,
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade800.withOpacity(1),
            Colors.grey.shade700,
            Colors.blueGrey.shade800,
            Colors.blueGrey.shade700.withOpacity(1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text("High Scores"),
            SizedBox(height: 80),
            ...scores.map((score) => Text(score.toString())),
          ],
        ),
      ),
    );
  }
}
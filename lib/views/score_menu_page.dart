import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
import 'package:untitled_tec_game/utils/app_colors.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class ScoreMenuPage extends StatelessWidget with ValidateMixin {
  final List<int>? scores;

  ScoreMenuPage({
    super.key,
    this.scores,
  });

  @override
  Widget build(BuildContext context) {
    if (scores != null) {
      return _buildContent(context, scores!);
    }

    return FutureBuilder<List<int>>(
      future: PersistentData.getHighScores(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        return _buildContent(context, data);
      },
    );
  }

  Widget _buildContent(BuildContext context, List<int> displayScores) {
    return Scaffold(
      appBar: AppBar(
        title: Easytext(text: "puntajes".i18n(), size: 40),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.navy,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            height: calculatedHeight(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade600.withValues(alpha: 0.7),
                  Colors.blueGrey.shade800.withValues(alpha: 0.7),
                  Colors.blueGrey.shade600.withValues(alpha: 0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                ...displayScores.map(
                  (score) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Easytext(
                      text: score.toString(),
                      size: 26,
                      bold: true,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
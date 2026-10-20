import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class GameOverOverlay extends StatelessWidget {
  final TecGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        key: const Key('game_over_overlay'),
        child: Container(
          width: 380,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Easytext(
                key: const Key('game_over_title'),
                text: "fin_del_juego".i18n(),
                size: 32,
                bold: true,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (context, score, _) {
                  return Easytext(
                    key: const Key('game_over_score'),
                    text: '${"puntaje_final".i18n()}: $score',
                    size: 24,
                    bold: true,
                    color: theme.colorScheme.onSurface,
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key('game_over_restart_btn'),
                  onPressed: () {
                    game.resetGame();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text("reiniciar".i18n()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('game_over_scores_btn'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/scores');
                  },
                  icon: const Icon(Icons.leaderboard),
                  label: Text("puntajes".i18n()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

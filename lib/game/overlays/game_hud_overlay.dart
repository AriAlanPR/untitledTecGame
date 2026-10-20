import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class GameHudOverlay extends StatelessWidget {
  final TecGame game;

  const GameHudOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      key: const Key('game_hud'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lives
            ValueListenableBuilder<int>(
              valueListenable: game.livesNotifier,
              builder: (context, lives, _) {
                return Row(
                  key: const Key('hud_lives'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: theme.colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Easytext(
                      text: '$lives',
                      size: 24,
                      bold: true,
                    ),
                  ],
                );
              },
            ),
            // Score
            ValueListenableBuilder<int>(
              valueListenable: game.scoreNotifier,
              builder: (context, score, _) {
                return Row(
                  key: const Key('hud_score'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Easytext(
                      text: '${"puntaje".i18n()}: $score',
                      size: 24,
                      bold: true,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
            // Active Power-Up
            ValueListenableBuilder<String?>(
              valueListenable: game.activePowerUpNotifier,
              builder: (context, activePowerUp, _) {
                if (activePowerUp == null) return const SizedBox.shrink();

                final isShield = activePowerUp == 'shield';
                final color = isShield ? const Color(0xFF00E5FF) : const Color(0xFFFFD600);
                final icon = isShield ? Icons.shield : Icons.flash_on;
                final label = isShield ? 'SHIELD' : 'TRIPLE';

                return Container(
                  key: const Key('hud_powerup_badge'),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
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

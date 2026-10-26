import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Easytext(
              text: "puntajes".i18n(),
              size: 24,
              bold: true,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: displayScores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final rank = index + 1;
                  final score = displayScores[index];
                  return _buildScoreCard(context, rank, score);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('score_menu_main_menu_btn'),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      icon: const Icon(Icons.home),
                      label: Text(
                        "menu_principal".i18n(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      key: const Key('score_menu_play_again_btn'),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/game');
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        "reiniciar".i18n(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, int rank, int score) {
    final theme = Theme.of(context);
    final isTop3 = rank <= 3;

    Color badgeColor;
    IconData? rankIcon;

    if (rank == 1) {
      badgeColor = Colors.amber;
      rankIcon = Icons.military_tech;
    } else if (rank == 2) {
      badgeColor = Colors.blueGrey.shade200;
      rankIcon = Icons.military_tech;
    } else if (rank == 3) {
      badgeColor = Colors.brown.shade300;
      rankIcon = Icons.military_tech;
    } else {
      badgeColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTop3
            ? badgeColor.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isTop3
              ? badgeColor.withValues(alpha: 0.6)
              : theme.colorScheme.outline.withValues(alpha: 0.15),
          width: isTop3 ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            key: Key('score_rank_badge_$rank'),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rankIcon != null
                  ? Icon(rankIcon, color: badgeColor, size: 20)
                  : Text(
                      '#$rank',
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            rank == 1
                ? '1ST PLACE'
                : rank == 2
                    ? '2ND PLACE'
                    : rank == 3
                        ? '3RD PLACE'
                        : 'RANK #$rank',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: isTop3 ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            score.toString(),
            style: TextStyle(
              color: isTop3 ? badgeColor : theme.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/game/tec_game.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class GameHudOverlay extends StatefulWidget {
  final TecGame game;

  const GameHudOverlay({
    super.key,
    required this.game,
  });

  @override
  State<GameHudOverlay> createState() => _GameHudOverlayState();
}

class _GameHudOverlayState extends State<GameHudOverlay> {
  bool _showGuidancePrompt = true;
  Timer? _promptTimer;

  @override
  void initState() {
    super.initState();
    _promptTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showGuidancePrompt = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _promptTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      key: const Key('game_hud'),
      child: SizedBox.expand(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lives
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.livesNotifier,
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
                  valueListenable: widget.game.activePowerUpNotifier,
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
                  valueListenable: widget.game.scoreNotifier,
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
        ),
        // Boss Warning Banner
        ValueListenableBuilder<bool>(
          valueListenable: widget.game.bossWarningNotifier,
          builder: (context, isWarning, _) {
            if (!isWarning) return const SizedBox.shrink();

            return Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  key: const Key('hud_boss_warning_banner'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "alerta_jefe".i18n(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Boss Health Bar
        ValueListenableBuilder<double?>(
          valueListenable: widget.game.bossHpNotifier,
          builder: (context, hp, _) {
            if (hp == null) return const SizedBox.shrink();

            return Positioned(
              top: 70,
              left: 30,
              right: 30,
              child: Center(
                child: Container(
                  key: const Key('hud_boss_health_bar'),
                  width: 340,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "metal_shark".i18n(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${(hp * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: hp.clamp(0.0, 1.0),
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Guidance prompt for new players
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              key: const Key('hud_guidance_prompt'),
              opacity: _showGuidancePrompt ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "instrucciones_prompt".i18n(),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

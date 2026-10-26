import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/models/ship_config.dart';
import 'package:untitled_tec_game/utils/persistent_data.dart';
import 'package:untitled_tec_game/widgets/easytext.dart';

class ShipSelectorWidget extends StatefulWidget {
  final ValueChanged<ShipConfig>? onShipChanged;

  const ShipSelectorWidget({
    super.key,
    this.onShipChanged,
  });

  @override
  State<ShipSelectorWidget> createState() => _ShipSelectorWidgetState();
}

class _ShipSelectorWidgetState extends State<ShipSelectorWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    PersistentData.getSelectedShip().then((savedId) {
      final index = ShipConfig.all.indexWhere((s) => s.id == savedId);
      if (index != -1 && mounted) {
        setState(() {
          _currentIndex = index;
        });
        widget.onShipChanged?.call(ShipConfig.all[index]);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _selectPrevious() {
    _scaleController.forward().then((_) => _scaleController.reverse());
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + ShipConfig.all.length) % ShipConfig.all.length;
    });
    final ship = ShipConfig.all[_currentIndex];
    PersistentData.saveSelectedShip(ship.id);
    widget.onShipChanged?.call(ship);
  }

  void _selectNext() {
    _scaleController.forward().then((_) => _scaleController.reverse());
    setState(() {
      _currentIndex = (_currentIndex + 1) % ShipConfig.all.length;
    });
    final ship = ShipConfig.all[_currentIndex];
    PersistentData.saveSelectedShip(ship.id);
    widget.onShipChanged?.call(ship);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ship = ShipConfig.all[_currentIndex];

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        key: const Key('ship_selector_widget'),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 32.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              key: const Key('ship_prev_btn'),
              icon: const Icon(Icons.arrow_left, size: 36),
              color: theme.colorScheme.primary,
              onPressed: _selectPrevious,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Easytext(
                  key: const Key('ship_name_text'),
                  text: ship.nameKey.i18n(),
                  size: 20,
                  bold: true,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 4),
                Text(
                  '${"cadencia".i18n()}: ${ship.shotCooldown}s  •  ${"velocidad".i18n()}: x${ship.speedMultiplier}',
                  key: const Key('ship_stats_text'),
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            IconButton(
              key: const Key('ship_next_btn'),
              icon: const Icon(Icons.arrow_right, size: 36),
              color: theme.colorScheme.primary,
              onPressed: _selectNext,
            ),
          ],
        ),
      ),
    );
  }
}

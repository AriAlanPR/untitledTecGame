import 'package:flutter/material.dart';
import 'package:untitled_tec_game/extensions/color_extension.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';

class GradientButton extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final bool isTrailingIcon;
  final String text;
  final Color? color;
  final Color backgroundColor;
  final List<Color> backgroundColors;
  final IconData? icon;
  final VoidCallback onPressed;

  GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.backgroundColor = Colors.blue,
    this.isTrailingIcon = false,
  }) : backgroundColors = backgroundColor.baseGradientPallet;
  
  get _hasPadding => !(top.isNull && bottom.isNull && left.isNull && right.isNull);

  Widget _gradientButton() {
    const radius = 24.0;
    const iconSeparation = 8.0;

    return Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: backgroundColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && !isTrailingIcon) ...[
                  Icon(icon, color: color ?? backgroundColor.readColor),
                  const SizedBox(width: iconSeparation),
                ],
                Text(
                  text,
                  style: TextStyle(color: color ?? backgroundColor.readColor),
                ),
                if (icon != null && isTrailingIcon) ...[
                  const SizedBox(width: iconSeparation),
                  Icon(icon, color: color ?? backgroundColor.readColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasPadding ? Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: _gradientButton()
    ) : _gradientButton();
  }
}
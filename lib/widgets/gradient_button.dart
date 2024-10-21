import 'package:flutter/material.dart';
import 'package:untitled_tec_game/extensions/color_extension.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';

class GradientButton extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double iconSize;
  final bool isTrailingIcon;
  final String? text;
  final Color? color;
  final Color? backgroundColor;
  final List<Color> gradientColors;
  final IconData? icon;
  final VoidCallback onPressed;

  GradientButton({
    super.key,
    required this.onPressed,
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.iconSize = 24.0,
    this.isTrailingIcon = false,
    this.color,
    this.icon,
    this.text,
    Color? gradientColor,
    List<Color>? backgroundColors,
  }) : gradientColors = backgroundColors ?? (gradientColor ?? Colors.blue).darkGradientPallet,
    backgroundColor = gradientColor ?? Colors.blue,
    assert(( text == null && icon != null)
              || ( text != null && icon == null)
              || ( text != null && icon != null));
  
  get _hasPadding => !(top.isNull && bottom.isNull && left.isNull && right.isNull);

  Widget _gradientButton() {
    const radius = 24.0;
    const iconSeparation = 8.0;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && !isTrailingIcon) ...[
                Icon(
                  icon,
                  color: color ?? backgroundColor!.readColor,
                  size: iconSize,
                ),
                const SizedBox(width: iconSeparation),
              ],
              if(text.exists) Text(
                text!,
                style: TextStyle(color: color ?? backgroundColor!.readColor),
              ),
              if (icon != null && isTrailingIcon) ...[
                const SizedBox(width: iconSeparation),
                Icon(
                  icon, 
                  color: color ?? backgroundColor!.readColor,
                  size: iconSize,
                ),
              ],
            ],
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
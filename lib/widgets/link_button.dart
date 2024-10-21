import 'package:flutter/material.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double top;
  final double bottom;
  final double left;
  final double right;

  const LinkButton({
    super.key, 
    required this.text, 
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.onPressed});

  get _hasPadding => !(top.isNull && bottom.isNull && left.isNull && right.isNull);

  TextButton _linkButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove default padding
        minimumSize: Size.zero, // Remove default minimum size
      ),
      child: Text(
        text,
        style: const TextStyle(
          decoration: TextDecoration.underline, // Underline the text
          decorationColor: Colors.blue, // Underline color
          color: Colors.blue, // Text color
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
      child: _linkButton(),
    ) : _linkButton();
  }
}
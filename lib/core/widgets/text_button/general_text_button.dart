import 'package:flutter/material.dart';

import '../../resources/pallete/dark_theme_palette.dart';

class GeneralTextButton extends StatelessWidget {
  final Function() onPressed;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? buttonColor;
  final String text;
  final double? textSize;
  final Color? textColor;

  const GeneralTextButton({
    super.key,
    required this.onPressed,
    this.buttonHeight, // Now optional
    this.buttonWidth, // Now optional
    this.buttonColor,
    required this.text,
    this.textSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: buttonWidth ?? double.infinity,
        minHeight: buttonHeight ?? double.infinity,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? DarkThemePalette.primaryAccent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? DarkThemePalette.textPrimary,
            fontSize: textSize ?? 16.0,
          ),
        ),
      ),
    );
  }
}

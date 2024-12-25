import 'package:flutter/material.dart';

class PillBox extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;

  const PillBox({
    super.key,
    required this.text,
    this.width = 50.0,
    this.height = 20.0,
    this.backgroundColor = const Color.fromARGB(245, 247, 142, 134),
    this.textColor = const Color.fromARGB(255, 230, 65, 65),
    this.borderRadius = 10.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

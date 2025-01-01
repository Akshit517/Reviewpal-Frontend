import 'package:flutter/material.dart';

class InkWellButton extends StatelessWidget {
  final Widget? child;
  final double height;
  final double width;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color splashColor;
  final BoxDecoration? customDecoration;
  final ShapeBorder? shapeBorder;
  final Color borderColor;
  final List<BoxShadow>? customShadow;

  const InkWellButton({
    super.key,
    this.child,
    this.height = 48.0,
    this.width = 48.0,
    this.borderRadius = 8.0,
    this.onTap,
    this.backgroundColor = Colors.transparent,
    this.splashColor = Colors.white10,
    this.customDecoration,
    this.customShadow,
    this.borderColor = Colors.transparent,
    this.shapeBorder,
  });

  /// Factory for circular buttons
  factory InkWellButton.circular({
    Key? key,
    Widget? child,
    double size = 48.0,
    Color borderColor = Colors.transparent,
    VoidCallback? onTap,
    Color backgroundColor = Colors.transparent,
    Color splashColor = Colors.white10,
    BoxDecoration? customDecoration,
    List<BoxShadow>? customShadow,
  }) {
    return InkWellButton(
      key: key,
      height: size,
      width: size,
      borderRadius: size / 2,
      borderColor: borderColor,
      onTap: onTap,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      customDecoration: (customDecoration ?? const BoxDecoration()).copyWith(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      shapeBorder: const CircleBorder(),
      customShadow: customShadow,
      child: child,
    );
  }

  /// Factory for rectangular buttons
  factory InkWellButton.rectangular({
    Key? key,
    Widget? child,
    double height = 48.0,
    double width = 48.0,
    double borderRadius = 8.0,
    Color borderColor = Colors.transparent,
    VoidCallback? onTap,
    Color backgroundColor = Colors.transparent,
    Color splashColor = Colors.white10,
    BoxDecoration? customDecoration,
    List<BoxShadow>? customShadow,
  }) {
    return InkWellButton(
      key: key,
      height: height,
      width: width,
      borderRadius: borderRadius,
      borderColor: borderColor,
      onTap: onTap,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      customDecoration: (customDecoration ?? const BoxDecoration()).copyWith(
        color: backgroundColor,
        shape: BoxShape.rectangle,
      ),
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      customShadow: customShadow,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = customDecoration ??
        BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: customShadow,
          border: Border.all(color: borderColor),
        );

    return Material(
      color: Colors.transparent,
      child: Ink(
        height: height,
        width: width,
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          customBorder: shapeBorder ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          splashColor: splashColor,
          child: Center(child: child),
        ),
      ),
    );
  }
}

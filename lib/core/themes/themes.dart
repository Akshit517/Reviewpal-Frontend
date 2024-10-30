import 'package:flutter/material.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1E1E1E),
  secondary: Color(0xFFC0C0C0),
  surface: Color(0xFF2A2A2A),
  error: Colors.redAccent,
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF2D2D2D),
  onSurface: Color(0xFF6C54C4),
  onError: Color(0xFFFFFFFF),
);
  
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
);

import 'package:flutter/material.dart';

import '../pallete/dark_theme_palette.dart';

///while defining theme for dark mode also define them in [themes.dart]
class DarkTheme {
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DarkThemePalette.primaryAccent,
    onPrimary: DarkThemePalette.textPrimary,
    secondary: DarkThemePalette.secondaryGray,
    onSecondary: DarkThemePalette.secondaryDarkGray,
    surface: DarkThemePalette.backgroundSurface,
    onSurface: DarkThemePalette.textPrimary,
    error: Color(0xFFCF6679),
    onError: Colors.black,
  );
  static TextButtonThemeData darkGeneralTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: DarkThemePalette.textPrimary,
      backgroundColor: DarkThemePalette.primaryAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  static Color darkScaffoldBackgroundColor = DarkThemePalette.backgroundSurface;
  static const InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: DarkThemePalette.fillColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: DarkThemePalette.textHint),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: DarkThemePalette.textPrimary),
    ),
  );
  static const TextTheme darkTextTheme = TextTheme(
    bodySmall: TextStyle(color: DarkThemePalette.textHint, fontSize: 14),
    bodyMedium: TextStyle(color: DarkThemePalette.textPrimary, fontSize: 16),
    bodyLarge: TextStyle(color: DarkThemePalette.textPrimary, fontSize: 18),
    titleLarge: TextStyle(
        color: DarkThemePalette.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600),
  );
  static const SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
    backgroundColor: DarkThemePalette.secondaryDarkGray,
    showCloseIcon: true,
    contentTextStyle: TextStyle(color: Colors.grey),
    closeIconColor: Colors.grey
  );
}

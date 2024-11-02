import 'package:flutter/material.dart';

import 'dark_theme.dart';


enum AppTheme {
  lightTheme,
  darkTheme,
}

final appThemeData = {
  AppTheme.lightTheme: ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(),
  ),
  AppTheme.darkTheme: ThemeData(
    brightness: Brightness.dark,
    colorScheme: DarkTheme.darkColorScheme,
    textButtonTheme: DarkTheme.darkGeneralTextButtonTheme,
    scaffoldBackgroundColor: DarkTheme.darkScaffoldBackgroundColor,
    inputDecorationTheme: DarkTheme.darkInputDecorationTheme,
    textTheme: DarkTheme.darkTextTheme
  )
};

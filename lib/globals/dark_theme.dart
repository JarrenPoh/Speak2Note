import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 54, 54, 54),
  ),
  primaryColor: Color.fromARGB(255, 86, 86, 86),
  hintColor: Colors.blueAccent,
  scaffoldBackgroundColor: Color.fromARGB(255, 54, 54, 54),
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: ColorScheme.light(
    // background: Colors.black,
    onPrimary: Color.fromARGB(255, 19, 19, 19),
    onSecondary: Colors.white,
    primary: Colors.white54,
    secondary: Colors.white38,
    tertiary: Colors.white12,
    primaryContainer: Colors.black38,
  ),
);

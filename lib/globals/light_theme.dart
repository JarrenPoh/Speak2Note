import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black54,
  ),
  primaryColor: Color.fromARGB(255, 86, 86, 86),
  hintColor: Colors.blueAccent,
  scaffoldBackgroundColor: Colors.white,
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: ColorScheme.light(
    // background: Color.fromRGBO(237, 237, 237, 1),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    primary: Colors.black54,
    secondary: Colors.black38,
    tertiary: Colors.black12,
    primaryContainer: Colors.white60,
  ),
);

import 'package:flutter/material.dart';

ThemeData homeTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.black
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: Colors.white
  ),
  iconTheme: const IconThemeData(
    color: Colors.white
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodyMedium: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
    bodySmall: TextStyle(color: Colors.white.withOpacity(0.5)),
  )
);

ThemeData commentPageTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.black
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: Colors.white
  ),
  iconTheme: const IconThemeData(
    color: Colors.white
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodyMedium: const TextStyle(color: Colors.white, fontSize: 12),
    bodySmall: TextStyle(color: Colors.white.withOpacity(0.5)),
  )
);

ThemeData loginTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
    floatingLabelStyle: TextStyle(color: Colors.blue),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 30, 37, 55),
);
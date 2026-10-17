
import 'package:flutter/material.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFFECEFCA),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF547792),
        primary: const Color(0xFF547792),
        secondary: const Color(0xFF213448),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFF121820),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF547792),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Sans-Serif',
      scaffoldBackgroundColor: const Color(0xFFECEFCA),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF547792),
        primary: const Color(0xFF547792),
        secondary: const Color(0xFF213448),
      ),
      useMaterial3: true,
    );
  }
}
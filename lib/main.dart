import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'view/login_page.dart';

void main() {
  runApp(const SigmaUnesaApp());
}

class SigmaUnesaApp extends StatelessWidget {
  const SigmaUnesaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGMA UNESA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'view/auth_shell.dart';
import 'view/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class SigmaUnesaApp extends MyApp {
  const SigmaUnesaApp({super.key});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'SIGMA UNESA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const LoginPage(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const AuthShell(),
          },
        );
      },
    );
  }
}

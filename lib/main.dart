import 'package:flutter/material.dart';
import 'view/login_page.dart';
import 'view/auth_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Alias dipertahankan untuk pengujian/widget lama.
class SigmaUnesaApp extends MyApp {
  const SigmaUnesaApp({super.key});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGMA UNESA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      // PERTAMA RUN KUDU LOGIN SELEK
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const AuthShell(),
      },
    );
  }
}
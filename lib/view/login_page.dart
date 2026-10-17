
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import 'auth_shell.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  static const Color _primaryColor = Color(0xFF213448);
  static const Color _backgroundColor = Color(0xFFF1F5F9);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan kata sandi wajib diisi.');
      return;
    }

    // Login hanya menerima email mahasiswa UNESA.
    final emailPattern =
        RegExp(r'^[A-Z0-9._%+-]+@mhs\.unesa\.ac\.id$', caseSensitive: false);

    if (!emailPattern.hasMatch(email)) {
      _showMessage(
        'Gunakan email mahasiswa dengan domain @mhs.unesa.ac.id.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage('Kata sandi minimal 6 karakter.');
      return;
    }

    setState(() => _isLoading = true);

    // Memberi waktu agar indikator loading terlihat.
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    // Memeriksa akun yang sudah terdaftar pada AuthController.
    final success = AuthController.instance.login(email, password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      _showMessage(
        'Login gagal. Periksa email dan kata sandi, '
        'atau daftar terlebih dahulu.',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil masuk ke SIGMA UNESA.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthShell()),
      (route) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : _backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 700;

                  final logoSection = Container(
                    height: isMobile ? 220 : 520,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: isMobile
                          ? const BorderRadius.vertical(
                              top: Radius.circular(24),
                            )
                          : const BorderRadius.horizontal(
                              left: Radius.circular(24),
                            ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/logo.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/logo.jpeg',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.school_rounded,
                                    size: 100,
                                    color: theme.colorScheme.primary,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );

                  final formSection = Padding(
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Silakan masuk dengan akun mahasiswa UNESA Anda.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: 'Email Mahasiswa UNESA',
                            hintText: 'nama@mhs.unesa.ac.id',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (!_isLoading) _signIn();
                          },
                          decoration: InputDecoration(
                            labelText: 'Kata Sandi',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _isPasswordObscured
                                  ? 'Tampilkan kata sandi'
                                  : 'Sembunyikan kata sandi',
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured =
                                      !_isPasswordObscured;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Masuk Sekarang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Belum punya akun? ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Daftar di sini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                  if (isMobile) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        logoSection,
                        formSection,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: logoSection),
                      Expanded(flex: 6, child: formSection),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

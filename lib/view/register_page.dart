
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nimController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNim(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM wajib diisi.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim().toLowerCase();

    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }

    final pattern = RegExp(
      r'^[A-Z0-9._%+-]+@mhs\.unesa\.ac\.id$',
      caseSensitive: false,
    );

    if (!pattern.hasMatch(email)) {
      return 'Gunakan email @mhs.unesa.ac.id.';
    }

    return null;
  }

  Future<void> _register() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final nim = _nimController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    final success = AuthController.instance.register(
      nim,
      name,
      email,
      password,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registrasi gagal. Email mungkin sudah terdaftar '
            'atau data yang dimasukkan tidak valid.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pendaftaran berhasil! Silakan login menggunakan akunmu.',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Daftar SIGMA UNESA',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buat akun terlebih dahulu untuk mengelola '
                      'tugas kuliahmu.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // NIM
                    TextFormField(
                      controller: _nimController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        hintText: 'Masukkan NIM mahasiswa',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateNim,
                    ),
                    const SizedBox(height: 16),

                    // Nama lengkap
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama lengkap wajib diisi.';
                        }

                        if (value.trim().length < 2) {
                          return 'Nama terlalu pendek.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email mahasiswa
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email Mahasiswa UNESA',
                        hintText: 'nama@mhs.unesa.ac.id',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Kata sandi
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata sandi wajib diisi.';
                        }

                        if (value.length < 6) {
                          return 'Kata sandi minimal 6 karakter.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi kata sandi
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _hideConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_isLoading) {
                          _register();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Kata Sandi',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          tooltip: _hideConfirmPassword
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _hideConfirmPassword =
                                  !_hideConfirmPassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi kata sandi wajib diisi.';
                        }

                        if (value != _passwordController.text) {
                          return 'Kata sandi tidak sama.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Tombol daftar
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Daftar Sekarang',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text(
                        'Sudah punya akun? Kembali ke Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

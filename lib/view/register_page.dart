import 'package:flutter/material.dart';
import 'login_page.dart';
import '../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Registrasi Dummy (Tanpa Supabase)
  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final nim = _nimController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || nim.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom pendaftaran.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 250));
    final success = AuthController.instance.register(nim, name, email, password);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pendaftaran gagal. Periksa kembali data dan kata sandi minimal 6 karakter.')));
      return;
    }
    AuthController.instance.logout();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil! Silakan masuk.'), backgroundColor: Colors.green));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFCA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 750;

                // Panel Kiri (Biru Gelap Header / Branding ASLI KAMU)
                Widget headerWidget = Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF213448),
                    borderRadius: isMobile
                        ? const BorderRadius.vertical(top: Radius.circular(24))
                        : const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                  ),
                  padding: EdgeInsets.all(isMobile ? 32 : 48),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person_add_alt_1, size: 60, color: Color(0xFFECEFCA)),
                      SizedBox(height: 16),
                      Text(
                        'SIGMA UNESA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFECEFCA),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sistem Informasi Tugas & Manajemen Akademik\nUniversitas Negeri Surabaya',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );

                // Panel Kanan (Form Input Pendaftaran ASLI KAMU)
                Widget formWidget = Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 48,
                    vertical: isMobile ? 32 : 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF213448),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lengkapi data mahasiswa Anda untuk mendaftar.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF547792)),
                      ),
                      const SizedBox(height: 24),

                      // Input Nama Lengkap
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nama Lengkap',
                          prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF547792)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Input NIM
                      TextField(
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'NIM Mahasiswa',
                          prefixIcon: const Icon(Icons.numbers_outlined, color: Color(0xFF547792)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Input Email (AUTO-COMPLETE @mhs.unesa.ac.id)
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          const domain = '@mhs.unesa.ac.id';
                          if (value.contains('@') && !value.endsWith(domain)) {
                            final username = value.split('@').first;
                            final newText = '$username$domain';
                            _emailController.value = TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(offset: username.length),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Email UNESA / NIM lalu ketik @',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF547792)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Input Kata Sandi
                      TextField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Kata Sandi',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF547792)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Daftar Akun
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF547792),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          onPressed: _isLoading ? null : _signUp,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Link Kembali ke Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Masuk di sini',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF547792),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                return isMobile
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          headerWidget,
                          formWidget,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(flex: 5, child: headerWidget),
                          Expanded(flex: 6, child: formWidget),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
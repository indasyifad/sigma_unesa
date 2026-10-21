
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
  final _emailFocusNode = FocusNode();

  bool _isPasswordObscured = true;
  bool _isLoading = false;
  bool _showDomainSuggestion = false;

  static const String _emailDomain = '@mhs.unesa.ac.id';
  static const Color _primaryColor = Color(0xFF213448);
  static const Color _backgroundColor = Color(0xFFF1F5F9);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_handleEmailChanged);
    _emailFocusNode.addListener(_handleFocusChanged);
  }

  void _handleEmailChanged() {
    final email = _emailController.text;
    final atIndex = email.lastIndexOf('@');

    final shouldSuggest = atIndex >= 0 &&
        !email.substring(atIndex).contains('.') &&
        !email.substring(atIndex).contains(' ');

    if (_showDomainSuggestion != shouldSuggest) {
      setState(() {
        _showDomainSuggestion = shouldSuggest;
      });
    }
  }

  void _handleFocusChanged() {
    if (!_emailFocusNode.hasFocus && _showDomainSuggestion) {
      setState(() {
        _showDomainSuggestion = false;
      });
    }
  }

  void _completeEmailDomain() {
    final email = _emailController.text.trim();
    final atIndex = email.lastIndexOf('@');

    if (atIndex < 0) return;

    final username = email.substring(0, atIndex).trim();

    if (username.isEmpty) {
      _showMessage('Masukkan bagian nama email terlebih dahulu.');
      return;
    }

    final completedEmail = '$username$_emailDomain';

    _emailController.value = TextEditingValue(
      text: completedEmail,
      selection: TextSelection.collapsed(
        offset: completedEmail.length,
      ),
    );

    setState(() {
      _showDomainSuggestion = false;
    });

    _emailFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _emailController.removeListener(_handleEmailChanged);
    _emailFocusNode.removeListener(_handleFocusChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan kata sandi wajib diisi.');
      return;
    }

    if (!AuthController.instance.isValidUnesaEmail(email)) {
      _showMessage(
        'Gunakan email mahasiswa dengan domain $_emailDomain.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage('Kata sandi minimal 6 karakter.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _showDomainSuggestion = false;
    });

    final success = AuthController.instance.login(email, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      _showMessage(
        'Login gagal. Periksa email dan kata sandi, '
        'atau daftar terlebih dahulu.',
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthShell(),
      ),
      (route) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: 'Email Mahasiswa UNESA',
            hintText: 'nama$_emailDomain',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (_) {
            if (_showDomainSuggestion) {
              _completeEmailDomain();
            } else {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
        if (_showDomainSuggestion)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _completeEmailDomain,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alternate_email,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gunakan domain email mahasiswa',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _emailDomain,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.north_west, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordObscured,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _signIn(),
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
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme, bool isMobile) {
    return Container(
      height: isMobile ? 220 : 520,
      width: double.infinity,
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
            return Icon(
              Icons.school_rounded,
              size: 100,
              color: theme.colorScheme.primary,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(ThemeData theme, bool isMobile) {
    return Padding(
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
          _buildEmailField(theme),
          const SizedBox(height: 16),
          _buildPasswordField(theme),
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
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Belum punya akun?',
                  style: theme.textTheme.bodyMedium,
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
                    'Daftar sekarang',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewportConstraints) {
            final isMobile = viewportConstraints.maxWidth < 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Container(
                    width: double.infinity,
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
                    child: isMobile
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLogo(theme, true),
                              _buildLoginForm(theme, true),
                            ],
                          )
                        : IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _buildLogo(theme, false),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: _buildLoginForm(theme, false),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

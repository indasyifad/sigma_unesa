import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../model/user.dart';

class AuthController extends ChangeNotifier {
  AuthController._();

  // Satu controller autentikasi untuk seluruh aplikasi.
  static final AuthController instance = AuthController._();

  static const String emailDomain = '@mhs.unesa.ac.id';

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // Akun disimpan sementara selama aplikasi berjalan.
  final Map<String, ({User user, String password})> _accounts = {};

  String _normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  // Memastikan email menggunakan domain mahasiswa UNESA.
  bool isValidUnesaEmail(String email) {
    return RegExp(
      r'^[^\s@]+@mhs\.unesa\.ac\.id$',
    ).hasMatch(_normalizeEmail(email));
  }

  // Mendaftarkan akun pengguna baru.
  bool register(
    String nim,
    String name,
    String email,
    String password, {
    String major = '',
  }) {
    final normalizedNim = nim.trim();
    final normalizedName = name.trim();
    final normalizedEmail = _normalizeEmail(email);
    final normalizedMajor = major.trim();

    // Validasi data wajib.
    if (normalizedNim.isEmpty ||
        normalizedName.isEmpty ||
        normalizedMajor.isEmpty ||
        !isValidUnesaEmail(normalizedEmail) ||
        password.length < 6) {
      return false;
    }

    // NIM tidak boleh digunakan oleh akun lain.
    final nimAlreadyRegistered = _accounts.values.any(
      (account) => account.user.nim == normalizedNim,
    );

    if (nimAlreadyRegistered) {
      return false;
    }

    // Email tidak boleh digunakan oleh akun lain.
    if (_accounts.containsKey(normalizedEmail)) {
      return false;
    }

    final user = User(
      nim: normalizedNim,
      name: normalizedName,
      email: normalizedEmail,
      major: normalizedMajor,
      username: normalizedName,
    );

    _accounts[normalizedEmail] = (
      user: user,
      password: password,
    );

    notifyListeners();

    return true;
  }

  // Login menggunakan email dan kata sandi.
  bool login(String email, String password) {
    final normalizedEmail = _normalizeEmail(email);

    if (!isValidUnesaEmail(normalizedEmail) ||
        password.isEmpty) {
      return false;
    }

    final account = _accounts[normalizedEmail];

    if (account == null || account.password != password) {
      return false;
    }

    _currentUser = account.user;

    notifyListeners();

    return true;
  }

  // Mengganti foto profil pengguna yang sedang login.
  void setProfilePhoto(Uint8List? bytes) {
    if (_currentUser == null) return;

    _currentUser!.updatePhoto(bytes);

    notifyListeners();
  }

  // Mengubah nama tampilan.
  void updateUsername(String name) {
    if (_currentUser == null || name.trim().isEmpty) return;

    _currentUser!.updateUsername(name);

    notifyListeners();
  }

  // Mengubah program studi.
  void updateMajor(String major) {
    if (_currentUser == null || major.trim().isEmpty) return;

    _currentUser!.major = major;

    notifyListeners();
  }

  // Mengakhiri sesi login.
  void logout() {
    _currentUser = null;

    notifyListeners();
  }
}
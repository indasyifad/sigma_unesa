
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../model/user.dart';

class AuthController extends ChangeNotifier {
  AuthController._();

  static final AuthController instance = AuthController._();

  static const String emailDomain = '@mhs.unesa.ac.id';

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final Map<String, ({User user, String password})> _accounts = {};

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  bool isValidUnesaEmail(String email) {
    return RegExp(r'^[^\s@]+@mhs\.unesa\.ac\.id$')
        .hasMatch(_normalizeEmail(email));
  }

  bool register(
    String nim,
    String name,
    String email,
    String password,
  ) {
    final normalizedEmail = _normalizeEmail(email);

    if (nim.trim().isEmpty ||
        name.trim().isEmpty ||
        !isValidUnesaEmail(normalizedEmail) ||
        password.length < 6) {
      return false;
    }

    if (_accounts.containsKey(normalizedEmail)) {
      return false;
    }

    final user = User(
      nim: nim.trim(),
      name: name.trim(),
      email: normalizedEmail,
      username: name.trim(),
      major: 'S1 Teknik Informatika',
    );

    _accounts[normalizedEmail] = (
      user: user,
      password: password,
    );

    notifyListeners();
    return true;
  }

  bool login(String email, String password) {
    final normalizedEmail = _normalizeEmail(email);

    if (!isValidUnesaEmail(normalizedEmail) || password.isEmpty) {
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

  void setProfilePhoto(Uint8List? bytes) {
    if (_currentUser == null) return;

    _currentUser!.photoBytes = bytes;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

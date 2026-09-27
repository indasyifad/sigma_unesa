import 'package:flutter/material.dart';
import '../model/user.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // Function Login
  bool login(String email, String password) {
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        nim: '25051204395',
        name: 'Indasyifa Debian Wirajati',
        email: email,
        major: 'S1 Teknik Informatika',
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Function Register
  bool register(String nim, String name, String email, String password) {
    if (nim.isNotEmpty && name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        nim: nim,
        name: name,
        email: email,
        major: 'S1 Teknik Informatika',
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Function Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
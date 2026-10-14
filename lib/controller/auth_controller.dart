import 'package:flutter/foundation.dart';
import '../model/user.dart';

/// Auth demo controller. Akun hanya hidup selama aplikasi berjalan; belum ada
/// penyimpanan lokal/backend karena rancangan penyimpanan belum disetujui.
class AuthController extends ChangeNotifier {
  AuthController._();
  static final AuthController instance = AuthController._();

  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;
  final Map<String, ({User user, String password})> _accounts = {};

  String _key(String value) => value.trim().toLowerCase().split('@').first;

  bool login(String usernameOrEmail, String password) {
    if (usernameOrEmail.trim().isEmpty || password.length < 6) return false;
    final key = _key(usernameOrEmail);
    final account = _accounts[key];
    if (account != null && account.password != password) return false;
    if (account != null) {
      account.user.username = key;
      _currentUser = account.user;
    } else {
      final isNim = RegExp(r'^\d+$').hasMatch(key);
      final email = usernameOrEmail.contains('@') ? usernameOrEmail.trim() : '$key@mhs.unesa.ac.id';
      final username = email.split('@').first;
      _currentUser = User(
        nim: isNim ? key : 'Belum diisi',
        name: isNim ? 'Mahasiswa $key' : username,
        username: username,
        email: email,
        major: 'S1 Teknik Informatika',
      );
    }
    notifyListeners();
    return true;
  }

  bool register(String nim, String name, String email, String password) {
    if (nim.trim().isEmpty || name.trim().isEmpty || email.trim().isEmpty || password.length < 6) return false;
    final user = User(nim: nim.trim(), name: name.trim(), email: email.trim(), username: email.trim().split('@').first, major: 'S1 Teknik Informatika');
    _accounts[_key(email)] = (user: user, password: password);
    _accounts[_key(nim)] = (user: user, password: password);
    _currentUser = user;
    notifyListeners();
    return true;
  }

  void setProfilePhoto(Uint8List? bytes) {
    _currentUser?.photoBytes = bytes;
    notifyListeners();
  }

  void logout() { _currentUser = null; notifyListeners(); }
}

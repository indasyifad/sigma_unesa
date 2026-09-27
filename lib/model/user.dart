class User {
  final String _nim;
  final String _name;
  final String _email;
  final String _major;

  User({
    required String nim,
    required String name,
    required String email,
    required String major,
  })  : _nim = nim,
        _name = name,
        _email = email,
        _major = major;

  // Getter agar bisa dipanggil di file lain (contoh: user.nim)
  String get nim => _nim;
  String get name => _name;
  String get email => _email;
  String get major => _major;
}
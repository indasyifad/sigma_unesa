import 'dart:typed_data';

class User {
  final String _nim;
  final String _name;
  final String _email;

  String _major;
  String username;
  Uint8List? photoBytes;

  User({
    required String nim,
    required String name,
    required String email,
    required String major,
    String? username,
    this.photoBytes,
  })  : _nim = nim,
        _name = name,
        _email = email,
        _major = major,
        username = username ?? name;

  // Getter untuk membaca data pengguna.
  String get nim => _nim;
  String get name => _name;
  String get email => _email;
  String get major => _major;

  // Setter untuk mengubah program studi.
  set major(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Program studi tidak boleh kosong.');
    }

    _major = value.trim();
  }

  // Mengubah nama tampilan pengguna.
  void updateUsername(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Nama pengguna tidak boleh kosong.');
    }

    username = value.trim();
  }

  // Mengubah foto profil.
  void updatePhoto(Uint8List? bytes) {
    photoBytes = bytes;
  }

  // Mengambil informasi profil.
  String getProfileInformation() {
    return 'Nama: $name\n'
        'NIM: $nim\n'
        'Email: $email\n'
        'Program Studi: $major';
  }
}
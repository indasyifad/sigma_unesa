import 'dart:typed_data';

class User {
  final String _nim;
  final String _name;
  final String _email;
  final String _major;
  String username;
  Uint8List? photoBytes;

  User({required String nim, required String name, required String email, required String major, String? username, this.photoBytes})
      : _nim = nim, _name = name, _email = email, _major = major, username = username ?? email.split('@').first;

  String get nim => _nim;
  String get name => _name;
  String get email => _email;
  String get major => _major;
}

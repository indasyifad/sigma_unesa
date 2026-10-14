import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    bool isAndroid = Platform.isAndroid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile $isAndroid'),
      ),
      body: const Center(
        child: Text('Halaman Profil'),
      ),
    );
  }
}
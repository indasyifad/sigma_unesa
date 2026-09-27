import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PROFIL MAHASISWA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profil.jpg'),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Indasyifa Debian Wirajati', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
                      SizedBox(height: 6),
                      Text('NIM: 25051204395', style: TextStyle(fontSize: 14, color: Color(0xFF547792), fontWeight: FontWeight.w600)),
                      Text('Program Studi: S1 Teknik Informatika', style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Text('Fakultas Teknik — Universitas Negeri Surabaya', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF547792)),
                    title: Text('Email UNESA'),
                    subtitle: Text('25051204395@mhs.unesa.ac.id'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.school, color: Color(0xFF547792)),
                    title: Text('Status Akademik'),
                    subtitle: Text('Aktif (Semester 3)'),
                  ),
                  Divider(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseName;
  const CourseDetailPage({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Mata Kuliah: $courseName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Daftar Tugas Aktif:'),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                title: Text('Tugas 1: Interface Design'),
                subtitle: Text('Status: Belum Selesai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
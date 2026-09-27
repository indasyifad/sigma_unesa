import 'package:flutter/material.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String course;
  final String deadline;
  final Color color;
  final String description;
  final String? fileName;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.color,
    this.description = 'Silakan unggah pengerjaan tugas sebelum batas waktu.',
    this.fileName,
  });
}

class AssignmentController extends ChangeNotifier {
  // Data tugas utama (List Awal)
  final List<AssignmentModel> _assignments = [
    AssignmentModel(
      id: '1',
      title: 'Slicing UI Mobile App SIGMA',
      course: 'Pemrograman Berbasis Platform',
      deadline: 'Besok, 23:59',
      color: const Color(0xFFEF4444),
      description: 'Implementasi slicing UI dashboard dan komponen dasar Flutter Web.',
    ),
    AssignmentModel(
      id: '2',
      title: 'Analisis Kompleksitas Algoritma',
      course: 'Sains Komputasi',
      deadline: '28 Sep 2026',
      color: const Color(0xFFF59E0B),
      description: 'Laporan analisis Big O Notation untuk algoritma sorting.',
    ),
    AssignmentModel(
      id: '3',
      title: 'Setup Database PostgreSQL',
      course: 'Basis Data',
      deadline: '30 Sep 2026',
      color: const Color(0xFF3B82F6),
      description: 'Konfigurasi tabel relasional dan ERD untuk sistem akademik.',
    ),
  ];

  String _searchQuery = '';

  // Getter data tugas terfilter berdasarkan kata kunci pencarian
  List<AssignmentModel> get assignments {
    if (_searchQuery.isEmpty) {
      return _assignments;
    }
    return _assignments.where((task) {
      final query = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(query) ||
          task.course.toLowerCase().contains(query);
    }).toList();
  }

  // Fungsi untuk mengubah query pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Mengupdate UI secara otomatis
  }

  // Fungsi untuk menambah tugas baru
  void addAssignment(String title, String course, String deadline, String description, String? fileName) {
    _assignments.insert(
      0,
      AssignmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        course: course,
        deadline: deadline,
        color: const Color(0xFFEF4444), // Warna default merah/deadline
        description: description,
        fileName: fileName,
      ),
    );
    notifyListeners(); // Merender ulang ListView.builder di Home
  }
}
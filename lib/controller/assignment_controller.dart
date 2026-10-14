import 'package:flutter/foundation.dart';
import '../model/assignment.dart';
import '../services/reminder_service.dart';

/// Satu sumber data tugas untuk semua halaman. Data masih berada di memori;
/// penyimpanan persisten sengaja belum ditambahkan.
class AssignmentController extends ChangeNotifier {
  AssignmentController._() {
    _assignments.addAll([
      Assignment(id: 'home_1', title: 'Slicing UI Mobile App SIGMA', courseName: 'Pemrograman Berbasis Platform', deadline: DateTime(2026, 9, 28, 23, 59), description: 'Implementasi slicing UI dashboard dan modul tugas menggunakan Flutter Web.'),
      Assignment(id: 'home_2', title: 'Analisis Kompleksitas Algoritma', courseName: 'Sains Komputasi', deadline: DateTime(2026, 9, 28, 12), description: 'Menghitung Big-O Notasi untuk algoritma pencarian data.'),
      Assignment(id: 'home_3', title: 'Setup Database PostgreSQL', courseName: 'Basis Data', deadline: DateTime(2026, 9, 30, 15, 30), description: 'Membuat ERD dan script DDL/DML untuk sistem akademik.'),
      Assignment(id: 'home_4', title: 'Essai', courseName: 'Basis Data', deadline: DateTime(2026, 9, 28, 23, 59), description: 'Penulisan essai materi basis data.'),
      // Entri dari daftar tugas lama dipertahankan sebagai item terpisah jika detailnya berbeda.
      Assignment(id: 'controller_1', title: 'Slicing UI Mobile App SIGMA', courseName: 'Pemrograman Berbasis Platform', deadline: DateTime(2026, 10, 15, 23, 59), description: 'Implementasi slicing UI dashboard dan komponen dasar Flutter Web.'),
      Assignment(id: 'controller_2', title: 'Analisis Kompleksitas Algoritma', courseName: 'Sains Komputasi', deadline: DateTime(2026, 9, 28), description: 'Laporan analisis Big O Notation untuk algoritma sorting.'),
      Assignment(id: 'controller_3', title: 'Setup Database PostgreSQL', courseName: 'Basis Data', deadline: DateTime(2026, 9, 30), description: 'Konfigurasi tabel relasional dan ERD untuk sistem akademik.'),
      Assignment(id: 'detail_1', title: 'Tugas 1: Slicing UI Flutter', courseName: 'Pemrograman Mobile', deadline: DateTime(2026, 9, 28, 23, 59), description: 'Slicing UI dashboard SIGMA UNESA menggunakan Flutter Web.'),
      Assignment(id: 'detail_2', title: 'Aljabar Linear', courseName: 'Sains Komputasi', deadline: DateTime(2026, 9, 28, 23, 59), description: 'Menghitung perkalian matriks dan persamaan linear.'),
      Assignment(id: 'detail_3', title: 'Setup Database PostgreSQL', courseName: 'Basis Data', deadline: DateTime(2026, 9, 30, 15, 30), description: 'Membuat script DDL/DML untuk database akademik.'),
      Assignment(id: 'detail_4', title: 'Essai Standarisasi', courseName: 'Basis Data', deadline: DateTime(2026, 9, 28, 23, 59), description: 'Penulisan essai materi normalisasi basis data.'),
      Assignment(id: 'detail_5', title: 'Struktur Data Stack & Queue', courseName: 'Struktur Data', deadline: DateTime(2026, 9, 20, 23, 59), description: 'Laporan praktikum implementasi stack dan queue.', isCompleted: true),
    ]);
  }

  static final AssignmentController instance = AssignmentController._();
  final List<Assignment> _assignments = [];
  String _searchQuery = '';

  List<Assignment> get allAssignments => List.unmodifiable(_assignments);
  List<Assignment> get assignments {
    if (_searchQuery.isEmpty) return allAssignments;
    final q = _searchQuery.toLowerCase();
    return _assignments.where((a) => a.title.toLowerCase().contains(q) || a.courseName.toLowerCase().contains(q)).toList();
  }
  int get totalCount => _assignments.length;
  int get completedCount => _assignments.where((a) => a.isCompleted).length;
  int get pendingCount => _assignments.where((a) => !a.isCompleted && !a.isOverdue).length;
  int get overdueCount => _assignments.where((a) => a.isOverdue).length;
  double get completionRatio => _assignments.isEmpty ? 0 : completedCount / _assignments.length;

  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }

  Future<void> addAssignment({required String title, required String course, required DateTime deadline, required String description, List<int>? reminderOffsetsMinutes}) async {
    final assignment = Assignment(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, courseName: course, deadline: deadline, description: description, reminderOffsetsMinutes: reminderOffsetsMinutes);
    _assignments.insert(0, assignment);
    await ReminderService.instance.scheduleFor(assignment);
    notifyListeners();
  }

  Future<void> toggleCompleted(Assignment assignment) async {
    assignment.isCompleted = !assignment.isCompleted;
    if (assignment.isCompleted) {
      await ReminderService.instance.cancelFor(assignment);
    } else {
      await ReminderService.instance.scheduleFor(assignment);
    }
    notifyListeners();
  }

  Future<void> updateReminders(Assignment assignment, List<int> offsets) async {
    assignment.reminderOffsetsMinutes = List<int>.from(offsets);
    await ReminderService.instance.cancelFor(assignment);
    await ReminderService.instance.scheduleFor(assignment);
    notifyListeners();
  }

  Future<void> removeAssignment(Assignment assignment) async {
    await ReminderService.instance.cancelFor(assignment);
    _assignments.removeWhere((item) => item.id == assignment.id);
    notifyListeners();
  }

  Future<void> initializeReminders() async {
    for (final assignment in _assignments) {
      await ReminderService.instance.scheduleFor(assignment);
    }
  }
}

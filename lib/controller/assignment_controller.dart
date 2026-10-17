
import 'package:flutter/foundation.dart';

import '../model/assignment.dart';
import '../services/reminder_service.dart';

class AssignmentController extends ChangeNotifier {
  AssignmentController._() {
    _assignments.addAll([
      Assignment(
        id: 'home_1',
        title: 'Slicing UI Mobile App SIGMA',
        courseName: 'Pemrograman Berbasis Platform',
        deadline: DateTime(2026, 9, 28, 23, 59),
        description:
            'Implementasi slicing UI dashboard dan modul tugas menggunakan Flutter Web.',
      ),
      Assignment(
        id: 'home_2',
        title: 'Analisis Kompleksitas Algoritma',
        courseName: 'Sains Komputasi',
        deadline: DateTime(2026, 9, 28, 12),
        description:
            'Menghitung Big-O Notasi untuk algoritma pencarian data.',
      ),
      Assignment(
        id: 'home_3',
        title: 'Setup Database PostgreSQL',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 30, 15, 30),
        description:
            'Membuat ERD dan script DDL/DML untuk sistem akademik.',
      ),
      Assignment(
        id: 'home_4',
        title: 'Essai',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 28, 23, 59),
        description: 'Penulisan essai materi basis data.',
      ),
      Assignment(
        id: 'controller_1',
        title: 'Slicing UI Mobile App SIGMA',
        courseName: 'Pemrograman Berbasis Platform',
        deadline: DateTime(2026, 10, 15, 23, 59),
        description:
            'Implementasi slicing UI dashboard dan komponen dasar Flutter Web.',
      ),
      Assignment(
        id: 'controller_2',
        title: 'Analisis Kompleksitas Algoritma',
        courseName: 'Sains Komputasi',
        deadline: DateTime(2026, 9, 28),
        description:
            'Laporan analisis Big O Notation untuk algoritma sorting.',
      ),
      Assignment(
        id: 'controller_3',
        title: 'Setup Database PostgreSQL',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 30),
        description:
            'Konfigurasi tabel relasional dan ERD untuk sistem akademik.',
      ),
      Assignment(
        id: 'detail_1',
        title: 'Tugas 1: Slicing UI Flutter',
        courseName: 'Pemrograman Mobile',
        deadline: DateTime(2026, 9, 28, 23, 59),
        description:
            'Slicing UI dashboard SIGMA UNESA menggunakan Flutter Web.',
      ),
      Assignment(
        id: 'detail_2',
        title: 'Aljabar Linear',
        courseName: 'Sains Komputasi',
        deadline: DateTime(2026, 9, 28, 23, 59),
        description:
            'Menghitung perkalian matriks dan persamaan linear.',
      ),
      Assignment(
        id: 'detail_3',
        title: 'Setup Database PostgreSQL',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 30, 15, 30),
        description:
            'Membuat script DDL/DML untuk database akademik.',
      ),
      Assignment(
        id: 'detail_4',
        title: 'Essai Standarisasi',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 28, 23, 59),
        description:
            'Penulisan essai materi normalisasi basis data.',
      ),
      Assignment(
        id: 'detail_5',
        title: 'Struktur Data Stack & Queue',
        courseName: 'Struktur Data',
        deadline: DateTime(2026, 9, 20, 23, 59),
        description:
            'Laporan praktikum implementasi stack dan queue.',
        isCompleted: true,
      ),
    ]);
  }

  static final AssignmentController instance =
      AssignmentController._();

  final List<Assignment> _assignments = [];
  String _searchQuery = '';

  List<Assignment> get allAssignments {
    final items = List<Assignment>.from(_assignments);

    items.sort((a, b) {
      if (a.isOverdue != b.isOverdue) {
        return a.isOverdue ? -1 : 1;
      }

      if (a.isOverdue && b.isOverdue) {
        return a.deadline.compareTo(b.deadline);
      }

      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      return a.deadline.compareTo(b.deadline);
    });

    return List.unmodifiable(items);
  }

  List<Assignment> get assignments {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return allAssignments;

    return allAssignments.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.courseName.toLowerCase().contains(query);
    }).toList();
  }

  int get totalCount =>
      _assignments.where((task) => !task.isCompleted).length;

  int get completedCount =>
      _assignments.where((task) => task.isCompleted).length;

  int get pendingCount => _assignments
      .where((task) => !task.isCompleted && !task.isOverdue)
      .length;

  int get overdueCount =>
      _assignments.where((task) => task.isOverdue).length;

  int get nearDeadlineCount =>
      _assignments.where((task) => task.isNearDeadline).length;

  double get completionRatio {
    if (_assignments.isEmpty) return 0;

    return completedCount / _assignments.length;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addAssignment({
    required String title,
    required String course,
    required DateTime deadline,
    required String description,
    List<int>? reminderOffsetsMinutes,
  }) async {
    final assignment = Assignment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      courseName: course.trim(),
      deadline: deadline,
      description: description.trim(),
      reminderOffsetsMinutes: reminderOffsetsMinutes,
    );

    _assignments.add(assignment);

    await ReminderService.instance.scheduleFor(assignment);
    notifyListeners();
  }

  Future<void> updateAssignment(
    Assignment assignment, {
    required String title,
    required String course,
    required DateTime deadline,
    required String description,
  }) async {
    final index = _assignments.indexWhere(
      (item) => item.id == assignment.id,
    );

    if (index == -1) return;

    assignment.title = title.trim();
    assignment.courseName = course.trim();
    assignment.deadline = deadline;
    assignment.description = description.trim();

    await ReminderService.instance.cancelFor(assignment);

    if (!assignment.isCompleted) {
      await ReminderService.instance.scheduleFor(assignment);
    }

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

  Future<void> updateReminders(
    Assignment assignment,
    List<int> offsets,
  ) async {
    assignment.reminderOffsetsMinutes = List<int>.from(offsets);

    await ReminderService.instance.cancelFor(assignment);

    if (!assignment.isCompleted) {
      await ReminderService.instance.scheduleFor(assignment);
    }

    notifyListeners();
  }

  Future<void> removeAssignment(Assignment assignment) async {
    await ReminderService.instance.cancelFor(assignment);

    _assignments.removeWhere(
      (item) => item.id == assignment.id,
    );

    notifyListeners();
  }

  Future<void> initializeReminders() async {
    for (final assignment in _assignments) {
      if (!assignment.isCompleted) {
        await ReminderService.instance.scheduleFor(assignment);
      }
    }
  }
}

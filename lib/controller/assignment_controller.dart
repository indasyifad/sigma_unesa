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
        deadline: DateTime(2026, 9, 28, 12, 0),
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
        description: 'Penulisan esai materi basis data.',
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
        deadline: DateTime(2026, 9, 28, 0, 0),
        description:
            'Laporan analisis Big O Notation untuk algoritma sorting.',
      ),
      Assignment(
        id: 'controller_3',
        title: 'Setup Database PostgreSQL',
        courseName: 'Basis Data',
        deadline: DateTime(2026, 9, 30, 0, 0),
        description:
            'Konfigurasi tabel relasional dan ERD untuk sistem akademik.',
      ),
      Assignment(
        id: 'detail_1',
        title: 'Tugas 1: Slicing UI Flutter',
        courseName: 'Pemrograman Berbasis Platform',
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
            'Penulisan esai materi normalisasi basis data.',
      ),
      Assignment(
        id: 'detail_5',
        title: 'Struktur Data Stack & Queue',
        courseName: 'Sains Komputasi',
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

  // Semua halaman mengambil data dari sumber yang sama.
  List<Assignment> get allAssignments {
    final items = List<Assignment>.from(_assignments);

    items.sort((a, b) {
      // Tugas terlambat ditampilkan paling atas.
      if (a.isOverdue != b.isOverdue) {
        return a.isOverdue ? -1 : 1;
      }

      // Tugas terlambat yang paling lama didahulukan.
      if (a.isOverdue && b.isOverdue) {
        return a.deadline.compareTo(b.deadline);
      }

      // Tugas belum selesai ditampilkan sebelum tugas selesai.
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Tugas yang deadline-nya paling dekat didahulukan.
      return a.deadline.compareTo(b.deadline);
    });

    return List.unmodifiable(items);
  }

  // Daftar tugas setelah pencarian.
  List<Assignment> get assignments {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return allAssignments;
    }

    return allAssignments.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.courseName.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();
  }

  // Total tugas hanya menghitung tugas yang belum selesai.
  int get totalCount {
    return _assignments.where((task) => !task.isCompleted).length;
  }

  int get completedCount {
    return _assignments.where((task) => task.isCompleted).length;
  }

  int get pendingCount {
    return _assignments
        .where((task) => !task.isCompleted && !task.isOverdue)
        .length;
  }

  int get overdueCount {
    return _assignments.where((task) => task.isOverdue).length;
  }

  int get nearDeadlineCount {
    return _assignments.where((task) => task.isNearDeadline).length;
  }

  double get completionRatio {
    if (_assignments.isEmpty) {
      return 0;
    }

    return completedCount / _assignments.length;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Menambahkan tugas baru.
  Future<void> addAssignment({
    required String title,
    required String course,
    required DateTime deadline,
    required String description,
    List<int>? reminderOffsetsMinutes,
  }) async {
    if (title.trim().isEmpty || course.trim().isEmpty) {
      return;
    }

    final assignment = Assignment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      courseName: course.trim(),
      deadline: deadline,
      description: description.trim(),
      reminderOffsetsMinutes: reminderOffsetsMinutes,
    );

    _assignments.add(assignment);

    notifyListeners();

    try {
      await ReminderService.instance.scheduleFor(assignment);
    } catch (error) {
      debugPrint('Gagal menjadwalkan pengingat tugas: $error');
    }
  }

  // Memperbarui tugas berdasarkan ID agar objek di semua halaman tetap sama.
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

    if (index == -1) {
      return;
    }

    final existing = _assignments[index];

    existing.update(
      title: title,
      courseName: course,
      deadline: deadline,
      description: description,
    );

    try {
      await ReminderService.instance.cancelFor(existing);

      if (!existing.isCompleted) {
        await ReminderService.instance.scheduleFor(existing);
      }
    } catch (error) {
      debugPrint('Gagal memperbarui pengingat tugas: $error');
    }

    notifyListeners();
  }

  // Mengubah status tugas selesai/belum selesai.
  Future<void> toggleCompleted(Assignment assignment) async {
    final index = _assignments.indexWhere(
      (item) => item.id == assignment.id,
    );

    if (index == -1) {
      return;
    }

    final existing = _assignments[index];
    existing.toggleCompleted();

    try {
      if (existing.isCompleted) {
        await ReminderService.instance.cancelFor(existing);
      } else {
        await ReminderService.instance.scheduleFor(existing);
      }
    } catch (error) {
      debugPrint('Gagal memperbarui status pengingat: $error');
    }

    notifyListeners();
  }

  // Mengubah pengingat untuk tugas tertentu.
  Future<void> updateReminders(
    Assignment assignment,
    List<int> offsets,
  ) async {
    final index = _assignments.indexWhere(
      (item) => item.id == assignment.id,
    );

    if (index == -1) {
      return;
    }

    final existing = _assignments[index];
    existing.updateReminderOffsets(offsets);

    try {
      await ReminderService.instance.cancelFor(existing);

      if (!existing.isCompleted) {
        await ReminderService.instance.scheduleFor(existing);
      }
    } catch (error) {
      debugPrint('Gagal memperbarui pengingat: $error');
    }

    notifyListeners();
  }

  // Menghapus tugas.
  Future<void> removeAssignment(Assignment assignment) async {
    final index = _assignments.indexWhere(
      (item) => item.id == assignment.id,
    );

    if (index == -1) {
      return;
    }

    final existing = _assignments[index];

    try {
      await ReminderService.instance.cancelFor(existing);
    } catch (error) {
      debugPrint('Gagal membatalkan pengingat tugas: $error');
    }

    _assignments.removeWhere(
      (item) => item.id == existing.id,
    );

    notifyListeners();
  }

  // Menjadwalkan ulang pengingat untuk tugas yang belum selesai.
  Future<void> initializeReminders() async {
    for (final assignment in _assignments) {
      if (assignment.isCompleted) {
        continue;
      }

      try {
        await ReminderService.instance.scheduleFor(assignment);
      } catch (error) {
        debugPrint(
          'Gagal menjadwalkan pengingat ${assignment.title}: $error',
        );
      }
    }
  }
}
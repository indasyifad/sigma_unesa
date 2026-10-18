// Model untuk merepresentasikan data tugas pada SIGMA UNESA.
// File: lib/model/assignment.dart

class Assignment {
  // Atribut utama tugas.
  final String id;
  String title;
  String courseName;
  DateTime deadline;
  String description;
  bool isCompleted;

  // Menyimpan pengaturan pengingat dalam menit sebelum deadline.
  List<int> reminderOffsetsMinutes;

  // Constructor untuk membuat objek Assignment.
  Assignment({
    required this.id,
    required this.title,
    required this.courseName,
    required this.deadline,
    required this.description,
    this.isCompleted = false,
    List<int>? reminderOffsetsMinutes,
  }) : reminderOffsetsMinutes =
           List<int>.from(reminderOffsetsMinutes ?? [1440, 180, 60, 30]);

  // Getter untuk nama mata kuliah.
  String get course => courseName;

  // Getter untuk nama tugas.
  String get name => title;

  // Getter untuk mengetahui status tugas.
  String get status {
    if (isCompleted) {
      return 'Selesai';
    }

    if (isOverdue) {
      return 'Terlambat';
    }

    return 'Belum selesai';
  }

  // Getter untuk memeriksa apakah deadline sudah lewat.
  bool get isOverdue {
    return !isCompleted && deadline.isBefore(DateTime.now());
  }

  // Getter untuk memeriksa apakah deadline tinggal maksimal 24 jam.
  bool get isNearDeadline {
    if (isCompleted || isOverdue) {
      return false;
    }

    final Duration remaining = deadline.difference(DateTime.now());

    return remaining > Duration.zero &&
        remaining <= const Duration(hours: 24);
  }

  // Getter untuk mendapatkan sisa waktu menuju deadline.
  Duration get remainingTime {
    return deadline.difference(DateTime.now());
  }

  // Setter untuk mengubah judul tugas.
  set taskTitle(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Judul tugas tidak boleh kosong.');
    }

    title = value.trim();
  }

  // Setter untuk mengubah mata kuliah.
  set taskCourse(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Mata kuliah tidak boleh kosong.');
    }

    courseName = value.trim();
  }

  // Setter untuk mengubah deadline.
  set taskDeadline(DateTime value) {
    deadline = value;
  }

  // Setter untuk mengubah deskripsi.
  set taskDescription(String value) {
    description = value;
  }

  // Method untuk mengubah status penyelesaian tugas.
  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  // Method untuk menetapkan status penyelesaian tugas.
  void setCompletion(bool completed) {
    isCompleted = completed;
  }

  // Method untuk memperbarui daftar pengingat.
  void updateReminderOffsets(List<int> offsets) {
    if (offsets.any((offset) => offset <= 0)) {
      throw ArgumentError(
        'Waktu pengingat harus lebih besar dari nol.',
      );
    }

    reminderOffsetsMinutes = List<int>.from(offsets);
  }

  // Method untuk membuat salinan objek dengan data yang diperbarui.
  Assignment copyWith({
    String? title,
    String? courseName,
    DateTime? deadline,
    String? description,
    bool? isCompleted,
    List<int>? reminderOffsetsMinutes,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      courseName: courseName ?? this.courseName,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderOffsetsMinutes:
          reminderOffsetsMinutes ?? this.reminderOffsetsMinutes,
    );
  }
}
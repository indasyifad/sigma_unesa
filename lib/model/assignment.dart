class Assignment {
  final String id;

  String title;
  String courseName;
  DateTime deadline;
  String description;
  bool isCompleted;

  // Pengingat dalam menit sebelum deadline.
  // Default: 1 hari, 3 jam, 1 jam, dan 30 menit.
  List<int> reminderOffsetsMinutes;

  Assignment({
    required this.id,
    required this.title,
    required this.courseName,
    required this.deadline,
    required this.description,
    this.isCompleted = false,
    List<int>? reminderOffsetsMinutes,
  }) : reminderOffsetsMinutes = List<int>.from(
          reminderOffsetsMinutes ?? [1440, 180, 60, 30],
        );

  // Getter untuk menjaga kompatibilitas dengan halaman lama.
  String get course => courseName;
  String get name => title;

  // Status tugas mengikuti kondisi terbaru.
  String get status {
    if (isCompleted) {
      return 'Selesai';
    }

    if (isOverdue) {
      return 'Terlambat';
    }

    return 'Belum selesai';
  }

  // Tugas terlambat jika belum selesai dan deadline sudah lewat.
  bool get isOverdue {
    return !isCompleted && deadline.isBefore(DateTime.now());
  }

  // Mendekati deadline jika tersisa maksimal 24 jam.
  bool get isNearDeadline {
    if (isCompleted) return false;

    final remaining = deadline.difference(DateTime.now());

    return remaining > Duration.zero &&
        remaining <= const Duration(hours: 24);
  }

  // Mengubah status selesai.
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  // Memperbarui data tugas.
  void update({
    required String title,
    required String courseName,
    required DateTime deadline,
    required String description,
  }) {
    this.title = title.trim();
    this.courseName = courseName.trim();
    this.deadline = deadline;
    this.description = description.trim();
  }

  // Memperbarui pilihan pengingat.
  void updateReminderOffsets(List<int> offsets) {
    reminderOffsetsMinutes = List<int>.from(offsets);
    reminderOffsetsMinutes.sort((a, b) => b.compareTo(a));
  }
}
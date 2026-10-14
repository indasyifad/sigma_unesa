/// Model tugas bersama yang digunakan Dashboard, menu Tugas, dan Laporan.
class Assignment {
  final String id;
  final String title;
  final String courseName;
  final DateTime deadline;
  final String description;
  bool isCompleted;
  List<int> reminderOffsetsMinutes;

  Assignment({
    required this.id,
    required this.title,
    required this.courseName,
    required this.deadline,
    required this.description,
    this.isCompleted = false,
    List<int>? reminderOffsetsMinutes,
  }) : reminderOffsetsMinutes = reminderOffsetsMinutes ?? [1440, 180, 60, 30];

  String get course => courseName;
  String get name => title;
  String get status => isCompleted ? 'Selesai' : (isOverdue ? 'Terlambat' : 'Proses');

  bool get isOverdue => !isCompleted && deadline.isBefore(DateTime.now());
  bool get isNearDeadline => !isCompleted && deadline.difference(DateTime.now()).inDays <= 3 && !isOverdue;
}

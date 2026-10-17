
class Assignment {
  final String id;

  String title;
  String courseName;
  DateTime deadline;
  String description;

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
  }) : reminderOffsetsMinutes =
           reminderOffsetsMinutes ?? [1440, 180, 60, 30];

  String get course => courseName;
  String get name => title;

  String get status {
    if (isCompleted) return 'Selesai';
    if (isOverdue) return 'Terlambat';
    return 'Belum selesai';
  }

  bool get isOverdue =>
      !isCompleted && deadline.isBefore(DateTime.now());

  bool get isNearDeadline {
    if (isCompleted || isOverdue) return false;

    final remaining = deadline.difference(DateTime.now());

    return remaining > Duration.zero &&
        remaining <= const Duration(hours: 24);
  }
}

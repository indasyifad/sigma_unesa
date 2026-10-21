
class Schedule {
  final String id;
  String courseName;

  // Tanggal ini menentukan hari jadwal berulang setiap minggu.
  DateTime date;

  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  String location;
  String lecturer;
  String personInCharge;

  Schedule({
    required this.id,
    required this.courseName,
    required this.date,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.location = '',
    this.lecturer = '',
    this.personInCharge = '',
  });

  /// Hari jadwal berdasarkan tanggal yang dipilih.
  int get weekday => date.weekday;

  /// Format waktu jadwal.
  String get time =>
      '${startHour.toString().padLeft(2, '0')}:'
      '${startMinute.toString().padLeft(2, '0')} - '
      '${endHour.toString().padLeft(2, '0')}:'
      '${endMinute.toString().padLeft(2, '0')}';

  /// Memperbarui informasi jadwal tanpa mengubah ID.
  void update({
    required String courseName,
    required DateTime date,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    required String location,
    required String lecturer,
    required String personInCharge,
  }) {
    this.courseName = courseName;
    this.date = date;
    this.startHour = startHour;
    this.startMinute = startMinute;
    this.endHour = endHour;
    this.endMinute = endMinute;
    this.location = location;
    this.lecturer = lecturer;
    this.personInCharge = personInCharge;
  }
}

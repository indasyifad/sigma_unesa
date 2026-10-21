
import 'package:flutter/material.dart';
import '../model/schedule.dart';

class ScheduleController extends ChangeNotifier {
  ScheduleController._();

  static final ScheduleController instance = ScheduleController._();

  final List<Schedule> _schedules = [
    Schedule(
      id: 'sch_1',
      courseName: 'Pemrograman Berbasis Platform',
      date: DateTime(2026, 9, 28), // Senin
      startHour: 7,
      startMinute: 0,
      endHour: 9,
      endMinute: 30,
      location: 'Lab K3',
    ),
    Schedule(
      id: 'sch_2',
      courseName: 'Sains Komputasi',
      date: DateTime(2026, 9, 28), // Senin
      startHour: 10,
      startMinute: 0,
      endHour: 12,
      endMinute: 30,
      location: 'R. A102',
    ),
  ];

  List<Schedule> get schedules => List.unmodifiable(_schedules);

  /// Mengambil jadwal berdasarkan hari dalam minggu.
  List<Schedule> schedulesOn(DateTime date) {
    final result = _schedules
        .where((schedule) => schedule.weekday == date.weekday)
        .toList();

    result.sort((a, b) {
      final aMinutes = a.startHour * 60 + a.startMinute;
      final bMinutes = b.startHour * 60 + b.startMinute;
      return aMinutes.compareTo(bMinutes);
    });

    return result;
  }

  /// Menandai tanggal yang memiliki jadwal mingguan.
  bool hasScheduleOn(DateTime date) {
    return _schedules.any(
      (schedule) => schedule.weekday == date.weekday,
    );
  }

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void updateSchedule(Schedule updated) {
    final index = _schedules.indexWhere(
      (item) => item.id == updated.id,
    );

    if (index == -1) return;

    _schedules[index] = updated;
    notifyListeners();
  }

  void deleteSchedule(String id) {
    final oldLength = _schedules.length;
    _schedules.removeWhere((item) => item.id == id);

    if (_schedules.length != oldLength) {
      notifyListeners();
    }
  }
}

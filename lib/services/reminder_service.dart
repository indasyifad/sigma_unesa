import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../model/assignment.dart';

/// Penjadwalan notifikasi lokal Android. Tidak menyimpan data tugas secara persisten.
class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool notificationsEnabled = true;

  Future<void> initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    _initialized = true;
  }

  int _id(String id, int suffix) {
    final stableHash = id.codeUnits.fold<int>(0, (value, code) => (value * 31 + code) & 0x7fffffff);
    return (stableHash % 100000000) * 10 + suffix;
  }

  Future<void> scheduleFor(Assignment assignment) async {
    await initialize();
    if (assignment.isCompleted || !notificationsEnabled) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'sigma_deadlines', 'Pengingat Deadline SIGMA',
        channelDescription: 'Pengingat tugas akademik SIGMA UNESA',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    for (var i = 0; i < assignment.reminderOffsetsMinutes.length; i++) {
      final offset = assignment.reminderOffsetsMinutes[i];
      final at = assignment.deadline.subtract(Duration(minutes: offset));
      if (at.isAfter(DateTime.now())) {
        await _plugin.zonedSchedule(
          _id(assignment.id, i + 1),
          'Pengingat tugas: ${assignment.title}',
          '${assignment.courseName} memiliki deadline ${_format(assignment.deadline)}.',
          tz.TZDateTime.from(at, tz.local),
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
    // Pengingat berulang mulai pukul 09.00 setelah deadline, lalu setiap hari.
    var next = DateTime(assignment.deadline.year, assignment.deadline.month, assignment.deadline.day, 9);
    if (!next.isAfter(assignment.deadline)) next = next.add(const Duration(days: 1));
    while (next.isBefore(DateTime.now())) { next = next.add(const Duration(days: 1)); }
    await _plugin.zonedSchedule(
      _id(assignment.id, 9),
      'Tugas belum selesai: ${assignment.title}',
      'Tugas ${assignment.courseName} masih belum ditandai selesai. Yuk, cek progresmu.',
      tz.TZDateTime.from(next, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> setEnabled(bool enabled, Iterable<Assignment> assignments) async {
    await initialize();
    notificationsEnabled = enabled;
    await _plugin.cancelAll();
    if (enabled) { for (final assignment in assignments) { await scheduleFor(assignment); } }
  }

  Future<void> cancelFor(Assignment assignment) async {
    await initialize();
    for (var i = 1; i <= 4; i++) { await _plugin.cancel(_id(assignment.id, i)); }
    await _plugin.cancel(_id(assignment.id, 9));
  }

  String _format(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
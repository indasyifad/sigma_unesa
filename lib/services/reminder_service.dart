
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../model/assignment.dart';

class ReminderService {
  ReminderService._();

  static final ReminderService instance = ReminderService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool notificationsEnabled = true;

  Future<void> initialize() async {
    // Notifikasi lokal tidak didukung oleh plugin ini di Web.
    if (kIsWeb || _initialized) return;

    tzdata.initializeTimeZones();

    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  int _notificationId(String taskId, int suffix) {
    final hash = taskId.codeUnits.fold<int>(
      0,
      (value, code) => (value * 31 + code) & 0x7fffffff,
    );

    return (hash % 100000000) * 10 + suffix;
  }

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'sigma_deadlines',
        'Pengingat Deadline SIGMA',
        channelDescription: 'Pengingat tugas akademik SIGMA UNESA',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> scheduleFor(Assignment assignment) async {
    if (kIsWeb) return;

    await initialize();

    if (assignment.isCompleted || !notificationsEnabled) {
      await cancelFor(assignment);
      return;
    }

    final now = DateTime.now();

    // Jadwalkan pengingat sebelum deadline.
    for (var i = 0;
        i < assignment.reminderOffsetsMinutes.length;
        i++) {
      final offset = assignment.reminderOffsetsMinutes[i];

      final reminderTime =
          assignment.deadline.subtract(Duration(minutes: offset));

      final notificationId = _notificationId(assignment.id, i + 1);

      // Batalkan pengingat lama terlebih dahulu supaya perubahan deadline
      // tidak meninggalkan jadwal notifikasi yang sudah tidak sesuai.
      await _plugin.cancel(notificationId);

      if (reminderTime.isAfter(now)) {
        await _plugin.zonedSchedule(
          notificationId,
          'Pengingat tugas: ${assignment.title}',
          '${assignment.courseName} memiliki deadline '
              '${_format(assignment.deadline)}.',
          tz.TZDateTime.from(reminderTime, tz.local),
          _notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    // Pengingat harian pukul 09.00 untuk tugas yang belum selesai.
    final DateTime firstReminder;

    if (assignment.deadline.isBefore(now)) {
      final todayAtNine = DateTime(
        now.year,
        now.month,
        now.day,
        9,
      );

      firstReminder = todayAtNine.isAfter(now)
          ? todayAtNine
          : todayAtNine.add(const Duration(days: 1));
    } else {
      var deadlineDayAtNine = DateTime(
        assignment.deadline.year,
        assignment.deadline.month,
        assignment.deadline.day,
        9,
      );

      if (!deadlineDayAtNine.isAfter(assignment.deadline)) {
        deadlineDayAtNine =
            deadlineDayAtNine.add(const Duration(days: 1));
      }

      firstReminder = deadlineDayAtNine;
    }

    // Bersihkan jadwal pengingat harian sebelumnya.
    await _plugin.cancel(_notificationId(assignment.id, 9));

    await _plugin.zonedSchedule(
      _notificationId(assignment.id, 9),
      'Tugas belum selesai: ${assignment.title}',
      'Tugas ${assignment.courseName} belum ditandai selesai.',
      tz.TZDateTime.from(firstReminder, tz.local),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> setEnabled(
    bool enabled,
    Iterable<Assignment> assignments,
  ) async {
    notificationsEnabled = enabled;

    // Di Web, pengaturan ini hanya menyimpan status di memori aplikasi.
    if (kIsWeb) return;

    await initialize();
    await _plugin.cancelAll();

    if (enabled) {
      for (final assignment in assignments) {
        await scheduleFor(assignment);
      }
    }
  }

  Future<void> cancelFor(Assignment assignment) async {
    if (kIsWeb) return;

    await initialize();

    for (var i = 1; i <= 4; i++) {
      await _plugin.cancel(_notificationId(assignment.id, i));
    }

    await _plugin.cancel(_notificationId(assignment.id, 9));
  }

  String _format(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }
}

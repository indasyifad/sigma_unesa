
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../controller/assignment_controller.dart';
import '../services/reminder_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();

    _notifEnabled =
        ReminderService.instance.notificationsEnabled;

    _darkModeEnabled =
        AppTheme.mode.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'PENGATURAN',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Notifikasi Pengingat Deadline'),
                value: _notifEnabled,
                onChanged: (value) async {
                  setState(() => _notifEnabled = value);

                  await ReminderService.instance.setEnabled(
                    value,
                    AssignmentController.instance.allAssignments,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pengingat default: 1 hari, 3 jam, 1 jam, '
                    'dan 30 menit sebelum deadline. '
                    'Pengingat tugas terlambat perlu diuji '
                    'pada perangkat Android.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Mode Gelap (Dark Mode)'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() => _darkModeEnabled = value);

                  AppTheme.mode.value = value
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

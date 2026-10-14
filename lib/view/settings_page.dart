import 'package:flutter/material.dart';
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
  void initState() { super.initState(); _notifEnabled = ReminderService.instance.notificationsEnabled; }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PENGATURAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notifikasi Pengingat Deadline'),
                  value: _notifEnabled,
                  onChanged: (val) async { setState(() => _notifEnabled = val); await ReminderService.instance.setEnabled(val, AssignmentController.instance.allAssignments); },
                ),
                const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: Align(alignment: Alignment.centerLeft, child: Text('Pengingat default: 1 hari, 3 jam, 1 jam, dan 30 menit sebelum deadline. Jika terlambat, pengingat berulang setiap hari pukul 09.00 sampai tugas ditandai selesai.', style: TextStyle(fontSize: 12, color: Colors.black54)))),
                SwitchListTile(
                  title: const Text('Mode Gelap (Dark Mode)'),
                  value: _darkModeEnabled,
                  onChanged: (val) => setState(() => _darkModeEnabled = val),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
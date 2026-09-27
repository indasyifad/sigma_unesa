import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifEnabled = true;
  bool _darkModeEnabled = false;

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
                  onChanged: (val) => setState(() => _notifEnabled = val),
                ),
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
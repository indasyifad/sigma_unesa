import 'package:flutter/material.dart';

class NotificationsDrawer extends StatelessWidget {
  const NotificationsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            color: const Color(0xFF213448),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('NOTIFIKASI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                NotificationTile(
                  title: 'Deadline Tugas Mendekat',
                  desc: 'Tugas Slicing UI Mobile App kumpul besok pukul 23:59 WIB.',
                  time: '10 menit lalu',
                  isUnread: true,
                ),
                NotificationTile(
                  title: 'Tugas Baru Ditambahkan',
                  desc: 'Dosen PBP menambahkan tugas baru pada Bab 4.',
                  time: '2 jam lalu',
                  isUnread: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final bool isUnread;

  const NotificationTile({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isUnread ? const Color(0xFFECEFCA).withValues(alpha: 0.5) : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
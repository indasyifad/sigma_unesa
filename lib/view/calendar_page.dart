import 'package:flutter/material.dart';
import 'widgets/add_task_modal.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TUGAS & JADWAL', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF547792)),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah Tugas', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddTaskModal(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.code)),
                    title: Text('Slicing UI Mobile App'),
                    subtitle: Text('Pemrograman Berbasis Platform — Besok, 23:59 WIB'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
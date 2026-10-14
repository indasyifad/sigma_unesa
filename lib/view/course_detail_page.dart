import 'package:flutter/material.dart';
import '../controller/assignment_controller.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseName;
  const CourseDetailPage({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    final controller = AssignmentController.instance;
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: AnimatedBuilder(animation: controller, builder: (context, _) {
        final tasks = controller.allAssignments.where((task) => task.courseName.toLowerCase() == courseName.toLowerCase()).toList();
        return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Detail Mata Kuliah: $courseName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16), const Text('Daftar Tugas:'), const SizedBox(height: 8),
          if (tasks.isEmpty) const Card(child: ListTile(title: Text('Belum ada tugas untuk mata kuliah ini.'))),
          Expanded(child: ListView.builder(itemCount: tasks.length, itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(child: ListTile(title: Text(task.title), subtitle: Text('Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year} • ${task.isCompleted ? 'Selesai' : task.isOverdue ? 'Terlambat' : 'Belum selesai'}'), trailing: Checkbox(value: task.isCompleted, onChanged: (_) => controller.toggleCompleted(task))));
          })),
        ]));
      }),
    );
  }

}
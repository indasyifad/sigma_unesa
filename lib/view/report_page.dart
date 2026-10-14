import 'package:flutter/material.dart';
import '../controller/assignment_controller.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = AssignmentController.instance;
    return AnimatedBuilder(animation: controller, builder: (context, _) {
      final tasks = controller.allAssignments;
      final progress = controller.completionRatio;
      return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Rekap Laporan Tugas & Performa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
        const SizedBox(height: 4), const Text('Ringkasan statistik pengerjaan tugas semester ini', style: TextStyle(fontSize: 13, color: Color(0xFF547792))),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          final cards = [
            _buildReportCard('Total Tugas', '${controller.totalCount}', Colors.blue, Icons.assignment_outlined),
            _buildReportCard('Selesai', '${controller.completedCount}', Colors.green, Icons.check_circle_outline),
            _buildReportCard('Pending', '${controller.pendingCount}', Colors.orange, Icons.hourglass_empty),
            _buildReportCard('Terlambat', '${controller.overdueCount}', Colors.red, Icons.error_outline),
          ];
          return Wrap(spacing: 12, runSpacing: 12, children: cards.map((card) => SizedBox(width: compact ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 36) / 4, child: card)).toList());
        }),
        const SizedBox(height: 24),
        Card(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Expanded(child: Text('Progress Penyelesaian Tugas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF213448))),), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Export PDF / Excel'))]),
          const SizedBox(height: 20), Text('Tingkat Penyelesaian: ${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF213448))),
          const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 12, backgroundColor: Colors.grey.shade200, color: const Color(0xFF547792))),
          const SizedBox(height: 24), const Text('Riwayat Tugas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
          const SizedBox(height: 12), SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF213448).withValues(alpha: 0.08)),
            columns: const [DataColumn(label: Text('Nama Tugas')), DataColumn(label: Text('Mata Kuliah')), DataColumn(label: Text('Deadline')), DataColumn(label: Text('Status'))],
            rows: tasks.map((task) => DataRow(cells: [
              DataCell(Text(task.title)), DataCell(Text(task.courseName)), DataCell(Text(_formatDeadline(task.deadline))),
              DataCell(Chip(label: Text(task.isCompleted ? 'Selesai' : task.isOverdue ? 'Terlambat' : 'Pending'), backgroundColor: task.isCompleted ? Colors.green.shade100 : task.isOverdue ? Colors.red.shade100 : Colors.orange.shade100)),
            ])).toList(),
          )),
        ]))),
      ]));
    });
  }

  Widget _buildReportCard(String title, String count, Color color, IconData icon) => Card(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF547792), fontSize: 12)), const SizedBox(height: 6), Text(count, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color))])), CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20))])));
  String _formatDeadline(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

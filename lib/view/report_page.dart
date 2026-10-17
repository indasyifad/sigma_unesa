
import 'package:flutter/material.dart';

import '../controller/assignment_controller.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AssignmentController.instance;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final tasks = controller.allAssignments;
        final progress = controller.completionRatio;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rekap Laporan Tugas & Performa',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ringkasan statistik pengerjaan tugasmu.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 500
                          ? 2
                          : 1;

                  final spacing = 12.0;
                  final cardWidth =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;

                  final cards = [
                    _statCard(
                      context,
                      'Belum Selesai',
                      '${controller.totalCount}',
                      Colors.blue,
                      Icons.assignment_outlined,
                    ),
                    _statCard(
                      context,
                      'Selesai',
                      '${controller.completedCount}',
                      Colors.green,
                      Icons.check_circle_outline,
                    ),
                    _statCard(
                      context,
                      'Pending',
                      '${controller.pendingCount}',
                      Colors.orange,
                      Icons.hourglass_empty,
                    ),
                    _statCard(
                      context,
                      'Terlambat',
                      '${controller.overdueCount}',
                      Colors.red,
                      Icons.error_outline,
                    ),
                  ];

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: cards
                        .map(
                          (card) => SizedBox(
                            width: cardWidth,
                            child: card,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Penyelesaian Tugas',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tingkat penyelesaian: '
                        '${(progress * 100).toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Daftar Tugas',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (tasks.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('Belum ada tugas yang tercatat.'),
                    ),
                  ),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nama Tugas')),
                        DataColumn(label: Text('Mata Kuliah')),
                        DataColumn(label: Text('Deadline')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: tasks.map((task) {
                        final status = task.isCompleted
                            ? 'Selesai'
                            : task.isOverdue
                                ? 'Terlambat'
                                : 'Belum selesai';

                        final statusColor = task.isCompleted
                            ? Colors.green
                            : task.isOverdue
                                ? Colors.red
                                : Colors.orange;

                        return DataRow(
                          cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 220),
                                child: Text(
                                  task.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(Text(task.courseName)),
                            DataCell(Text(_formatDate(task.deadline))),
                            DataCell(
                              Chip(
                                label: Text(status),
                                backgroundColor:
                                    statusColor.withValues(alpha: 0.12),
                                side: BorderSide.none,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');

    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }
}

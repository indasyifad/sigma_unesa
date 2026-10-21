
import 'package:flutter/material.dart';
import '../controller/assignment_controller.dart';
import '../model/assignment.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  static const Color navy = Color(0xFF213448);
  static const Color blue = Color(0xFF547792);
  static const Color cream = Color(0xFFEFF2C9);

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  Color _statusColor(Assignment task) {
    if (task.isCompleted) return const Color(0xFF16A34A);
    if (task.isOverdue) return const Color(0xFFDC2626);
    if (task.isNearDeadline) return const Color(0xFFD97706);
    return blue;
  }

  String _statusText(Assignment task) {
    if (task.isCompleted) return 'Selesai';
    if (task.isOverdue) return 'Terlambat';
    if (task.isNearDeadline) return 'Mendekati Deadline';
    return 'Belum Selesai';
  }

  @override
  Widget build(BuildContext context) {
    final controller = AssignmentController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final tasks = controller.allAssignments;
        final completed = tasks.where((task) => task.isCompleted).length;
        final overdue = tasks.where((task) => task.isOverdue).length;
        final pending = tasks.where(
          (task) => !task.isCompleted && !task.isOverdue,
        ).length;
        final progress = tasks.isEmpty ? 0.0 : completed / tasks.length;

        return Container(
          color: cream,
          width: double.infinity,
          height: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 650;

              return ListView(
                padding: EdgeInsets.all(compact ? 14 : 24),
                children: [
                  const Text(
                    'Rekap Laporan Tugas',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ringkasan statistik berdasarkan data tugas akademik.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, box) {
                      final columns = box.maxWidth >= 1000
                          ? 4
                          : box.maxWidth >= 500
                              ? 2
                              : 1;
                      const gap = 12.0;
                      final width =
                          (box.maxWidth - gap * (columns - 1)) / columns;

                      final cards = [
                        _StatCard(
                          title: 'Belum Selesai',
                          value: '${tasks.length - completed}',
                          color: const Color(0xFF0284C7),
                          icon: Icons.assignment_outlined,
                        ),
                        _StatCard(
                          title: 'Selesai',
                          value: '$completed',
                          color: const Color(0xFF16A34A),
                          icon: Icons.check_circle_outline,
                        ),
                        _StatCard(
                          title: 'Pending',
                          value: '$pending',
                          color: const Color(0xFFD97706),
                          icon: Icons.hourglass_empty,
                        ),
                        _StatCard(
                          title: 'Terlambat',
                          value: '$overdue',
                          color: const Color(0xFFDC2626),
                          icon: Icons.error_outline,
                        ),
                      ];

                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: cards
                            .map(
                              (card) => SizedBox(
                                width: width,
                                child: card,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(compact ? 16 : 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progress Penyelesaian',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Tingkat penyelesaian',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: const Color(0xFFD7E5F2),
                            color: blue,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          '$completed dari ${tasks.length} tugas telah selesai.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Daftar Tugas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (tasks.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Belum ada tugas yang tercatat.'),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: compact
                                  ? 720
                                  : constraints.maxWidth - 48,
                            ),
                            child: DataTable(
                              horizontalMargin: 18,
                              columnSpacing: 24,
                              headingRowHeight: 52,
                              dataRowMinHeight: 54,
                              dataRowMaxHeight: 72,
                              headingRowColor:
                                  WidgetStateProperty.all(navy),
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              dataTextStyle: const TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 12,
                              ),
                              columns: const [
                                DataColumn(
                                  label: SizedBox(
                                    width: 220,
                                    child: Text('Nama Tugas'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 210,
                                    child: Text('Mata Kuliah'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 145,
                                    child: Text('Deadline'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 150,
                                    child: Text('Status'),
                                  ),
                                ),
                              ],
                              rows: tasks.map((task) {
                                final color = _statusColor(task);

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 220,
                                        child: Text(
                                          task.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 210,
                                        child: Text(
                                          task.courseName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 145,
                                        child: Text(
                                          _formatDate(task.deadline),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 150,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: color.withValues(
                                                alpha: 0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              _statusText(task),
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }
}

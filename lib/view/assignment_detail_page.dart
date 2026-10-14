import 'package:flutter/material.dart';
import '../model/assignment.dart';
import '../controller/assignment_controller.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage({super.key});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategoryFilter = "All";
  String _selectedActivityFilter = "All Activities";

  List<Assignment> get _tasks => AssignmentController.instance.allAssignments;

  @override
  void initState() {
    super.initState();
    AssignmentController.instance.addListener(_refresh);
  }

  void _refresh() { if (mounted) setState(() {}); }

  String _formatDeadline(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  String _month(int month) => const ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'][month - 1];

  @override
  void dispose() {
    AssignmentController.instance.removeListener(_refresh);
    _searchController.dispose();
    super.dispose();
  }

  // MODAL DETAIL TUGAS
  void _openTaskDetailModal(Assignment task) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFEAEFF5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF547792),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.courseName,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Deskripsi Tugas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 16, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Text('Deadline: ${_formatDeadline(task.deadline)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.isCompleted ? Colors.orange : const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: Icon(task.isCompleted ? Icons.undo : Icons.check_circle, size: 18),
                      label: Text(task.isCompleted ? 'Batal Selesai' : 'Tandai Selesai'),
                      onPressed: () {
                        AssignmentController.instance.toggleCompleted(task);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _configureReminders(Assignment task) async {
    final options = <int, String>{1440: '1 hari sebelum', 180: '3 jam sebelum', 60: '1 jam sebelum', 30: '30 menit sebelum'};
    final selected = Set<int>.from(task.reminderOffsetsMinutes);
    await showDialog<void>(context: context, builder: (dialogContext) => StatefulBuilder(builder: (context, setDialogState) => AlertDialog(
      title: const Text('Atur Pengingat Tugas'),
      content: Column(mainAxisSize: MainAxisSize.min, children: options.entries.map((entry) => CheckboxListTile(
        contentPadding: EdgeInsets.zero, title: Text(entry.value), value: selected.contains(entry.key),
        onChanged: (value) => setDialogState(() { if (value == true) { selected.add(entry.key); } else { selected.remove(entry.key); } }),
      )).toList()),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')), ElevatedButton(onPressed: () async { await AssignmentController.instance.updateReminders(task, selected.toList()..sort((a,b) => b.compareTo(a))); if (dialogContext.mounted) Navigator.pop(dialogContext); }, child: const Text('Simpan'))],
    )));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    final filteredTasks = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.courseName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Container(
      color: const Color(0xFFEFF2C9), // Theme Cream utama
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 14.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Judul Halaman
            const Text(
              'DAFTAR TUGAS AKADEMIK',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF213448),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),

            // Container Card Putih Utama
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 14.0 : 20.0),
                child: Column(
                  children: [
                    // Row Search & Filter Atas
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) => setState(() => _searchQuery = val),
                              decoration: const InputDecoration(
                                hintText: 'Cari tugas atau matkul...',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF547792),
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.tune, color: Colors.white, size: 16),
                          label: Text(isMobile ? '' : 'Filter', style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row Filter Dropdown Sub-Options
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategoryFilter,
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All Categories', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'Mobile', child: Text('Pemrograman Mobile', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'Database', child: Text('Basis Data', style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (val) => setState(() => _selectedCategoryFilter = val!),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedActivityFilter,
                              items: const [
                                DropdownMenuItem(value: 'All Activities', child: Text('All Activities', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'Active', child: Text('Aktif', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'Done', child: Text('Selesai', style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (val) => setState(() => _selectedActivityFilter = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // TABEL DATA UTAMA (BISA DI-SCROLL HORIZONTAL DI HP)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: isMobile ? 650 : 800),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                          horizontalMargin: 12,
                          columnSpacing: 16,
                          columns: const [
                            DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            DataColumn(label: Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            DataColumn(label: Text('Deadline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            DataColumn(label: Text('Prioritas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          ],
                          rows: filteredTasks.map((task) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  InkWell(
                                    onTap: () => _openTaskDetailModal(task),
                                    child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF213448))),
                                  ),
                                ),
                                DataCell(Text(task.courseName, style: const TextStyle(fontSize: 12))),
                                DataCell(Text(_formatDeadline(task.deadline), style: const TextStyle(fontSize: 12))),
                                DataCell(_buildPriorityWidget(task.isNearDeadline ? 'Prioritas' : 'Normal')),
                                DataCell(_buildStatusWidget(task.status)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF547792)),
                                        tooltip: 'Detail',
                                        onPressed: () => _openTaskDetailModal(task),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                        tooltip: 'Hapus',
                                        onPressed: () {
                                          AssignmentController.instance.removeAssignment(task);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pagination Kontrol Bawah
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('1-${filteredTasks.length} dari ${_tasks.length}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                          onPressed: () {},
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Badge Prioritas
  Widget _buildPriorityWidget(String priority) {
    if (priority == 'Prioritas') {
      return const Text('Prioritas', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12));
    }
    return Text(priority, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 12));
  }

  // Widget Badge Status
  Widget _buildStatusWidget(String status) {
    if (status == 'Terlambat') {
      return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(12)), child: const Text('Terlambat', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)));
    }
    if (status == 'Belum Selesai') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8BB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Belum Selesai', style: TextStyle(color: Color(0xFF8A5B00), fontSize: 10, fontWeight: FontWeight.bold)),
      );
    } else if (status == 'Selesai') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Selesai', style: TextStyle(color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.bold)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF547792),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text('Proses', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
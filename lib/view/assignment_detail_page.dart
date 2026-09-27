import 'package:flutter/material.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage({super.key});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tasks = [
    {
      'name': 'Tugas 1: Slicing UI Flutter',
      'course': 'Pemrograman Mobile',
      'deadline': 'Besok, 23:59 WIB',
      'priority': 'Prioritas',
      'status': 'Belum Selesai',
    },
    {
      'name': 'Aljabar Linear',
      'course': 'Aljabar Linear',
      'deadline': 'Besok, 23:59 WIB',
      'priority': 'Prioritas',
      'status': 'Proses',
    },
    {
      'name': 'Tugas 1: Slicing UI Flutter',
      'course': 'Pemrograman Mobile',
      'deadline': 'Besok, 23:59 WIB',
      'priority': 'Prioritas',
      'status': 'Proses',
    },
    {
      'name': 'Aljabar Linear',
      'course': 'Aljabar Linear',
      'deadline': 'Besok, 23:59 WIB',
      'priority': 'Selesai',
      'status': 'Proses',
    },
    {
      'name': 'Struktur Data',
      'course': 'Struktur Data',
      'deadline': 'Besok, 23:59 WIB',
      'priority': 'Selesai',
      'status': 'Proses',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul Halaman
          const Text(
            'TUGAS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF213448),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Container Card Putih Utama
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF547792),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.tune, color: Colors.white, size: 16),
                        label: const Text('Filter', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row Filter Dropdown Sub-Options
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'All',
                            items: const [
                              DropdownMenuItem(value: 'All', child: Text('All', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'All Activities',
                            items: const [
                              DropdownMenuItem(value: 'All Activities', child: Text('All Activities', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list, size: 16, color: Colors.grey),
                        label: const Text('Filters', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tabel Data Utama
                  SizedBox(
                    width: double.infinity,
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
                      rows: _tasks.map((task) {
                        return DataRow(
                          cells: [
                            DataCell(Text(task['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataCell(Text(task['course'], style: const TextStyle(fontSize: 13))),
                            DataCell(Text(task['deadline'], style: const TextStyle(fontSize: 13))),
                            DataCell(_buildPriorityWidget(task['priority'])),
                            DataCell(_buildStatusWidget(task['status'])),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black54),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pagination Kontrol Bawah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('1-5 dari 12', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
    );
  }

  // Widget Badge Prioritas
  Widget _buildPriorityWidget(String priority) {
    if (priority == 'Prioritas') {
      return const Text('Prioritas', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12));
    }
    return const Text('Selesai', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12));
  }

  // Widget Badge Status
  Widget _buildStatusWidget(String status) {
    if (status == 'Belum Selesai') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8BB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('Belum Selesai', style: TextStyle(color: Color(0xFF8A5B00), fontSize: 11, fontWeight: FontWeight.bold)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF547792),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text('Proses', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
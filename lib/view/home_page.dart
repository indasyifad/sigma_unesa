import 'package:flutter/material.dart';
import 'widgets/add_task_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> taskList = [
    {
      'title': 'Slicing UI Mobile App SIGMA',
      'course': 'Pemrograman Berbasis Platform',
      'deadline': '28 Sep 2026, 23:59',
      'color': '0xFFEF4444',
      'desc': 'Selesaikan slicing antarmuka web dan mobile menggunakan Flutter Web.',
    },
    {
      'title': 'Analisis Kompleksitas Algoritma',
      'course': 'Sains Komputasi',
      'deadline': '28 Sep 2026, 12:00',
      'color': '0xFFF59E0B',
      'desc': 'Hitung kompleksitas waktu Big-O dari algoritma pengurutan.',
    },
    {
      'title': 'Setup Database PostgreSQL',
      'course': 'Basis Data',
      'deadline': '30 Sep 2026, 15:30',
      'color': '0xFF3B82F6',
      'desc': 'Konfigurasi database server PostgreSQL dan migrasi tabel.',
    },
  ];

  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void _openAddTaskModal() {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        onTaskAdded: (newTask) {
          setState(() {
            taskList.add({
              'title': newTask['title'] ?? '',
              'course': newTask['course'] ?? '',
              'deadline': newTask['deadline'] ?? 'Tanpa Deadline',
              'color': '0xFF3B82F6',
              'desc': newTask['desc'] ?? '',
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = taskList.where((task) {
      final query = searchQuery.toLowerCase().trim();
      if (query.isEmpty) return true;
      return task['title']!.toLowerCase().contains(query) ||
          task['course']!.toLowerCase().contains(query) ||
          task['desc']!.toLowerCase().contains(query) ||
          task['deadline']!.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Selamat Datang, Indasyifa!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Berikut adalah ringkasan akademis dan daftar tugas Anda hari ini.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 260,
                    height: 42,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Cari tugas, matkul, deadline...',
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _openAddTaskModal,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text('Tambah Tugas', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF547792),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.assignment_outlined,
                  iconBgColor: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0284C7),
                  label: 'Total Tugas',
                  value: taskList.length.toString(),
                  valueColor: const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.warning_amber_rounded,
                  iconBgColor: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFD97706),
                  label: 'Mendekati Deadline',
                  value: taskList.where((t) => t['deadline']!.contains('28 Sep')).length.toString(),
                  valueColor: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle_outline,
                  iconBgColor: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                  label: 'Selesai',
                  value: '5',
                  valueColor: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tugas Perlu Segera Diselesaikan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              title: Text(task['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(task['course']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(task['color']!)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task['deadline']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('📅 ', style: TextStyle(fontSize: 16)),
                          Text('Jadwal Hari Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildScheduleItem('07:00 - 09:30', 'Pemrograman Berbasis Platform', 'Lab K3'),
                      _buildScheduleItem('10:00 - 12:30', 'Sains Komputasi', 'R. A102'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String course, String room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const SizedBox(height: 2),
          Text(course, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 2),
          Text(room, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor)),
            ],
          ),
        ],
      ),
    );
  }
}
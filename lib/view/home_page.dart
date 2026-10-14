import 'package:flutter/material.dart';
import '../model/assignment.dart';
import '../controller/assignment_controller.dart';
import '../controller/auth_controller.dart';

typedef TaskItem = Assignment;

class ScheduleItem {
  final String id;
  final String course;
  final String time;
  final String room;
  final DateTime date;

  ScheduleItem({
    required this.id,
    required this.course,
    required this.time,
    required this.room,
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const HomePage({super.key, required this.onNavigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = "";
  String _selectedStatFilter = "ALL"; // ALL, NEAR_DEADLINE, COMPLETED
  DateTime _calendarFocusedMonth = DateTime(2026, 9, 1);
  DateTime _selectedCalendarDate = DateTime(2026, 9, 28);

  List<TaskItem> get _tasks => AssignmentController.instance.allAssignments;

  final List<ScheduleItem> _schedules = [
    ScheduleItem(
      id: 'sch_1',
      course: 'Pemrograman Berbasis Platform',
      time: '07:00 - 09:30',
      room: 'Lab K3',
      date: DateTime(2026, 9, 28),
    ),
    ScheduleItem(
      id: 'sch_2',
      course: 'Sains Komputasi',
      time: '10:00 - 12:30',
      room: 'R. A102',
      date: DateTime(2026, 9, 28),
    ),
  ];

  // POPUP MODAL DETAIL TUGAS (DI-KLIK PADA CARD TUGAS)
  void _openTaskDetail(TaskItem task) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final timeStr = "${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}";
            final dateStr = "${task.deadline.day} ${const ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'][task.deadline.month - 1]} ${task.deadline.year}, $timeStr";

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
                        task.course,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Deskripsi Tugas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    Text(
                      task.description.isEmpty ? 'Tidak ada deskripsi rinci untuk tugas ini.' : task.description,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled, size: 16, color: Color(0xFFEF4444)),
                        const SizedBox(width: 6),
                        Text('Deadline: $dateStr', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(onPressed: () => _configureReminders(task), icon: const Icon(Icons.notifications_active_outlined), label: const Text('Pengingat')),
                        const SizedBox(width: 8),
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

  // MODAL TAMBAH TUGAS (5 FIELD PRESISI)
  void _openAddTaskModal() {
    final nameController = TextEditingController();
    final detailController = TextEditingController();
    String? selectedCourse;
    DateTime? selectedDeadlineDate;
    TimeOfDay? selectedDeadlineTime;

    final List<String> courses = [
      'Pemrograman Berbasis Platform',
      'Sains Komputasi',
      'Basis Data',
      'Sistem Operasi',
      'Jaringan Komputer',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: const Color(0xFFEAEFF5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 460,
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tambah Tugas Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Nama Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Nama Tugas',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
                          filled: true,
                          fillColor: const Color(0xFFE2E8F0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCourse,
                        hint: const Text('Pilih matkul', style: TextStyle(fontSize: 12, color: Colors.black38)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE2E8F0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                        ),
                        items: courses.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (val) => setModalState(() => selectedCourse = val),
                      ),
                      const SizedBox(height: 12),

                      const Text('Detail Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      TextField(
                        controller: detailController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Detail Tugas',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
                          filled: true,
                          fillColor: const Color(0xFFE2E8F0),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Deadline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            if (!context.mounted) return;
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 23, minute: 59),
                            );
                            setModalState(() {
                              selectedDeadlineDate = pickedDate;
                              selectedDeadlineTime = pickedTime ?? const TimeOfDay(hour: 23, minute: 59);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDeadlineDate == null
                                    ? 'Pilih hari/tanggal'
                                    : '${selectedDeadlineDate!.day}/${selectedDeadlineDate!.month}/${selectedDeadlineDate!.year}, ${selectedDeadlineTime!.hour.toString().padLeft(2, '0')}:${selectedDeadlineTime!.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedDeadlineDate == null ? Colors.black38 : Colors.black87,
                                ),
                              ),
                              const Icon(Icons.calendar_month, size: 16, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text('Upload file / Files', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 16, color: Colors.black45),
                            SizedBox(width: 6),
                            Text('Upload file atau foto (opsional)', style: TextStyle(fontSize: 11, color: Colors.black45)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF547792),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              if (nameController.text.isNotEmpty) {
                                final finalDateTime = selectedDeadlineDate != null
                                    ? DateTime(
                                        selectedDeadlineDate!.year,
                                        selectedDeadlineDate!.month,
                                        selectedDeadlineDate!.day,
                                        selectedDeadlineTime?.hour ?? 23,
                                        selectedDeadlineTime?.minute ?? 59,
                                      )
                                    : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 23, 59);

                                await AssignmentController.instance.addAssignment(
                                  title: nameController.text,
                                  course: selectedCourse ?? 'Umum',
                                  deadline: finalDateTime,
                                  description: detailController.text,
                                );
                                if (mounted) setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Simpan Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF475569),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              side: const BorderSide(color: Colors.black26),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // MODAL SHORTCUT TAMBAH JADWAL
  void _openAddScheduleModal() {
    final courseController = TextEditingController();
    final timeController = TextEditingController();
    final roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Jadwal Kuliah', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF213448))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: courseController, decoration: const InputDecoration(labelText: 'Mata Kuliah')),
            TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Waktu (misal: 07:00 - 09:30)')),
            TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Ruangan (misal: Lab K3)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213448), foregroundColor: Colors.white),
            onPressed: () {
              if (courseController.text.isNotEmpty) {
                setState(() {
                  _schedules.add(
                    ScheduleItem(
                      id: 'sch_${DateTime.now().millisecondsSinceEpoch}',
                      course: courseController.text,
                      time: timeController.text.isEmpty ? '07:00 - 09:30' : timeController.text,
                      room: roomController.text.isEmpty ? 'R. Kuliah' : roomController.text,
                      date: _selectedCalendarDate,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() { super.initState(); AssignmentController.instance.addListener(_refreshTasks); AuthController.instance.addListener(_refreshTasks); }
  void _refreshTasks() { if (mounted) setState(() {}); }
  @override
  void dispose() { AssignmentController.instance.removeListener(_refreshTasks); AuthController.instance.removeListener(_refreshTasks); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // LAYOUT RESPONSIF: Lebar kurang dari 800 dianggap Mode HP
    final isMobile = MediaQuery.of(context).size.width < 800;

    final filteredTasks = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.course.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedStatFilter == "OVERDUE") {
        return matchesSearch && task.isOverdue;
      } else if (_selectedStatFilter == "NEAR_DEADLINE") {
        return matchesSearch && !task.isCompleted && task.isNearDeadline;
      } else if (_selectedStatFilter == "COMPLETED") {
        return matchesSearch && task.isCompleted;
      } else {
        return matchesSearch && !task.isCompleted;
      }
    }).toList();

    return Container(
      color: const Color(0xFFEFF2C9),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        'Selamat Datang, ${AuthController.instance.currentUser?.username ?? 'Pengguna'}!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Berikut adalah ringkasan akademis dan daftar tugas Anda hari ini.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFF213448), size: 24),
                    onPressed: () {},
                  )
              ],
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [TextButton.icon(onPressed: () => widget.onNavigateToTab(1), icon: const Icon(Icons.menu_book_outlined, size: 18), label: const Text('Lihat Mata Kuliah'), style: TextButton.styleFrom(foregroundColor: const Color(0xFF213448))), TextButton.icon(onPressed: () => widget.onNavigateToTab(4), icon: const Icon(Icons.bar_chart_outlined, size: 18), label: const Text('Lihat Laporan'), style: TextButton.styleFrom(foregroundColor: const Color(0xFF213448))) ]),
            const SizedBox(height: 8),

            // Search Bar + Button Tambah Tugas (Responsif)
            if (isMobile) ...[
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Cari tugas, matkul, deadline...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black38),
                    prefixIcon: Icon(Icons.search, color: Colors.black45, size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF547792),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: _openAddTaskModal,
                ),
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Cari tugas, matkul, deadline...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.black38),
                          prefixIcon: Icon(Icons.search, color: Colors.black45, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF547792),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tambah Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: _openAddTaskModal,
                  )
                ],
              ),
            const SizedBox(height: 16),

            // STAT CARDS (PADA HP TERAMBIL 100% WIDTH AGAR TIDAK GEPENG)
            LayoutBuilder(
              builder: (context, constraints) {
                final double cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 36) / 4;

                final nearDeadlineCount = _tasks.where((t) => !t.isCompleted && t.isNearDeadline).length;
                final totalActiveCount = _tasks.length;
                final overdueCount = _tasks.where((t) => t.isOverdue).length;
                final completedCount = _tasks.where((t) => t.isCompleted).length;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard('Total Tugas', totalActiveCount.toString(), Icons.assignment_outlined, const Color(0xFFE0F2FE), const Color(0xFF0284C7), "ALL", cardWidth),
                    _buildStatCard('Mendekati Deadline', nearDeadlineCount.toString(), Icons.warning_amber_rounded, const Color(0xFFFEF3C7), const Color(0xFFD97706), "NEAR_DEADLINE", cardWidth),
                    _buildStatCard('Selesai', completedCount.toString(), Icons.check_circle_outline_rounded, const Color(0xFFDCFCE7), const Color(0xFF16A34A), "COMPLETED", cardWidth),
                    _buildStatCard('Terlambat', overdueCount.toString(), Icons.error_outline_rounded, const Color(0xFFFEE2E2), const Color(0xFFDC2626), "OVERDUE", cardWidth),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // MAIN CONTENT AREA: JIKA HP -> KOLOM VERTIKAL TUMPUK, JIKA DESKTOP -> ROW SAMPING
            if (isMobile) ...[
              // HP Mode: List Tugas Dulu
              _buildTaskListSection(filteredTasks),
              const SizedBox(height: 20),
              // HP Mode: Kolom Kalender & Jadwal di Bawahnya
              _buildRightScheduleSection(),
            ] else ...[
              // Desktop Mode: Samping-Sampingan
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildTaskListSection(filteredTasks)),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: _buildRightScheduleSection()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // WIDGET BAGIAN LIST TUGAS
  Widget _buildTaskListSection(List<TaskItem> filteredTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedStatFilter == "NEAR_DEADLINE"
              ? 'Tugas Mendekati Deadline'
              : _selectedStatFilter == "OVERDUE"
                  ? 'Tugas Terlambat'
                  : _selectedStatFilter == "COMPLETED"
                  ? 'Tugas Selesai'
                  : 'Tugas Perlu Segera Diselesaikan',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredTasks.length,
          itemBuilder: (context, idx) {
            final task = filteredTasks[idx];
            final timeStr = "${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}";
            final dateStr = "${task.deadline.day} ${const ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'][task.deadline.month - 1]} ${task.deadline.year}, $timeStr";

            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openTaskDetail(task), // DI-KLIK MASUK DETAIL TUGAS
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF213448))),
                              const SizedBox(height: 4),
                              Text(task.course, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: task.isNearDeadline ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            dateStr,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // WIDGET BAGIAN KALENDER & TIMELINE JADWAL
  Widget _buildRightScheduleSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFFEF4444), size: 18),
                  SizedBox(width: 6),
                  Text('Jadwal Hari Ini', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFF547792), size: 20),
                tooltip: 'Tambah Jadwal',
                onPressed: _openAddScheduleModal,
              )
            ],
          ),
          const SizedBox(height: 6),
          _buildCompactSmallCalendar(),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          ..._buildScheduleItemsTimeline(),
        ],
      ),
    );
  }

  // WIDGET STAT CARD
  Widget _buildStatCard(String title, String count, IconData icon, Color iconBgColor, Color iconColor, String filterKey, double width) {
    final isSelected = _selectedStatFilter == filterKey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStatFilter = filterKey;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: iconColor, width: 2) : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                  Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactSmallCalendar() {
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final daysInMonth = DateUtils.getDaysInMonth(_calendarFocusedMonth.year, _calendarFocusedMonth.month);
    final firstDayOffset = DateTime(_calendarFocusedMonth.year, _calendarFocusedMonth.month, 1).weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${months[_calendarFocusedMonth.month - 1]} ${_calendarFocusedMonth.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF213448))),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _calendarFocusedMonth = DateTime(_calendarFocusedMonth.year, _calendarFocusedMonth.month - 1, 1)),
                  child: const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.chevron_left, size: 16)),
                ),
                InkWell(
                  onTap: () => setState(() => _calendarFocusedMonth = DateTime(_calendarFocusedMonth.year, _calendarFocusedMonth.month + 1, 1)),
                  child: const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.chevron_right, size: 16)),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((d) => Text(d, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45))).toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + firstDayOffset,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.8),
          itemBuilder: (context, idx) {
            if (idx < firstDayOffset) return const SizedBox.shrink();
            final day = idx - firstDayOffset + 1;
            final isSelected = _selectedCalendarDate.day == day && _selectedCalendarDate.month == _calendarFocusedMonth.month && _selectedCalendarDate.year == _calendarFocusedMonth.year;

            return InkWell(
              onTap: () => setState(() => _selectedCalendarDate = DateTime(_calendarFocusedMonth.year, _calendarFocusedMonth.month, day)),
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF213448) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildScheduleItemsTimeline() {
    final active = _schedules.where((s) {
      return s.date.year == _selectedCalendarDate.year &&
          s.date.month == _selectedCalendarDate.month &&
          s.date.day == _selectedCalendarDate.day;
    }).toList();

    if (active.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Tidak ada jadwal kuliah hari ini, bebas tugas!', style: TextStyle(fontSize: 11, color: Colors.black45)),
        )
      ];
    }

    return active.map((s) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF213448),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.course, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(s.room, style: const TextStyle(fontSize: 9, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF547792), borderRadius: BorderRadius.circular(6)),
            child: Text(s.time, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    )).toList();
  }
}
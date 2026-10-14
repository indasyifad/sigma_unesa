import 'package:flutter/material.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Map<String, String>)? onTaskAdded;

  const AddTaskModal({super.key, this.onTaskAdded});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String? _selectedCourse;
  DateTime? _selectedDeadlineDate;

  final List<String> _courseList = [
    'Pemrograman Berbasis Platform',
    'Sains Komputasi',
    'Basis Data',
    'Jaringan Komputer',
    'Sistem Operasi',
  ];

  Future<void> _selectDeadlineDate(BuildContext context) async {
    final DateTime initialDate = _selectedDeadlineDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF547792),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadlineDate = picked;
        const List<String> months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
          'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        _deadlineController.text = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
                const SizedBox(height: 18),

                // 1. Nama Tugas
                const Text(
                  'Nama Tugas',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    hintText: 'Nama Tugas',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Nama tugas wajib diisi' : null,
                ),
                const SizedBox(height: 14),

                // 2. Mata Kuliah
                const Text(
                  'Mata Kuliah',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCourse,
                  hint: const Text('Pilih matkul', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  items: _courseList.map((String course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCourse = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih mata kuliah' : null,
                ),
                const SizedBox(height: 14),

                // 3. Detail Tugas
                const Text(
                  'Detail Tugas',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _detailController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Detail Tugas',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Deadline
                const Text(
                  'Deadline',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  onTap: () => _selectDeadlineDate(context),
                  decoration: InputDecoration(
                    hintText: 'Pilih hari/tanggal',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    suffixIcon: const Icon(Icons.calendar_month, size: 20, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Pilih deadline' : null,
                ),
                const SizedBox(height: 14),

                // 5. Upload File Placeholder
                const Text(
                  'Upload file / Files',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 18, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'Upload file atau foto (opsional)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 6. Tombol Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF547792),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.onTaskAdded != null) {
                            widget.onTaskAdded!({
                              'title': _taskNameController.text,
                              'course': _selectedCourse!,
                              'deadline': _deadlineController.text,
                              'desc': _detailController.text,
                            });
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Simpan Tugas', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
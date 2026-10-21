
import '../controller/schedule_controller.dart';
import '../model/schedule.dart';
import 'package:flutter/material.dart';

import '../controller/course_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  final List<Map<String, dynamic>> _schedules = [];

  final List<String> _months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<String> _weekdays = const [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
  ];

  List<String> get _courseNames => CourseController.instance.courses
      .map((course) => course.name)
      .toList();

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _focusedMonth = DateTime(today.year, today.month);
    _selectedDate = DateUtils.dateOnly(today);
  }

  void _changeMonth(int amount) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + amount,
        1,
      );
    });
  }

  Future<void> _showScheduleDialog({Map<String, dynamic>? existing}) async {
    final isEditing = existing != null;
    final courseNames = _courseNames;

    String selectedCourse = existing?['course'] as String? ??
        (courseNames.isNotEmpty ? courseNames.first : '');

    DateTime selectedDate =
        existing?['date'] as DateTime? ?? _selectedDate;

    TimeOfDay startTime = existing?['startTime'] as TimeOfDay? ??
        const TimeOfDay(hour: 7, minute: 0);

    TimeOfDay endTime = existing?['endTime'] as TimeOfDay? ??
        const TimeOfDay(hour: 9, minute: 30);

    final locationController = TextEditingController(
      text: existing?['location'] as String? ?? '',
    );
    final lecturerController = TextEditingController(
      text: existing?['lecturer'] as String? ?? '',
    );
    final pjController = TextEditingController(
      text: existing?['pj'] as String? ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Edit Jadwal Kuliah' : 'Tambah Jadwal Kuliah',
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: courseNames.contains(selectedCourse)
                            ? selectedCourse
                            : (courseNames.isNotEmpty
                                ? courseNames.first
                                : null),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Mata Kuliah',
                          border: OutlineInputBorder(),
                        ),
                        items: courseNames
                            .map(
                              (course) => DropdownMenuItem<String>(
                                value: course,
                                child: Text(
                                  course,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedCourse = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_month),
                        title: const Text('Tanggal kuliah'),
                        subtitle: Text(
                          '${selectedDate.day} '
                          '${_months[selectedDate.month - 1]} '
                          '${selectedDate.year}',
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = DateUtils.dateOnly(picked);
                            });
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: startTime,
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    startTime = picked;
                                  });
                                }
                              },
                              icon: const Icon(Icons.schedule),
                              label: Text(
                                'Mulai ${startTime.format(context)}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: endTime,
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    endTime = picked;
                                  });
                                }
                              },
                              icon: const Icon(Icons.schedule_outlined),
                              label: Text(
                                'Selesai ${endTime.format(context)}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi / Ruangan',
                          hintText: 'Contoh: Lab K3',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: lecturerController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Dosen',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pjController,
                        decoration: const InputDecoration(
                          labelText: 'Nama PJ Mata Kuliah',
                          prefixIcon: Icon(Icons.groups_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (selectedCourse.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih mata kuliah terlebih dahulu.'),
                        ),
                      );
                      return;
                    }

                    final startMinutes =
                        startTime.hour * 60 + startTime.minute;
                    final endMinutes = endTime.hour * 60 + endTime.minute;

                    if (endMinutes <= startMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Jam selesai harus setelah jam mulai.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      final schedule = <String, dynamic>{
                        'id': existing?['id'] ??
                            DateTime.now().microsecondsSinceEpoch.toString(),
                        'date': DateUtils.dateOnly(selectedDate),
                        'course': selectedCourse,
                        'startTime': startTime,
                        'endTime': endTime,
                        'location': locationController.text.trim(),
                        'lecturer': lecturerController.text.trim(),
                        'pj': pjController.text.trim(),
                      };

                      if (isEditing) {
                        final index = _schedules.indexWhere(
                          (item) => item['id'] == existing['id'],
                        );
                        if (index != -1) {
                          _schedules[index] = schedule;
                        }
                      } else {
                        _schedules.add(schedule);
                      }

                      _selectedDate = DateUtils.dateOnly(selectedDate);
                      _focusedMonth = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    locationController.dispose();
    lecturerController.dispose();
    pjController.dispose();
  }

  Future<void> _deleteSchedule(Map<String, dynamic> schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal?'),
        content: Text(
          'Jadwal ${schedule['course']} akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _schedules.removeWhere(
          (item) => item['id'] == schedule['id'],
        );
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 12.0 : 24.0;

    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    final firstDayOffset =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    final activeSchedules = _schedules.where((schedule) {
      return DateUtils.isSameDay(
        schedule['date'] as DateTime,
        _selectedDate,
      );
    }).toList()
      ..sort((a, b) {
        final aTime = a['startTime'] as TimeOfDay;
        final bTime = b['startTime'] as TimeOfDay;
        return (aTime.hour * 60 + aTime.minute)
            .compareTo(bTime.hour * 60 + bTime.minute);
      });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal & Agenda Akademik',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth < 600 ? 10 : 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_months[_focusedMonth.month - 1]} '
                                  '${_focusedMonth.year}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Bulan sebelumnya',
                                onPressed: () => _changeMonth(-1),
                                icon: const Icon(Icons.chevron_left),
                              ),
                              IconButton(
                                tooltip: 'Bulan berikutnya',
                                onPressed: () => _changeMonth(1),
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _weekdays.map((day) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: daysInMonth + firstDayOffset,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (context, index) {
                              if (index < firstDayOffset) {
                                return const SizedBox.shrink();
                              }

                              final day = index - firstDayOffset + 1;
                              final date = DateTime(
                                _focusedMonth.year,
                                _focusedMonth.month,
                                day,
                              );

                              final selected =
                                  DateUtils.isSameDay(date, _selectedDate);
                              final today = DateUtils.isSameDay(
                                date,
                                DateTime.now(),
                              );

                              final hasSchedule = _schedules.any((schedule) {
                                return DateUtils.isSameDay(
                                  schedule['date'] as DateTime,
                                  date,
                                );
                              });

                              return InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                    border: today && !selected
                                        ? Border.all(
                                            color: theme.colorScheme.primary,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$day',
                                        style: TextStyle(
                                          color: selected
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSurface,
                                          fontWeight: selected || today
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      if (hasSchedule)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 3),
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? theme.colorScheme.onPrimary
                                                : theme.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                final today = DateTime.now();
                                setState(() {
                                  _focusedMonth =
                                      DateTime(today.year, today.month);
                                  _selectedDate = DateUtils.dateOnly(today);
                                });
                              },
                              icon: const Icon(Icons.today),
                              label: const Text('Kembali ke hari ini'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Agenda ${_selectedDate.day} '
                          '${_months[_selectedDate.month - 1]} '
                          '${_selectedDate.year}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _showScheduleDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (activeSchedules.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Tidak ada jadwal kuliah pada tanggal ini.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  else
                    ...activeSchedules.map((schedule) {
                      final start = schedule['startTime'] as TimeOfDay;
                      final end = schedule['endTime'] as TimeOfDay;
                      final location =
                          (schedule['location'] as String?) ?? '';
                      final lecturer =
                          (schedule['lecturer'] as String?) ?? '';
                      final pj = (schedule['pj'] as String?) ?? '';

                      final details = <String>[
                        '${_formatTime(start)} - ${_formatTime(end)}',
                        if (location.isNotEmpty) location,
                        if (lecturer.isNotEmpty) 'Dosen: $lecturer',
                        if (pj.isNotEmpty) 'PJ: $pj',
                      ];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.class_outlined),
                          ),
                          title: Text(schedule['course'] as String),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(details.join('\n')),
                          ),
                          isThreeLine: details.length > 2,
                          trailing: PopupMenuButton<String>(
                            tooltip: 'Pilihan jadwal',
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showScheduleDialog(existing: schedule);
                              } else if (value == 'delete') {
                                _deleteSchedule(schedule);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

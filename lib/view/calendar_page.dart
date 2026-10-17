
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  final List<Map<String, dynamic>> _schedules = [
    {
      'date': DateTime(2026, 9, 28),
      'time': '07:00 - 09:30',
      'course': 'Pemrograman Berbasis Platform',
      'room': 'Lab K3',
    },
    {
      'date': DateTime(2026, 9, 28),
      'time': '10:00 - 12:30',
      'course': 'Sains Komputasi',
      'room': 'R. A102',
    },
    {
      'date': DateTime(2026, 9, 30),
      'time': '13:00 - 15:30',
      'course': 'Basis Data',
      'room': 'Lab K1',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 12.0 : 24.0;

    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    // Kalender dimulai dari hari Minggu.
    final firstDayOffset =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    final activeSchedules = _schedules.where((schedule) {
      final date = schedule['date'] as DateTime;

      return DateUtils.isSameDay(date, _selectedDate);
    }).toList()
      ..sort((a, b) {
        return (a['time'] as String).compareTo(b['time'] as String);
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
                      padding: EdgeInsets.all(
                        screenWidth < 600 ? 10 : 16,
                      ),
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

                          // Nama hari.
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

                          // Tanggal kalender.
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
                                          margin: const EdgeInsets.only(top: 3),
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

                  Text(
                    'Agenda ${_selectedDate.day} '
                    '${_months[_selectedDate.month - 1]} '
                    '${_selectedDate.year}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                    ...activeSchedules.map(
                      (schedule) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.class_outlined),
                          ),
                          title: Text(
                            schedule['course'] as String,
                          ),
                          subtitle: Text(
                            '${schedule['time']} • ${schedule['room']}',
                          ),
                          isThreeLine: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

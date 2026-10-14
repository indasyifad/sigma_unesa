import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedMonth = DateTime(2026, 9, 1);
  DateTime _selectedDate = DateTime(2026, 9, 28);

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

  @override
  Widget build(BuildContext context) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstDayOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    final activeSchedules = _schedules.where((s) {
      final d = s['date'] as DateTime;
      return d.year == _selectedDate.year &&
          d.month == _selectedDate.month &&
          d.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF2C9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'JADWAL & AGENDA AKADEMIK',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {
                                setState(() {
                                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                setState(() {
                                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                          .map((d) => Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 12)))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + firstDayOffset,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.4,
                      ),
                      itemBuilder: (context, idx) {
                        if (idx < firstDayOffset) return const SizedBox.shrink();

                        final day = idx - firstDayOffset + 1;
                        final isSelected = _selectedDate.day == day &&
                            _selectedDate.month == _focusedMonth.month &&
                            _selectedDate.year == _focusedMonth.year;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF213448) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
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
            const SizedBox(height: 24),
            Text(
              'Agenda Hari Ini (${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
            ),
            const SizedBox(height: 12),
            if (activeSchedules.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Text('Tidak ada perkuliahan pada tanggal ini.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              )
            else
              Column(
                children: activeSchedules.map((s) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFEFF2C9), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.class_outlined, color: Color(0xFF213448)),
                      ),
                      title: Text(s['course'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF213448), fontSize: 14)),
                      subtitle: Text('${s['time']} • ${s['room']}'),
                    ),
                  );
                }).toList(),
              )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Halaman
          const Text(
            'Rekap Laporan Tugas & Performa',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ringkasan statistik pengerjaan tugas semester ini',
            style: TextStyle(fontSize: 13, color: Color(0xFF547792)),
          ),
          const SizedBox(height: 24),

          // 4 Card Summary
          Row(
            children: [
              _buildReportCard('Total Tugas', '14', Colors.blue, Icons.assignment_outlined),
              const SizedBox(width: 16),
              _buildReportCard('Selesai', '5', Colors.green, Icons.check_circle_outline),
              const SizedBox(width: 16),
              _buildReportCard('Pending', '7', Colors.orange, Icons.hourglass_empty),
              const SizedBox(width: 16),
              _buildReportCard('Terlambat', '2', Colors.red, Icons.error_outline),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Visual & Export Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress Penyelesaian Tugas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF547792),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.download, color: Colors.white, size: 16),
                        label: const Text('Export PDF / Excel', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Progress Bar Visual
                  const Text('Tingkat Penyelesaian: 35.7%', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF213448))),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.357,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF547792),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Table Riwayat Tugas
                  const Text(
                    'Riwayat Tugas Terbaru',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF213448)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF213448).withOpacity(0.08)),
                      columns: const [
                        DataColumn(label: Text('Nama Tugas', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Deadline', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: const [
                        DataRow(cells: [
                          DataCell(Text('Slicing UI Mobile App SIGMA')),
                          DataCell(Text('Pemrograman Berbasis Platform')),
                          DataCell(Text('Besok, 23:59')),
                          DataCell(Chip(label: Text('Urgent', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.redAccent)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Analisis Kompleksitas Algoritma')),
                          DataCell(Text('Sains Komputasi')),
                          DataCell(Text('28 Sep 2026')),
                          DataCell(Chip(label: Text('Pending', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.orange)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Makalah Bahasa Indonesia')),
                          DataCell(Text('Bahasa Indonesia')),
                          DataCell(Text('20 Sep 2026')),
                          DataCell(Chip(label: Text('Selesai', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.green)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF547792), fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(count, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
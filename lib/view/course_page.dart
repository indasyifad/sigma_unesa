import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {
        'kode': 'IF2025-1',
        'nama': 'Pemrograman Berbasis Platform',
        'dosen': 'Saifudin Yahya',
        'tugas': 3,
        'image': 'assets/pbp.jpg', // Sesuaikan jika di assets namamu pbp.png
      },
      {
        'kode': 'IF2025-2',
        'nama': 'Sains Komputasi',
        'dosen': 'Saifudin Yahya',
        'tugas': 2,
        'image': 'assets/sainskom.png',
      },
      {
        'kode': 'IF2025-3',
        'nama': 'Jaringan Komputer',
        'dosen': 'Azis Suroni',
        'tugas': 1,
        'image': 'assets/jarkom.png', // Sesuaikan jika di assets namamu jarkom.jpeg
      },
      {
        'kode': 'IF2025-4',
        'nama': 'Kecerdasan Buatan',
        'dosen': 'Ahmad Ridho',
        'tugas': 0,
        'image': 'assets/kecerdasan.png', // Sesuaikan jika di assets namamu kecerdasan.jpeg
      },
      {
        'kode': 'IF2025-5',
        'nama': 'Basis Data',
        'dosen': 'Dwi Fatimah',
        'tugas': 4,
        'image': 'assets/basisdata.png',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAFTAR MATA KULIAH',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BAGIAN GAMBAR CARD DENGAN ERROR BUILDER + FALLBACK
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          color: const Color(0xFFCBD5E1),
                          child: Image.asset(
                            course['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Cadangan jika ekstensi .png/.jpeg terbalik di web server
                              String altPath = course['image'].toString().endsWith('.png')
                                  ? course['image'].toString().replaceAll('.png', '.jpeg')
                                  : course['image'].toString().replaceAll('.jpeg', '.png');
                              
                              return Image.asset(
                                altPath,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) {
                                  return Container(
                                    color: const Color(0xFF94A3B8),
                                    child: const Center(
                                      child: Icon(Icons.menu_book, size: 40, color: Colors.white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['kode'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF547792),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course['nama'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              course['dosen'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.assignment_outlined, size: 14, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  '${course['tugas']} Tugas Aktif',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
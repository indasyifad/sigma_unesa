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
        'image': 'assets/pbp.jpg',
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
        'image': 'assets/jarkom.png',
      },
      {
        'kode': 'IF2025-4',
        'nama': 'Kecerdasan Buatan',
        'dosen': 'Ahmad Ridho',
        'tugas': 0,
        'image': 'assets/kecerdasan.png',
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
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85, // Bikin tinggi card lebih lega & proporsional
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GAMBAR HEADER DENGAN TINGGI LEBIH PAS
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          height: 110, // Ketinggian ideal biar gak makan tempat
                          width: double.infinity,
                          color: const Color(0xFFE2E8F0),
                          child: Image.asset(
                            course['image'],
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              String altPath = course['image'].toString().endsWith('.png')
                                  ? course['image'].toString().replaceAll('.png', '.jpg')
                                  : course['image'].toString().replaceAll('.jpg', '.png');
                              
                              return Image.asset(
                                altPath,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) {
                                  return Container(
                                    color: const Color(0xFF94A3B8),
                                    child: const Center(
                                      child: Icon(Icons.book_rounded, size: 36, color: Colors.white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      // DESKRIPSI & INFO MATKUL DIBIKIN RAPI & LEGA
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
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
                                  const SizedBox(height: 4),
                                  Text(
                                    course['nama'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course['dosen'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // CHIP STATUS TUGAS
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.assignment_outlined, size: 14, color: Color(0xFFEA580C)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${course['tugas']} Tugas Aktif',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFEA580C),
                                      ),
                                    ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'course_detail_page.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final matkulList = [
      {
        'kode': 'IF2025-1',
        'nama': 'Pemrograman Berbasis Platform',
        'dosen': 'Saifudin Yahya',
        'tugas': 3,
        'image':'assets/pbp.png'
      },
      {
        'kode': 'IF2025-2',
        'nama': 'Sains Komputasi',
        'dosen': 'Saifudin Yahya',
        'tugas': 2,
        'image': 'assets/sainskom.png'
      },
      {
        'kode': 'IF2025-3',
        'nama': 'Jaringan Komputer',
        'dosen': 'Azis Suroni',
        'tugas': 1,
        'image': 'assets/jarkom.png'
      },
      {
        'kode': 'IF2025-4',
        'nama': 'Kecerdasan Buatan (AI)',
        'dosen': 'Annas Maulana',
        'tugas': 4,
        'image': 'assets/kecerdasan.png'
      },
       {
        'kode': 'IF2025-5',
        'nama': 'Basis Data',
        'dosen': 'Annas Maulana',
        'tugas': 5,
        'image': 'assets/basisdata.png'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DAFTAR MATA KULIAH', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213448))),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: matkulList.length,
              itemBuilder: (context, index) {
                final item = matkulList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CourseDetailPage(courseName: item['nama'] as String)),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(item['image'] as String),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['kode'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF547792), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(item['nama'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(item['dosen'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.assignment_outlined, size: 14, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text('${item['tugas']} Tugas Aktif', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
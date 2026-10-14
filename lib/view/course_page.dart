import 'package:flutter/material.dart';
import '../controller/course_controller.dart';
import '../controller/assignment_controller.dart';
import 'course_detail_page.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CourseController.instance.courses;

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
                final activeTaskCount = AssignmentController.instance.allAssignments.where((task) => task.courseName.toLowerCase() == course.name.toLowerCase() && !task.isCompleted).length;
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(courseName: course.name))),
                  child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
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
                            course.imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              String altPath = course.imageUrl.toString().endsWith('.png')
                                  ? course.imageUrl.toString().replaceAll('.png', '.jpg')
                                  : course.imageUrl.toString().replaceAll('.jpg', '.png');
                              
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
                                    course.code,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF547792),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course.name,
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
                                    course.lecturer,
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
                                      '$activeTaskCount Tugas Aktif',
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
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
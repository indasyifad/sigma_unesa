
import 'package:flutter/material.dart';

import '../controller/course_controller.dart';
import '../controller/assignment_controller.dart';
import 'course_detail_page.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CourseController.instance.courses;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 600 ? 14.0 : 24.0;

        final columns = width >= 1250
            ? 3
            : width >= 760
                ? 2
                : 1;

        const spacing = 18.0;
        final availableWidth = width - horizontalPadding * 2;
        final cardWidth =
            (availableWidth - spacing * (columns - 1)) / columns;

        return Container(
          color: const Color(0xFFEFF2C9),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DAFTAR MATA KULIAH',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF213448),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: courses.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: columns == 1 ? 250 : 270,
                  ),
                  itemBuilder: (context, index) {
                    final course = courses[index];

                    return AnimatedBuilder(
                      animation: AssignmentController.instance,
                      builder: (context, _) {
                        final activeTaskCount =
                            AssignmentController.instance.allAssignments
                                .where(
                                  (task) =>
                                      task.courseName.toLowerCase() ==
                                          course.name.toLowerCase() &&
                                      !task.isCompleted,
                                )
                                .length;

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(
                                  courseName: course.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: cardWidth,
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
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 96,
                                  width: double.infinity,
                                  child: Image.asset(
                                    course.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      final path = course.imageUrl.toString();
                                      final alternatePath =
                                          path.endsWith('.png')
                                              ? path.replaceAll('.png', '.jpg')
                                              : path.replaceAll('.jpg', '.png');

                                      return Image.asset(
                                        alternatePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: const Color(0xFF94A3B8),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.menu_book_rounded,
                                              size: 36,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      14,
                                      12,
                                      14,
                                      12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.code,
                                          style: const TextStyle(
                                            color: Color(0xFF547792),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          course.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF172033),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF5EB),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.assignment_outlined,
                                                size: 14,
                                                color: Color(0xFFEA580C),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '$activeTaskCount Tugas Aktif',
                                                style: const TextStyle(
                                                  color: Color(0xFFEA580C),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

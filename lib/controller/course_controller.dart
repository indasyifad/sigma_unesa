import '../model/course.dart';

class CourseController {
  CourseController._();
  static final CourseController instance = CourseController._();

  final List<Course> courses = const [
    Course(id: 'IF2025-1', code: 'IF2025-1', name: 'Pemrograman Berbasis Platform', lecturer: 'Saifudin Yahya', activeTasks: 3, imageUrl: 'assets/pbp.jpg'),
    Course(id: 'IF2025-2', code: 'IF2025-2', name: 'Sains Komputasi', lecturer: 'Saifudin Yahya', activeTasks: 2, imageUrl: 'assets/sainskom.png'),
    Course(id: 'IF2025-3', code: 'IF2025-3', name: 'Jaringan Komputer', lecturer: 'Azis Suroni', activeTasks: 1, imageUrl: 'assets/jarkom.png'),
    Course(id: 'IF2025-4', code: 'IF2025-4', name: 'Kecerdasan Buatan', lecturer: 'Ahmad Ridho', activeTasks: 0, imageUrl: 'assets/kecerdasan.png'),
    Course(id: 'IF2025-5', code: 'IF2025-5', name: 'Basis Data', lecturer: 'Dwi Fatimah', activeTasks: 4, imageUrl: 'assets/basisdata.png'),
  ];
}

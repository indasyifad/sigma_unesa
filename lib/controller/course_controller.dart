import '../model/course.dart';

// Controller untuk mengelola daftar mata kuliah.
// Memisahkan data yang digunakan View dari logika pengelolaannya.

class CourseController {
  CourseController._();

  static final CourseController instance = CourseController._();

  final List<Course> courses = [
    Course(
      id: 'IF2025-1',
      code: 'PBP',
      name: 'Pemrograman Berbasis Platform',
      lecturer: 'Saifudin Yahya',
      activeTasks: 3,
      imageUrl: 'assets/pbp.jpg',
    ),
    Course(
      id: 'IF2025-2',
      code: 'SK',
      name: 'Sains Komputasi',
      lecturer: 'Saifudin Yahya',
      activeTasks: 2,
      imageUrl: 'assets/sainskom.png',
    ),
    Course(
      id: 'IF2025-3',
      code: 'JK',
      name: 'Jaringan Komputer',
      lecturer: 'Azis Suroni',
      activeTasks: 1,
      imageUrl: 'assets/jarkom.png',
    ),
    Course(
      id: 'IF2025-4',
      code: 'BD',
      name: 'Basis Data',
      lecturer: 'Anas Maulana',
      activeTasks: 4,
      imageUrl: 'assets/basisdata.png',
    ),
    Course(
      id: 'IF2025-5',
      code: 'AI',
      name: 'Kecerdasan Buatan',
      lecturer: 'Annas Maulana',
      activeTasks: 0,
      imageUrl: 'assets/kecerdasan.png',
    ),
    Course(
      id: 'IF2025-6',
      code: 'BI',
      name: 'Bahasa Indonesia',
      lecturer: 'Malik Fauzi',
      activeTasks: 0,
      imageUrl: '',
    ),
    Course(
      id: 'IF2025-7',
      code: 'BING',
      name: 'Bahasa Inggris',
      lecturer: 'Maulana Reza',
      activeTasks: 0,
      imageUrl: '',
    ),
  ];

  // Mendapatkan seluruh mata kuliah.
  List<Course> getAllCourses() {
    return List.unmodifiable(courses);
  }

  // Mencari mata kuliah berdasarkan ID.
  Course? getCourseById(String id) {
    for (final course in courses) {
      if (course.id == id) {
        return course;
      }
    }

    return null;
  }

  // Mencari mata kuliah berdasarkan nama.
  Course? getCourseByName(String name) {
    for (final course in courses) {
      if (course.name.toLowerCase() == name.toLowerCase()) {
        return course;
      }
    }

    return null;
  }

  // Mendapatkan jumlah mata kuliah.
  int get totalCourses => courses.length;
}
// Model mata kuliah SIGMA UNESA.
// Menerapkan PBO: class, atribut, constructor, getter, dan method.

class Course {
  final String id;
  final String code;
  final String name;
  final String lecturer;
  final String imageUrl;
  int activeTasks;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.lecturer,
    required this.activeTasks,
    required this.imageUrl,
  });

  // Getter untuk mendapatkan nama mata kuliah.
  String get courseName => name;

  // Setter untuk memperbarui jumlah tugas aktif.
  set taskCount(int value) {
    if (value < 0) {
      throw ArgumentError('Jumlah tugas tidak boleh negatif.');
    }
    activeTasks = value;
  }

  // Method untuk memperbarui jumlah tugas.
  void updateTaskCount(int value) {
    taskCount = value;
  }

  // Method untuk menampilkan informasi mata kuliah.
  String getInformation() {
    return '$code - $name\nDosen: $lecturer\nTugas aktif: $activeTasks';
  }
}
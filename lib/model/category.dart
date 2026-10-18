// Model kategori tugas SIGMA UNESA.
// Menerapkan class, atribut, constructor, getter, dan method.

class Category {
  final String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  // Getter nama kategori.
  String get categoryName => name;

  // Setter untuk mengubah nama kategori.
  set categoryName(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Nama kategori tidak boleh kosong.');
    }

    name = value.trim();
  }

  // Method untuk mendapatkan informasi kategori.
  String getInformation() {
    return 'Kategori: $name';
  }
}
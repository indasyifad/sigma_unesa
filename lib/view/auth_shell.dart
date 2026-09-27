import 'package:flutter/material.dart';
import 'home_page.dart';
import 'assignment_detail_page.dart';
import 'course_page.dart';
import 'report_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class AuthShell extends StatefulWidget {
  const AuthShell({super.key});

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  int _selectedIndex = 0;

  // URUTAN INDEX DIATUR SESUAI STRUKTUR MIKIR FILE DI FOLDER VIEW
  final List<Widget> _pages = [
    const HomePage(),             // Index 0: Home / Dashboard
    const AssignmentDetailPage(), // Index 1: Halaman Tugas
    const CoursePage(),           // Index 2: Mata Kuliah
    const ReportPage(),           // Index 3: Laporan
    const ProfilePage(),          // Index 4: Pengaturan Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2C9), // Tema warna Cream SIGMA UNESA
      body: Row(
        children: [
          // 1. SIDEBAR KIRI
          Container(
            width: 240,
            color: const Color(0xFF1E293B), // Navy gelap
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Header Logo Sidebar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.school, color: Colors.white, size: 26),
                    SizedBox(width: 10),
                    Text(
                      'SIGMA UNESA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // List Menu Navigasi
                _buildNavItem(0, Icons.dashboard_outlined, 'Home / Dashboard'),
                _buildNavItem(1, Icons.assignment_outlined, 'Tugas'),
                _buildNavItem(2, Icons.book_outlined, 'Mata Kuliah'),
                _buildNavItem(3, Icons.bar_chart_outlined, 'Laporan'),
                _buildNavItem(4, Icons.settings_outlined, 'Pengaturan Profil'),

                const Spacer(),

                // Profil Singkat Mahasiswa (Kiri Bawah Dengan Foto)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // FOTO PROFIL DENGAN IMAGE.ASSET
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/profil.jpeg',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/profil.jpg',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) {
                                return Container(
                                  width: 36,
                                  height: 36,
                                  color: const Color(0xFF547792),
                                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Indasyifa Debian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '25051204395',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. KONTEN UTAMA DENGAN HEADER BERSIH
          Expanded(
            child: Column(
              children: [
                // Header Atas Gelap
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: const Color(0xFF1E293B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Tombol Lonceng Notifikasi
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Halaman Utama Dinamis
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item Navigasi Sidebar
  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = _selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF547792) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          horizontalTitleGap: 12,
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
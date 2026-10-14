import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../controller/assignment_controller.dart';
import '../model/user.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'assignment_detail_page.dart';
import 'course_page.dart';
import 'report_page.dart';

class AuthShell extends StatefulWidget {
  const AuthShell({super.key});
  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  int _selectedIndex = 0;
  final AuthController _auth = AuthController.instance;
  void _onSelectTab(int index) => setState(() => _selectedIndex = index);

  @override
  void initState() {
    super.initState();
    _auth.addListener(_refresh);
    AssignmentController.instance.initializeReminders();
  }
  void _refresh() { if (mounted) setState(() {}); }
  @override
  void dispose() { _auth.removeListener(_refresh); super.dispose(); }

  void _logout() {
    _auth.logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      appBar: isMobile ? AppBar(backgroundColor: const Color(0xFF213448), iconTheme: const IconThemeData(color: Colors.white), title: const Text('SIGMA UNESA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))) : null,
      drawer: isMobile ? _buildSidebar(isDrawer: true) : null,
      body: Row(children: [
        if (!isMobile) _buildSidebar(isDrawer: false),
        Expanded(child: IndexedStack(index: _selectedIndex, children: [
          HomePage(onNavigateToTab: _onSelectTab),
          const CoursePage(),
          const AssignmentDetailPage(),
          const CalendarPage(),
          const ReportPage(),
          ProfilePage(onLogout: _logout),
          const SettingsPage(),
        ])),
      ]),
    );
  }

  Widget _avatar(User? user, {double radius = 18}) {
    final photoBytes = user?.photoBytes;
    return CircleAvatar(radius: radius, backgroundColor: const Color(0xFFEFF2C9), backgroundImage: photoBytes != null ? MemoryImage(photoBytes) : null, child: photoBytes == null ? Icon(Icons.person, size: radius + 2, color: const Color(0xFF213448)) : null);
  }

  Widget _buildSidebar({required bool isDrawer}) {
    final user = _auth.currentUser;
    return Container(width: 260, color: const Color(0xFF213448), child: Column(children: [
      const Padding(padding: EdgeInsets.symmetric(vertical: 28, horizontal: 24), child: Row(children: [Icon(Icons.school, color: Color(0xFFEFF2C9), size: 28), SizedBox(width: 12), Text('SIGMA UNESA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
      Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 12), children: [
        _buildNavItem(0, Icons.dashboard_rounded, 'Home / Dashboard', isDrawer),
        _buildNavItem(1, Icons.menu_book_rounded, 'Mata Kuliah', isDrawer),
        _buildNavItem(2, Icons.assignment_rounded, 'Tugas', isDrawer),
        _buildNavItem(3, Icons.calendar_month_rounded, 'Jadwal Saya', isDrawer),
        _buildNavItem(4, Icons.bar_chart_rounded, 'Laporan', isDrawer),
        _buildNavItem(5, Icons.person_outline, 'Profil', isDrawer),
        _buildNavItem(6, Icons.settings_rounded, 'Pengaturan', isDrawer),
      ])),
      Padding(padding: const EdgeInsets.all(16), child: InkWell(onTap: () => _onSelectTab(5), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)), child: Row(children: [
        _avatar(user), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user?.username ?? 'Pengguna', overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), Text(user?.nim ?? '', style: const TextStyle(color: Colors.white60, fontSize: 10))])),
        IconButton(icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18), onPressed: _logout),
      ])))),
    ]));
  }

  Widget _buildNavItem(int index, IconData icon, String title, bool isDrawer) {
    final selected = _selectedIndex == index;
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Container(decoration: BoxDecoration(color: selected ? const Color(0xFF547792).withValues(alpha: 0.5) : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: ListTile(leading: Icon(icon, color: Colors.white), title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)), onTap: () { _onSelectTab(index); if (isDrawer) Navigator.pop(context); })));
  }
}

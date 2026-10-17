import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _changePhoto() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (!mounted || file == null) return;

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      AuthController.instance.setProfilePhoto(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthController.instance,
      builder: (context, _) {
        final user = AuthController.instance.currentUser;
        final photo = user?.photoBytes;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: const Color(0xFFECEFCA),
                          backgroundImage:
                              photo == null ? null : MemoryImage(photo),
                          child: photo == null
                              ? const Icon(
                                  Icons.person,
                                  size: 56,
                                  color: Color(0xFF213448),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _changePhoto,
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                          ),
                          label: const Text('Ganti Foto Profil'),
                        ),
                        const SizedBox(height: 24),
                        _info('Nama Lengkap', user?.name ?? '-'),
                        _info('Email UNESA', user?.email ?? '-'),
                        _info('NIM', user?.nim ?? '-'),
                        _info('Program Studi', user?.major ?? '-'),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: widget.onLogout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Keluar'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Foto profil saat ini tersimpan selama '
                          'sesi aplikasi berlangsung.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

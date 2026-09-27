import 'package:flutter/material.dart';

class AssignmentDetailInput extends StatelessWidget {
  const AssignmentDetailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Catatan Tambahan')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'create_location_screen.dart';

class AssignLocationScreen extends StatefulWidget {
  const AssignLocationScreen({super.key});

  @override
  State<AssignLocationScreen> createState() => _AssignLocationScreenState();
}

class _AssignLocationScreenState extends State<AssignLocationScreen> {
  String? location;

  void _openCreateLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateLocationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Location"),
        actions: [
          // 🔹 Create Location button in AppBar
          TextButton.icon(
            onPressed: _openCreateLocation,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Create Location",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (location != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Selected Location: $location",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          // Neeche wala button completely remove
        ],
      ),
    );
  }
}

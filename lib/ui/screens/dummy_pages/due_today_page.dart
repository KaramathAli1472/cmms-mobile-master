import 'package:flutter/material.dart';

class DueTodayPage extends StatelessWidget {
  const DueTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy tasks list
    final List<Map<String, String>> tasks = [
      {"title": "Fix AC in Room 101", "time": "09:00 AM"},
      {"title": "Inspect Generator", "time": "10:30 AM"},
      {"title": "Replace Light Bulbs in Hall", "time": "11:00 AM"},
      {"title": "Check Fire Extinguishers", "time": "01:00 PM"},
      {"title": "Clean Water Tank", "time": "03:00 PM"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Due Today")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.task_alt, color: Colors.blue),
              title: Text(task["title"]!),
              subtitle: Text("Due: ${task["time"]}"),
            ),
          );
        },
      ),
    );
  }
}

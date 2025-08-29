import 'package:flutter/material.dart';

class PausePage extends StatelessWidget {
  const PausePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy paused notifications
    final List<Map<String, String>> pausedNotifications = [
      {"title": "Work Order #12", "reason": "Awaiting approval"},
      {"title": "Asset Update", "reason": "Pending verification"},
      {"title": "Parts Delivery", "reason": "Supplier delay"},
      {"title": "Maintenance Schedule", "reason": "Technician unavailable"},
      {"title": "System Alert", "reason": "Paused by admin"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Pause Notifications")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pausedNotifications.length,
        itemBuilder: (context, index) {
          final item = pausedNotifications[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.pause_circle_filled, color: Colors.orange),
              title: Text(item["title"]!),
              subtitle: Text(item["reason"]!),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Resuming ${item["title"]}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

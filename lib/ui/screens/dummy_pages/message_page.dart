import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy messages
    final List<Map<String, String>> messages = [
      {"sender": "Ali Abbas", "message": "Please check the new work order."},
      {"sender": "Sara Khan", "message": "Meeting at 3 PM today."},
      {"sender": "Imran Sheikh", "message": "Inventory needs update."},
      {"sender": "Fatima Noor", "message": "Maintenance report submitted."},
      {"sender": "Hassan Raza", "message": "Parts delivery delayed."},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.message, color: Colors.blue),
              title: Text(msg["sender"]!),
              subtitle: Text(msg["message"]!),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Opened message from ${msg["sender"]}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

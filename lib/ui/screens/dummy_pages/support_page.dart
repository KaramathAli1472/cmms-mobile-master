import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy support tickets
    final List<Map<String, String>> supportTickets = [
      {"title": "Login Issue", "status": "Open"},
      {"title": "App Crash", "status": "In Progress"},
      {"title": "Asset Not Found", "status": "Resolved"},
      {"title": "Parts Delivery Delay", "status": "Open"},
      {"title": "Maintenance Request", "status": "In Progress"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Support Tickets")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: supportTickets.length,
        itemBuilder: (context, index) {
          final ticket = supportTickets[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.blue),
              title: Text(ticket["title"]!),
              subtitle: Text("Status: ${ticket["status"]}"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Opening ticket: ${ticket["title"]}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

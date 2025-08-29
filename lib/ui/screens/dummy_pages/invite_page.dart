import 'package:flutter/material.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy team members
    final List<Map<String, String>> teamMembers = [
      {"name": "Ali Abbas", "role": "Technician"},
      {"name": "Sara Khan", "role": "Manager"},
      {"name": "Imran Sheikh", "role": "Supervisor"},
      {"name": "Fatima Noor", "role": "Engineer"},
      {"name": "Hassan Raza", "role": "Operator"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Invite")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          final member = teamMembers[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: Text(member["name"]!),
              subtitle: Text(member["role"]!),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invite sent to ${member["name"]}!")),
                  );
                },
                child: const Text("Invite"),
              ),
            ),
          );
        },
      ),
    );
  }
}

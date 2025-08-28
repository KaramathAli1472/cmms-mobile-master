import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  final Function(int) onTabTapped; // callback from parent

  const OverviewScreen({super.key, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Overview", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Shortcuts row
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _shortcut(Icons.today_outlined, "Due Today"),
              _shortcut(Icons.person_add_outlined, "Invite"),
              _shortcut(Icons.qr_code_scanner_outlined, "Scan"),
              _shortcut(Icons.support_agent_outlined, "Support"),
              _shortcut(Icons.notifications_paused_outlined, "Pause"),
              _shortcut(Icons.message_outlined, "Message"),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Summary cards
        _summaryCard(
          icon: Icons.assignment_outlined,
          color: Colors.blue,
          title: "Work Orders",
          subtitle: "Open: 12 • In Progress: 5 • Completed: 30",
          tabIndex: 1,
          onTapCallback: onTabTapped,
        ),
        const SizedBox(height: 12),
        _summaryCard(
          icon: Icons.campaign_outlined,
          color: Colors.orange,
          title: "Work Requests",
          subtitle: "Pending: 4 • Approved: 8",
          tabIndex: 2,
          onTapCallback: onTabTapped,
        ),
        const SizedBox(height: 12),
        _summaryCard(
          icon: Icons.widgets_outlined,
          color: Colors.green,
          title: "Assets",
          subtitle: "Total: 120 • Active: 118 • Retired: 2",
          tabIndex: 4,
          onTapCallback: onTabTapped,
        ),
        const SizedBox(height: 12),
        _summaryCard(
          icon: Icons.handyman_outlined,
          color: Colors.purple,
          title: "Parts",
          subtitle: "In Stock: 540 • Low Stock: 12",
          tabIndex: 5,
          onTapCallback: onTabTapped,
        ),

        const SizedBox(height: 20),
        Text("Work Order Status", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _statusTile("High Priority", Icons.priority_high, Colors.red, "3"),
        _statusTile("Overdue", Icons.error_outline, Colors.orange, "5"),
        _statusTile("Pending Approval", Icons.pending, Colors.blue, "2"),
        _statusTile("Completed (7d)", Icons.done_all, Colors.green, "18"),

        const SizedBox(height: 20),
        Text("To-Do List", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ExpansionTile(
          title: const Text("Assigned to Me"),
          onExpansionChanged: (expanded) {
            print("ExpansionTile 'Assigned to Me' expanded: $expanded");
          },
          children: const [
            ListTile(title: Text("Work Order #101 - Check Boiler")),
            ListTile(title: Text("Work Order #102 - Inspect Pump")),
          ],
        ),
        ExpansionTile(
          title: const Text("Assigned to My Teams"),
          onExpansionChanged: (expanded) {
            print("ExpansionTile 'Assigned to My Teams' expanded: $expanded");
          },
          children: const [
            ListTile(title: Text("Work Order #201 - Electrical Check")),
            ListTile(title: Text("Work Order #202 - HVAC Maintenance")),
          ],
        ),
        ExpansionTile(
          title: const Text("Everything Else"),
          onExpansionChanged: (expanded) {
            print("ExpansionTile 'Everything Else' expanded: $expanded");
          },
          children: const [
            ListTile(title: Text("Work Order #301 - Plumbing Issue")),
          ],
        ),

        const SizedBox(height: 20),
        Text("Recent Activity", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text("Work Order #102 completed"),
                subtitle: const Text("2 hours ago"),
                onTap: () => print("Recent Activity tapped: Work Order #102 completed"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
                title: const Text("New Work Request created"),
                subtitle: const Text("5 hours ago"),
                onTap: () => print("Recent Activity tapped: New Work Request created"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.build_circle, color: Colors.orange),
                title: const Text("Asset 'Pump A1' under maintenance"),
                subtitle: const Text("1 day ago"),
                onTap: () => print("Recent Activity tapped: Asset 'Pump A1' under maintenance"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _shortcut(IconData icon, String label) {
    print("Shortcut loaded: $label");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _summaryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required int tabIndex,
    required Function(int) onTapCallback,
  }) {
    print("SummaryCard loaded: $title");
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("SummaryCard tapped: $title, tabIndex: $tabIndex");
          onTapCallback(tabIndex); // ✅ call parent
        },
      ),
    );
  }

  static Widget _statusTile(String title, IconData icon, Color color, String count) {
    print("StatusTile loaded: $title");
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(count,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ),
    );
  }
}

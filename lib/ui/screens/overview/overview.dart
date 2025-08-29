import 'package:flutter/material.dart';
import 'package:maintboard/core/services/asset_service.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/ui/screens/qrcode_scanner/qr_scanner_screen.dart';
import 'package:maintboard/ui/screens/dummy_pages/due_today_page.dart';
import 'package:maintboard/ui/screens/dummy_pages/message_page.dart';
import 'package:maintboard/ui/screens/dummy_pages/pause_page.dart';
import 'package:maintboard/ui/screens/dummy_pages/support_page.dart';
import 'package:maintboard/ui/screens/dummy_pages/detailed_work_order_screen.dart';
import 'package:maintboard/ui/screens/work_order/work_order_list_screen.dart';
import 'package:maintboard/ui/screens/work_request/work_request_list_screen.dart';

class OverviewScreen extends StatefulWidget {
  final Function(int) onTabTapped; // Callback for HomeScreen tab switch

  const OverviewScreen({super.key, required this.onTabTapped});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  // Dummy work orders
  final List<Map<String, String>> workOrders = [
    {"title": "Fix Air Conditioner", "status": "In Progress", "assignedTo": "Ali Abbas"},
    {"title": "Replace Light Bulb", "status": "Pending", "assignedTo": "Sara Khan"},
    {"title": "Inspect Fire Extinguisher", "status": "Completed", "assignedTo": "Unassigned"},
    {"title": "Repair Door Lock", "status": "High Priority", "assignedTo": "Ali Abbas"},
  ];

  // Dummy To-Do List with ID, Priority, Assigned To
  final List<Map<String, String>> todoList = [
    {
      "task": "Check Air Conditioner",
      "id": "WD-101",
      "priority": "High",
      "status": "In Progress",
      "assignedTo": "Ali Abbas"
    },
    {
      "task": "Replace Light Bulb",
      "id": "WD-102",
      "priority": "Medium",
      "status": "Pending",
      "assignedTo": "Ali Abbas"
    },
    {
      "task": "Inspect Fire Extinguisher",
      "id": "WD-103",
      "priority": "Low",
      "status": "Completed",
      "assignedTo": "Ali Abbas"
    },
    {
      "task": "Repair Door Lock",
      "id": "WD-104",
      "priority": "High",
      "status": "In Progress",
      "assignedTo": "Ali Abbas"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shortcut Bar
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _shortcut(context, Icons.today_outlined, "Due Today", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DueTodayPage()));
                  }),
                  _shortcut(context, Icons.qr_code_scanner_outlined, "Scan", () {
                    _openQrScanner(context);
                  }),
                  _shortcut(context, Icons.support_agent_outlined, "Support", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()));
                  }),
                  _shortcut(context, Icons.notifications_paused_outlined, "Pause", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PausePage()));
                  }),
                  _shortcut(context, Icons.message_outlined, "Message", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagePage()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Work Order Status Grid
            Text(
              "Work Order Status",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _statusCardWithArrow(
                  "High Priority",
                  Icons.arrow_upward_rounded,
                  Colors.red,
                  "3",
                  subtitle: "Work Orders",
                  onTap: () {
                    widget.onTabTapped(1); // Switch to Work Orders tab
                  },
                ),
                _statusCardWithArrow(
                  "Overdue",
                  Icons.access_time,
                  Colors.red,
                  "5",
                  subtitle: "Work Orders",
                  onTap: () {
                    widget.onTabTapped(1);
                  },
                ),
                _statusCardWithArrow(
                  "Pending Approval",
                  Icons.archive,
                  Colors.orangeAccent,
                  "2",
                  subtitle: "Request",
                  onTap: () {
                    widget.onTabTapped(2); // Work Requests tab
                  },
                ),
                _statusCardWithArrow(
                  "Completed (7d)",
                  Icons.done,
                  Colors.green,
                  "18",
                  subtitle: "This Week",
                  onTap: () {
                    widget.onTabTapped(1);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // TO-DO LIST
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TO-DO LIST",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...todoList.map((todo) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task title and priority in one line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                todo["task"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: todo["status"] == "Completed"
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: todo["priority"] == "High"
                                    ? Colors.red.withOpacity(0.2)
                                    : todo["priority"] == "Medium"
                                    ? Colors.orange.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                todo["priority"]!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: todo["priority"] == "High"
                                      ? Colors.red
                                      : todo["priority"] == "Medium"
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todo["id"]!,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: todo["status"] == "Completed"
                                ? Colors.green.withOpacity(0.2)
                                : todo["status"] == "In Progress"
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            todo["status"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: todo["status"] == "Completed"
                                  ? Colors.green
                                  : todo["status"] == "In Progress"
                                  ? Colors.blue
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openCreateWorkOrder(context);
        },
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          "Create",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 1, // bilkul flat
        extendedPadding: const EdgeInsets.symmetric(horizontal: 14),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // QR Scanner
  static void _openQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScannerScreen(
          onScanned: (qrUrl) async {
            try {
              final tokenResponse = await AssetService().fetchAssetByQRCodeUrl(qrUrl);
              final asset = AssetResponse.fromToken(tokenResponse);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error scanning QR: $e")));
            }
          },
        ),
      ),
    );
  }

  // Modal to show creation options without lines
  void _openCreateWorkOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "What would you like to create",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Options without divider
            ListTile(
              leading: const Icon(Icons.assignment_outlined, color: Colors.blue),
              title: const Text("Work Order"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context); // Close modal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DetailedWorkOrderScreen(), // Aapka form screen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets_outlined, color: Colors.orange),
              title: const Text("Asset"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Asset creation screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined, color: Colors.green),
              title: const Text("Location"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Location creation screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.handyman_outlined, color: Colors.red),
              title: const Text("Part"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Part creation screen
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _shortcut(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _statusCardWithArrow(
      String title,
      IconData icon,
      Color color,
      String count, {
        String? subtitle,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    count,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

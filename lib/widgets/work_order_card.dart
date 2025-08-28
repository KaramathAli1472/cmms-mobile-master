import 'package:flutter/material.dart';
import 'package:maintboard/core/services/date_time_service.dart';

class WorkOrderCard extends StatelessWidget {
  final String title;
  final String workOrderNumber;
  final int priorityID;
  final int workOrderStatusID;
  final int workOrderID;
  final String assetName;
  final DateTime dueDate;
  final VoidCallback? onTap;

  const WorkOrderCard({
    super.key,
    required this.title,
    required this.workOrderNumber,
    required this.priorityID,
    required this.workOrderStatusID,
    required this.workOrderID,
    required this.assetName,
    required this.dueDate,
    this.onTap,
  });

  Color _getPriorityColor() {
    switch (priorityID) {
      case 1:
        return Colors.red; // Critical
      case 2:
        return Colors.orange; // Medium
      case 3:
        return Colors.green; // Low
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText() {
    switch (priorityID) {
      case 1:
        return 'Critical';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Low';
    }
  }

  Color _getStatusColor() {
    switch (workOrderStatusID) {
      case 1:
        return Colors.blue; // Open
      case 2:
        return Colors.orange; // In Progress
      case 3:
        return Colors.green; // Closed
      default:
        return Colors.blue;
    }
  }

  String _getStatusText() {
    switch (workOrderStatusID) {
      case 1:
        return 'Open';
      case 2:
        return 'In Progress';
      case 3:
        return 'Closed';
      default:
        return 'Open';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#$workOrderNumber',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.widgets_outlined,
                          size: 18, color: Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          assetName,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${DateTimeService.formatUtcToLocalDateTime(dueDate)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _getPriorityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getPriorityText(),
                          style: TextStyle(
                              color: _getPriorityColor(),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

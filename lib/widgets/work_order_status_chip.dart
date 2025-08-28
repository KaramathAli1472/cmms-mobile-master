import 'package:flutter/material.dart';
import 'package:maintboard/core/services/work_order_status_cache_service.dart';
import 'package:maintboard/widgets/tonal_chip.dart';

class WorkOrderStatusChip extends StatelessWidget {
  final int workOrderStatusID;

  const WorkOrderStatusChip({super.key, required this.workOrderStatusID});

  @override
  Widget build(BuildContext context) {
    final status =
        WorkOrderStatusCacheService().getStatusByID(workOrderStatusID);
    if (status == null) return const SizedBox.shrink();

    final controlID = status.controlEnum.controlID;

    final statusMap = {
      1: {
        'label': 'Backlog',
        'icon': Icons.schedule,
        'color': Colors.blue,
      },
      2: {
        'label': 'In Progress',
        'icon': Icons.timelapse,
        'color': Colors.orange,
      },
      3: {
        'label': 'Completed',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
      },
      5: {
        'label': 'Closed',
        'icon': Icons.lock_outline,
        'color': Colors.grey,
      },
    };

    final config = statusMap[controlID];
    if (config == null) return const SizedBox.shrink();

    final String label = config['label'] as String;
    final IconData icon = config['icon'] as IconData;
    final Color baseColor = config['color'] as Color;

    return TonalChip(
      baseColor: baseColor,
      labelWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black87),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:maintboard/core/services/priority_cache_service.dart';
import 'package:maintboard/widgets/tonal_chip.dart';

class PriorityIndicator extends StatelessWidget {
  final int priorityID;

  const PriorityIndicator({super.key, required this.priorityID});

  @override
  Widget build(BuildContext context) {
    final priority = PriorityCacheService().getPriorityByID(priorityID);
    if (priority == null) return const SizedBox.shrink();

    final String priorityName = priority.priorityName;

    // Base colors for each priority
    final Map<String, Color> priorityBaseColors = {
      'Critical': Colors.red,
      'High': Colors.orange,
      'Medium': Colors.blue,
      'Low': Colors.green,
    };

    final Color baseColor = priorityBaseColors[priorityName] ?? Colors.grey;

    return TonalChip(
      label: priorityName,
      baseColor: baseColor,
    );
  }
}

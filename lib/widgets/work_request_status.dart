import 'package:flutter/material.dart';
import 'package:maintboard/core/helper.dart';
import 'package:maintboard/widgets/tonal_chip.dart';

class WorkRequestStatusIndicator extends StatelessWidget {
  final int workRequestStatusID;

  const WorkRequestStatusIndicator({
    super.key,
    required this.workRequestStatusID,
  });

  @override
  Widget build(BuildContext context) {
    final String status = getWorkRequestStatusText(workRequestStatusID);
    final Color baseColor = getWorkRequestStatusColor(workRequestStatusID);

    return TonalChip(
      baseColor: baseColor,
      labelWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: baseColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

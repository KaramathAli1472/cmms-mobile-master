// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_history_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/widgets/icon_text_row.dart';
import 'package:maintboard/widgets/priority_indicator.dart';
import 'package:maintboard/widgets/work_order_status_chip.dart';

class WorkOrderHistoryCard extends StatelessWidget {
  final AssetHistoryResponse workOrder;
  final VoidCallback? onTap;

  const WorkOrderHistoryCard({
    super.key,
    required this.workOrder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    workOrder.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Work Order Number
                  Text(
                    '#${workOrder.workOrderNumber}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Asset + Requested Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTextRow(
                        icon: Icons.widgets_outlined,
                        text: workOrder.assetName,
                      ),
                      const SizedBox(height: 2),
                      IconTextRow(
                        icon: Icons.calendar_today_outlined,
                        text: DateTimeService.formatUtcToLocalDateTime(
                            workOrder.requestedDT),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WorkOrderStatusChip(
                        workOrderStatusID: workOrder.workOrderStatusID,
                      ),
                      PriorityIndicator(priorityID: workOrder.priorityID),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron icon
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

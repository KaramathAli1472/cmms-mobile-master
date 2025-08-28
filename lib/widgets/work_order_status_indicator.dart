// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/enums/work_order_status_enum.dart';
import 'package:maintboard/core/models/work_order_status/work_order_status_response.dart';
import 'package:maintboard/core/services/work_order_status_cache_service.dart';
import 'package:maintboard/widgets/backlog_status_dialog.dart';
import 'package:maintboard/widgets/closed_status_dialog.dart';
import 'package:maintboard/widgets/completed_status_dialog.dart';
import 'package:maintboard/widgets/inprogress_status_dialog.dart';

class WorkOrderStatusIndicator extends StatelessWidget {
  final int workOrderStatusID;
  final int workOrderID;
  final VoidCallback? onStatusChanged;

  const WorkOrderStatusIndicator({
    super.key,
    required this.workOrderStatusID,
    required this.workOrderID,
    this.onStatusChanged,
  });

  void _openStatusDialog(
    BuildContext context,
    WorkOrderStatusControlEnum controlEnum,
    int newStatusID,
    String statusName,
  ) {
    final dialog = switch (controlEnum) {
      WorkOrderStatusControlEnum.backlog => BacklogStatusDialog(
          statusName: statusName,
          workOrderID: workOrderID,
          newStatusID: newStatusID,
          onStatusChanged: onStatusChanged ?? () {},
        ),
      WorkOrderStatusControlEnum.inProgress => InProgressStatusDialog(
          statusName: statusName,
          workOrderID: workOrderID,
          newStatusID: newStatusID,
          onStatusChanged: onStatusChanged ?? () {},
        ),
      WorkOrderStatusControlEnum.completed => CompletedStatusDialog(
          workOrderID: workOrderID,
          statusID: newStatusID,
          onStatusChanged: onStatusChanged ?? () {},
          siteID: 0,
        ),
      WorkOrderStatusControlEnum.closed => ClosedStatusDialog(
          statusName: statusName,
          workOrderID: workOrderID,
          newStatusID: newStatusID,
          onStatusChanged: onStatusChanged ?? () {},
        ),
    };

    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    final WorkOrderStatusResponse? currentStatus =
        WorkOrderStatusCacheService().getStatusByID(workOrderStatusID);

    if (currentStatus == null) {
      return const Text(
        "Unknown Status",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );
    }

    // ✅ Don't show status buttons if already closed
    if (currentStatus.controlEnum == WorkOrderStatusControlEnum.closed) {
      return const SizedBox.shrink();
    }

    final List<WorkOrderStatusResponse> allStatuses =
        WorkOrderStatusCacheService().getAllStatuses();

    final List<WorkOrderStatusResponse> backlog = allStatuses
        .where((s) => s.controlEnum == WorkOrderStatusControlEnum.backlog)
        .toList();
    final List<WorkOrderStatusResponse> inProgress = allStatuses
        .where((s) => s.controlEnum == WorkOrderStatusControlEnum.inProgress)
        .toList();
    final List<WorkOrderStatusResponse> completed = allStatuses
        .where((s) => s.controlEnum == WorkOrderStatusControlEnum.completed)
        .toList();
    final List<WorkOrderStatusResponse> closed = allStatuses
        .where((s) => s.controlEnum == WorkOrderStatusControlEnum.closed)
        .toList();

    Widget buildButtonGroup(
      List<WorkOrderStatusResponse> group,
      Color color,
    ) {
      final WorkOrderStatusControlEnum groupControl = group.first.controlEnum;
      final bool isActive = currentStatus.controlEnum == groupControl;

      final String label = isActive
          ? currentStatus.workOrderStatusName
          : group.first.workOrderStatusName;

      return Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (group.length == 1) {
              _openStatusDialog(
                context,
                group.first.controlEnum,
                group.first.workOrderStatusID,
                group.first.workOrderStatusName,
              );
            } else {
              showModalBottomSheet(
                context: context,
                builder: (_) => ListView(
                  children: group
                      .map(
                        (s) => ListTile(
                          title: Text(s.workOrderStatusName),
                          onTap: () {
                            Navigator.pop(context);
                            _openStatusDialog(
                              context,
                              s.controlEnum,
                              s.workOrderStatusID,
                              s.workOrderStatusName,
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? color : Colors.white,
            foregroundColor: isActive ? Colors.white : color,
            minimumSize: const Size(double.infinity, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive) ...[
                const Icon(Icons.check, size: 18),
                const SizedBox(width: 6),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            buildButtonGroup(backlog, Colors.blue),
            const SizedBox(width: 12),
            buildButtonGroup(inProgress, Colors.orange),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            buildButtonGroup(completed, Colors.green),
            const SizedBox(width: 12),
            buildButtonGroup(closed, Colors.black),
          ],
        ),
      ],
    );
  }
}

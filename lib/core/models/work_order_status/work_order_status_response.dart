// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/enums/work_order_status_enum.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class WorkOrderStatusResponse {
  final int workOrderStatusID;
  final String workOrderStatusName;
  final WorkOrderStatusControlEnum controlEnum;
  final int sortOrder;

  WorkOrderStatusResponse({
    required this.workOrderStatusID,
    required this.workOrderStatusName,
    required this.controlEnum,
    required this.sortOrder,
  });

  factory WorkOrderStatusResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderStatusResponse(
      workOrderStatusID: requireField<int>(json, 'workOrderStatusID'),
      workOrderStatusName: requireField<String>(json, 'workOrderStatusName'),
      controlEnum: WorkOrderStatusControlEnum.fromControlID(
        requireField<int>(json, 'controlID'),
      ),
      sortOrder: requireField<int>(json, 'sortOrder'),
    );
  }

  static List<WorkOrderStatusResponse> fromJsonList(List<dynamic> jsonList) {
    final List<WorkOrderStatusResponse> statuses =
        jsonList.map((json) => WorkOrderStatusResponse.fromJson(json)).toList();

    const List<int> controlOrder = [1, 2, 3, 5]; // matching enum values

    statuses.sort((a, b) {
      final int indexA = controlOrder.indexOf(a.controlEnum.controlID);
      final int indexB = controlOrder.indexOf(b.controlEnum.controlID);
      return (indexA == -1 ? 999 : indexA)
          .compareTo(indexB == -1 ? 999 : indexB);
    });

    return statuses;
  }

  IconData getIcon() {
    switch (controlEnum) {
      case WorkOrderStatusControlEnum.backlog:
        return Icons.access_time;
      case WorkOrderStatusControlEnum.inProgress:
        return Icons.history_toggle_off;
      case WorkOrderStatusControlEnum.completed:
        return Icons.check_circle_outline;
      case WorkOrderStatusControlEnum.closed:
        return Icons.lock_outline;
    }
  }
}

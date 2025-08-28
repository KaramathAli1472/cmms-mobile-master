// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class WorkOrderTimeAddRequest {
  final int workOrderID;
  final String resources;
  final int timeSpent;
  final String remarks;

  WorkOrderTimeAddRequest({
    required this.workOrderID,
    required this.resources,
    required this.timeSpent,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderID': workOrderID,
      'resources': resources,
      'timeSpent': timeSpent,
      'remarks': remarks,
    };
  }
}

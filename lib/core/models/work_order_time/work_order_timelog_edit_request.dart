// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class WorkOrderTimeEditRequest {
  final int workOrderID;
  final int workOrderTimeLogID;
  final int loginID;
  final int timeSpent;
  final double hourlyRate;
  final String remarks;

  WorkOrderTimeEditRequest({
    required this.workOrderID,
    required this.workOrderTimeLogID,
    required this.loginID,
    required this.timeSpent,
    required this.hourlyRate,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderID': workOrderID,
      'workOrderTimeLogID': workOrderTimeLogID,
      'loginID': loginID,
      'timeSpent': timeSpent,
      'hourlyRate': hourlyRate,
      'remarks': remarks,
    };
  }
}

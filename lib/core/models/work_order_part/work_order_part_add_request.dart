// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class WorkOrderPartAddRequest {
  final int workOrderID;
  final String parts;
  final int quantityUsed;
  final String remarks;
  final int installedLoginID;

  WorkOrderPartAddRequest({
    required this.workOrderID,
    required this.parts,
    required this.quantityUsed,
    required this.remarks,
    required this.installedLoginID,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderID': workOrderID,
      'parts': parts,
      'quantityUsed': quantityUsed,
      'remarks': remarks,
      'installedLoginID': installedLoginID,
    };
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class WorkOrderPartEditRequest {
  final int workOrderID;
  final int workOrderPartID;
  final int partID;
  final int installedLoginID;
  final int quantityPlanned;
  final int quantityUsed;
  final double unitCostAtUse;
  final String remarks;

  WorkOrderPartEditRequest({
    required this.workOrderID,
    required this.workOrderPartID,
    required this.partID,
    required this.installedLoginID,
    required this.quantityPlanned,
    required this.quantityUsed,
    required this.unitCostAtUse,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderID': workOrderID,
      'workOrderPartID': workOrderPartID,
      'partID': partID,
      'installedLoginID': installedLoginID,
      'quantityPlanned': quantityPlanned,
      'quantityUsed': quantityUsed,
      'unitCostAtUse': unitCostAtUse,
      'remarks': remarks,
    };
  }
}

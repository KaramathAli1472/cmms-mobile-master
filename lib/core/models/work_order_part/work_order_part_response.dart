// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class WorkOrderPartResponse {
  final int workOrderPartID;
  final int workOrderID;
  final int partID;
  final int quantityUsed;
  final int installedLoginID;
  final DateTime modifiedDT;

  WorkOrderPartResponse({
    required this.workOrderPartID,
    required this.workOrderID,
    required this.partID,
    required this.quantityUsed,
    required this.installedLoginID,
    required this.modifiedDT,
  });

  factory WorkOrderPartResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderPartResponse(
      workOrderPartID: requireField<int>(json, 'workOrderPartID'),
      workOrderID: requireField<int>(json, 'workOrderID'),
      partID: requireField<int>(json, 'partID'),
      quantityUsed: requireField<int>(json, 'quantityUsed'),
      installedLoginID: requireField<int>(json, 'installedLoginID'),
      modifiedDT: DateTime.parse(requireField<String>(json, 'modifiedDT')),
    );
  }

  static List<WorkOrderPartResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => WorkOrderPartResponse.fromJson(json))
        .toList();
  }
}

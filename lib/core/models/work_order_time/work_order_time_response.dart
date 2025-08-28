// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class WorkOrderTimeResponse {
  final int workOrderTimeLogID;
  final int hourlyRate;

  WorkOrderTimeResponse({
    required this.workOrderTimeLogID,
    required this.hourlyRate,
  });

  factory WorkOrderTimeResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderTimeResponse(
      workOrderTimeLogID: requireField<int>(json, 'workOrderTimeLogID'),
      hourlyRate: requireField<int>(json, 'hourlyRate'),
    );
  }

  static List<WorkOrderTimeResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => WorkOrderTimeResponse.fromJson(json))
        .toList();
  }
}

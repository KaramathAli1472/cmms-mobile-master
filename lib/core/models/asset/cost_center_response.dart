// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class CostCenterResponse {
  final int costCenterID;
  final String costCenterName;
  final String? description;
  final String? color;
  final int? assetsCount;
  final bool isActive;
  final DateTime modifiedDT;

  CostCenterResponse({
    required this.costCenterID,
    required this.costCenterName,
    this.description,
    this.color,
    this.assetsCount,
    required this.isActive,
    required this.modifiedDT,
  });

  factory CostCenterResponse.fromJson(Map<String, dynamic> json) {
    return CostCenterResponse(
      costCenterID: requireField<int>(json, 'costCenterID'),
      costCenterName: requireField<String>(json, 'costCenterName'),
      description: json['description'],
      color: json['color'],
      assetsCount: json['assetsCount'],
      isActive: requireField<bool>(json, 'isActive'),
      modifiedDT: DateTime.parse(requireField<String>(json, 'modifiedDT')),
    );
  }
}

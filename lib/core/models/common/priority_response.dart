// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class PriorityResponse {
  final int priorityID;
  final String priorityName;
  final String icon;
  final String color;

  PriorityResponse({
    required this.priorityID,
    required this.priorityName,
    required this.icon,
    required this.color,
  });

  factory PriorityResponse.fromJson(Map<String, dynamic> json) {
    return PriorityResponse(
      priorityID: requireField<int>(json, 'priorityID'),
      priorityName: requireField<String>(json, 'priorityName'),
      icon: requireField<String>(json, 'icon'),
      color: requireField<String>(json, 'color'),
    );
  }
}

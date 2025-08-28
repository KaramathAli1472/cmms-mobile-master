// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class LocationResponse {
  final int locationID;
  final String locationName;
  final String? description;
  final int siteID;
  final int? assetsCount;
  final bool isActive;
  final DateTime modifiedDT;

  LocationResponse({
    required this.locationID,
    required this.locationName,
    this.description,
    required this.siteID,
    this.assetsCount,
    required this.isActive,
    required this.modifiedDT,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      locationID: requireField<int>(json, 'locationID'),
      locationName: requireField<String>(json, 'locationName'),
      description: json['description'],
      siteID: requireField<int>(json, 'siteID'),
      assetsCount: json['assetsCount'],
      isActive: requireField<bool>(json, 'isActive'),
      modifiedDT: DateTime.parse(requireField<String>(json, 'modifiedDT')),
    );
  }
}

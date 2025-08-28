// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class AssetTypeResponse {
  final int assetTypeID;
  final String assetTypeName;
  final int? assetsCount;
  final String? description;
  final bool isActive;
  final DateTime modifiedDT;

  AssetTypeResponse({
    required this.assetTypeID,
    required this.assetTypeName,
    this.assetsCount,
    this.description,
    required this.isActive,
    required this.modifiedDT,
  });

  factory AssetTypeResponse.fromJson(Map<String, dynamic> json) {
    return AssetTypeResponse(
      assetTypeID: requireField<int>(json, 'assetTypeID'),
      assetTypeName: requireField<String>(json, 'assetTypeName'),
      assetsCount: json['assetsCount'],
      description: json['description'],
      isActive: requireField<bool>(json, 'isActive'),
      modifiedDT: DateTime.parse(requireField<String>(json, 'modifiedDT')),
    );
  }
}

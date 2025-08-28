// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/common/attachment_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class QueryAssetByTokenResponse {
  final int assetID;
  final String assetName;
  final String? assetCode;
  final String? serialNumber;
  final String? model;
  final String? manufacturer;
  final List<String> fullLocationPath;
  final List<String> fullAssetPath;
  final AttachmentResponse? photo;

  QueryAssetByTokenResponse({
    required this.assetID,
    required this.assetName,
    this.assetCode,
    this.serialNumber,
    this.model,
    this.manufacturer,
    required this.fullLocationPath,
    required this.fullAssetPath,
    this.photo,
  });

  factory QueryAssetByTokenResponse.fromJson(Map<String, dynamic> json) {
    return QueryAssetByTokenResponse(
      assetID: requireField<int>(json, 'assetID'),
      assetName: requireField<String>(json, 'assetName'),
      assetCode: json['assetCode'],
      serialNumber: json['serialNumber'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      fullLocationPath: List<String>.from(json['fullLocationPath'] ?? []),
      fullAssetPath: List<String>.from(json['fullAssetPath'] ?? []),
      photo: json['photo'] != null
          ? AttachmentResponse.fromJson(json['photo'])
          : null,
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/asset/asset_type_response.dart';
import 'package:maintboard/core/models/asset/query_asset_by_token_response.dart';
import 'package:maintboard/core/models/common/attachment_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class AssetResponse {
  final int assetID;
  final String assetName;
  final String? description;
  final int? locationID;
  final String? manufacturer;
  final String? supplier;
  final String? serialNumber;
  final String? assetCode;
  final String? model;
  final AssetTypeResponse? assetType;
  final AttachmentResponse? photo;

  // ✅ Added for QR-based usage
  final List<String>? fullAssetPath;
  final List<String>? fullLocationPath;

  AssetResponse({
    required this.assetID,
    required this.assetName,
    this.description,
    this.locationID,
    this.manufacturer,
    this.supplier,
    this.serialNumber,
    this.assetCode,
    this.model,
    this.assetType,
    this.photo,
    this.fullAssetPath,
    this.fullLocationPath,
  });

  factory AssetResponse.fromJson(Map<String, dynamic> json) {
    return AssetResponse(
      assetID: requireField<int>(json, 'assetID'),
      assetName: requireField<String>(json, 'assetName'),
      description: json['description'],
      locationID: json['locationID'],
      manufacturer: json['manufacturer'],
      supplier: json['supplier'],
      serialNumber: json['serialNumber'],
      assetCode: json['assetCode'],
      model: json['model'],
      assetType: json['assetType'] != null
          ? AssetTypeResponse.fromJson(json['assetType'])
          : null,
      photo: json['photo'] != null
          ? AttachmentResponse.fromJson(json['photo'])
          : null,
      fullAssetPath: (json['fullAssetPath'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      fullLocationPath: (json['fullLocationPath'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  factory AssetResponse.fromToken(QueryAssetByTokenResponse tokenResponse) {
    return AssetResponse(
      assetID: tokenResponse.assetID,
      assetName: tokenResponse.assetName,
      assetCode: tokenResponse.assetCode,
      serialNumber: tokenResponse.serialNumber,
      model: tokenResponse.model,
      manufacturer: tokenResponse.manufacturer,
      fullAssetPath: tokenResponse.fullAssetPath,
      fullLocationPath: tokenResponse.fullLocationPath,
    );
  }

  // ✅ Display-friendly getters
  String get fullAssetPathDisplay =>
      (fullAssetPath?.isNotEmpty ?? false) ? fullAssetPath!.join(' > ') : '-';

  String get fullLocationPathDisplay => (fullLocationPath?.isNotEmpty ?? false)
      ? fullLocationPath!.join(' > ')
      : '-';
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class PartResponse {
  final int partID;
  final String partName;
  final String? description;
  final int storeRoomID;
  final String storeRoomName;
  final int partTypeID;
  final String? defaultImageUrl;
  final int quantity;
  final int minimumQuantity;
  final int reOrderLevel;
  final int reOrderQuantity;
  final int quantityUsed;
  final int quantityAvailable;
  final double unitCost;
  final String? partCode;
  final String? manufacturer;
  final String? supplier;
  final String? serialNumber;
  final String? model;
  final int leadTime;
  final bool isActive;
  final bool isCritical;
  final DateTime modifiedDT;

  PartResponse({
    required this.partID,
    required this.partName,
    this.description,
    required this.storeRoomID,
    required this.storeRoomName,
    required this.partTypeID,
    this.defaultImageUrl,
    required this.quantity,
    required this.minimumQuantity,
    required this.reOrderLevel,
    required this.reOrderQuantity,
    required this.quantityUsed,
    required this.quantityAvailable,
    required this.unitCost,
    this.partCode,
    this.manufacturer,
    this.supplier,
    this.serialNumber,
    this.model,
    required this.leadTime,
    required this.isActive,
    required this.isCritical,
    required this.modifiedDT,
  });

  factory PartResponse.fromJson(Map<String, dynamic> json) {
    return PartResponse(
      partID: requireField<int>(json, 'partID'),
      partName: requireField<String>(json, 'partName'),
      description: json['description'],
      storeRoomID: requireField<int>(json, 'storeRoomID'),
      storeRoomName: requireField<String>(json, 'storeRoomName'),
      partTypeID: requireField<int>(json, 'partTypeID'),
      defaultImageUrl: json['defaultImageUrl'],
      quantity: requireField<int>(json, 'quantity'),
      minimumQuantity: requireField<int>(json, 'minimumQuantity'),
      reOrderLevel: requireField<int>(json, 'reOrderLevel'),
      reOrderQuantity: requireField<int>(json, 'reOrderQuantity'),
      quantityUsed: requireField<int>(json, 'quantityUsed'),
      quantityAvailable: requireField<int>(json, 'quantityAvailable'),
      unitCost: (requireField<num>(json, 'unitCost')).toDouble(),
      partCode: json['partCode'],
      manufacturer: json['manufacturer'],
      supplier: json['supplier'],
      serialNumber: json['serialNumber'],
      model: json['model'],
      leadTime: requireField<int>(json, 'leadTime'),
      isActive: requireField<bool>(json, 'isActive'),
      isCritical: requireField<bool>(json, 'isCritical'),
      modifiedDT: DateTime.parse(requireField<String>(json, 'modifiedDT')),
    );
  }
}

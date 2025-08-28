// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/core/services/part_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

class PartCacheService {
  // Singleton Instance
  PartCacheService._internal();
  static final PartCacheService _instance = PartCacheService._internal();
  factory PartCacheService() => _instance;

  // In-memory cache for parts
  List<PartResponse> _parts = [];

  /// Loads parts from a list
  void loadParts(List<PartResponse> parts) {
    _parts = parts;
  }

  /// Loads parts from the API
  Future<void> loadPartsFromService() async {
    try {
      final int? siteID = await SharedPreferenceService.getCurrentSiteID();

      final parts = await PartService().fetchPartList(
        queryParams: {
          'pageNumber': 0,
          'rowsPerPage': 1000,
          'siteID': siteID,
          'sort': 'PartName_ASC',
        },
      );

      loadParts(parts); // Store parts in cache
    } catch (e, stackTrace) {
      SnackbarService.showError("Failed to load parts. Please try again.");
    }
  }

  /// Checks if the cache is populated
  bool hasData() => _parts.isNotEmpty;

  /// Fetches all parts
  List<PartResponse> getParts() => _parts;

  /// Default "Unknown" part
  static final PartResponse unknownPart = PartResponse(
    partID: -1,
    partName: "Unknown",
    description: "Part not found",
    storeRoomID: -1,
    storeRoomName: "Unknown",
    partTypeID: -1,
    defaultImageUrl: null,
    quantity: 0,
    minimumQuantity: 0,
    reOrderLevel: 0,
    reOrderQuantity: 0,
    quantityUsed: 0,
    quantityAvailable: 0,
    unitCost: 0.0,
    partCode: null,
    manufacturer: null,
    supplier: null,
    serialNumber: null,
    model: null,
    leadTime: 0,
    isActive: false,
    isCritical: false,
    modifiedDT: DateTime(2000, 1, 1),
  );

  /// Fetches a part by ID
  PartResponse getPartByID(int partID) {
    return _parts.firstWhere(
      (part) => part.partID == partID,
      orElse: () => unknownPart, // Returns a default part if not found
    );
  }

  /// Clears the part cache
  void clearCache() {
    _parts = [];
  }
}

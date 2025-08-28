// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:maintboard/core/models/common/priority_response.dart';

class PriorityCacheService {
  // Singleton Instance
  PriorityCacheService._internal();

  static final PriorityCacheService _instance =
      PriorityCacheService._internal();
  factory PriorityCacheService() => _instance;

  // In-memory cache for priorities
  List<PriorityResponse> _priorities = [];

  /// Loads priorities from a JSON string
  void loadPriorities(String json) {
    final decodedData = jsonDecode(json) as Map<String, dynamic>;
    _priorities = List<PriorityResponse>.from(
      decodedData['data'].map((item) => PriorityResponse.fromJson(item)),
    );
  }

  /// Loads priorities from the assets file
  Future<void> loadPrioritiesFromAssets() async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/priorities.json');

    loadPriorities(jsonString);
  }

  /// Fetches all priorities
  List<PriorityResponse> getPriorities() {
    return _priorities;
  }

  /// Fetches a priority by ID
  PriorityResponse? getPriorityByID(int priorityID) {
    try {
      return _priorities.firstWhere(
        (priority) => priority.priorityID == priorityID,
      );
    } catch (e) {
      return null;
    }
  }

  /// Clears the priority cache
  void clearCache() {
    _priorities = [];
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/asset/location_response.dart';
import 'package:maintboard/core/services/location_service.dart';

class LocationCacheService {
  // Singleton Instance
  LocationCacheService._internal();
  static final LocationCacheService _instance =
      LocationCacheService._internal();
  factory LocationCacheService() => _instance;

  // In-memory cache for categories
  List<LocationResponse> _locations = [];

  /// Loads categories from a list
  void loadLocations(List<LocationResponse> locations) {
    _locations = locations;
  }

  /// Loads categories from the API
  Future<void> loadLocationsFromService() async {
    final categories = await LocationService().fetchLocationList();
    loadLocations(categories);
  }

  /// Checks if the cache is populated
  bool hasData() => _locations.isNotEmpty;

  /// Fetches all categories
  List<LocationResponse> getCategories() => _locations;

  /// Fetches a location by ID
  LocationResponse? getLocationByID(int locationID) {
    try {
      return _locations
          .firstWhere((location) => location.locationID == locationID);
    } catch (e) {
      return null; // Return null if not found
    }
  }

  /// Clears the category cache
  void clearCache() {
    _locations = [];
  }
}

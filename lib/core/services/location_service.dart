// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/asset/location_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';

class LocationService {
  final Dio _dio = DioClientService().dio;

  /// Fetches work requests and returns a list of CategoryResponse
  Future<List<LocationResponse>> fetchLocationList(
      {Map<String, dynamic>? queryParams}) async {
    try {
      final int? siteID = await SharedPreferenceService.getCurrentSiteID();

      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/locations?siteID=$siteID',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to CategoryResponse model
      return (data as List<dynamic>)
          .map(
              (json) => LocationResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/asset/asset_history_response.dart'; // Ensure this is the correct import
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class AssetHistoryService {
  final Dio _dio = DioClientService().dio;

  /// Fetches asset inventory and returns a list of AssetResponse
  Future<List<AssetHistoryResponse>> fetchAssetHistory(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/reports/maintenance-logs',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to AssetHistoryResponse model
      return (data as List<dynamic>)
          .map((json) =>
              AssetHistoryResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }
}

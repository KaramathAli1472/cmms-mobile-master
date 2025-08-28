// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/models/asset/query_asset_by_token_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class AssetService {
  final Dio _dio = DioClientService().dio;

  /// Fetches work requests and returns a list of WorkRequestResponse
  Future<List<AssetResponse>> fetchAssetList(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/assets',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to WorkRequestResponse model
      return (data as List<dynamic>)
          .map((json) => AssetResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }

  Future<QueryAssetByTokenResponse> fetchAssetByQRCodeUrl(
      String fullUrl) async {
    try {
      Response response = await _dio.getUri(Uri.parse(fullUrl));
      final data = response.data;

      return QueryAssetByTokenResponse.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception(
        'Unexpected error occurred while fetching asset from QR code.');
  }
}

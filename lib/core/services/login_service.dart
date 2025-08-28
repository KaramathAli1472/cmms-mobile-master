// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/login/login_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class LoginService {
  final Dio _dio = DioClientService().dio;

  /// Fetches login details and returns a LoginResponse
  Future<List<LoginResponse>> fetchLoginList(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/logins',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to LoginResponse model
      return (data as List<dynamic>)
          .map((json) => LoginResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching login details.');
  }
}

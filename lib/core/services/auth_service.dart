// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/login/auth_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class AuthService {
  final Dio _dio = DioClientService().dio;

  Future<AuthResponse> fetchLoginProfile(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/logins',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;

      // Check if the array is not empty and bind the first record to AuthResponse
      if (data.isNotEmpty) {
        return AuthResponse.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw Exception('No login profile found'); // Handle empty array
      }
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }

  Future<Map<String, dynamic>> registerDeviceToken(
      String deviceType, String token) async {
    try {
      Response response = await _dio.post(
        '/device-tokens',
        data: {
          'deviceType': deviceType,
          'token': token,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials or server error');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No Internet Connection');
      } else {
        throw Exception('Server error');
      }
    }
  }
}

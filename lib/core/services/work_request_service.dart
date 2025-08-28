// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_request/add_work_request.dart';
import 'package:maintboard/core/models/work_request/work_request_detail_response.dart';
import 'package:maintboard/core/models/work_request/work_request_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkRequestService {
  final Dio _dio = DioClientService().dio;

  /// Fetches work requests and returns a list of WorkRequestResponse
  Future<List<WorkRequestResponse>> fetchWorkRequests(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/work-requests',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to WorkRequestResponse model
      return (data as List<dynamic>)
          .map((json) =>
              WorkRequestResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }

  /// Fetches work requests and returns a list of WorkRequestResponse
  Future<WorkRequestDetailResponse> fetchWorkRequestDetail(
      {required int workRequestID}) async {
    try {
      // Send GET request with required query parameter
      Response response = await _dio.get(
        '/work-requests/details',
        queryParameters: {
          'workRequestID': workRequestID,
        },
      );

      final data = response.data;

      // Ensure the response is properly parsed
      if (data != null && data is Map<String, dynamic>) {
        return WorkRequestDetailResponse.fromJson(data);
      } else {
        throw Exception('Invalid response format received.');
      }
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception(
        'Unexpected error occurred while fetching work request details.');
  }

  Future<Map<String, dynamic>> addWorkRequest(AddWorkRequest request) async {
    try {
      Response response = await _dio.post(
        '/work-requests',
        data: request.toJson(), // Use the model's toJson method for the payload
      );

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }
}

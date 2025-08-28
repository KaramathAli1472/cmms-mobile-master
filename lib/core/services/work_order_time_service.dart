// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_order_time/work_order_time_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkOrderTimeService {
  final Dio _dio = DioClientService().dio;

  /// Adds a time for a work order
  Future<Map<String, dynamic>> addTimeLog({
    required int workOrderID,
    required List<int> loginIDs,
    required DateTime fromDT,
    required DateTime toDT,
    String? remarks,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "resources": loginIDs.join(","),
        "fromDT": fromDT.toUtc().toIso8601String(),
        "toDT": toDT.toUtc().toIso8601String(),
        "remarks": remarks ?? "", // Send empty string if null
      };

      Response response = await _dio.post('/work-orders/time-logs', data: data);

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception('Unexpected error occurred while adding time log.');
  }

  /// Fetches time logs
  Future<List<WorkOrderTimeResponse>> fetchWorkOrderTimeLogs({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/work-orders/time-logs',
        queryParameters: queryParams,
      );

      // Since the API response is directly a list, use it without accessing `data`
      final data = response.data;

      // Bind to WorkOrderTimeLogResponse model
      return (data as List<dynamic>)
          .map((json) =>
              WorkOrderTimeResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching time logs.');
  }

  /// Updates a time for a work order
  Future<Map<String, dynamic>> updateTimeLog({
    required int workOrderID,
    required int workOrderTimeLogID,
    required int timeSpent,
    String? remarks,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "workOrderTimeLogID": workOrderTimeLogID,
        "timeSpent": timeSpent,
        if (remarks != null) "remarks": remarks,
      };

      Response response = await _dio.patch(
        '/work-orders/time-logs',
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while updating the time.');
  }

  /// Deletes a time for a work order
  Future<void> deleteTimeLog({
    required int workOrderID,
    required int workOrderTimeLogID,
  }) async {
    try {
      await _dio.delete(
        '/work-orders/time-logs',
        queryParameters: {
          "workOrderID": workOrderID,
          "workOrderTimeLogID": workOrderTimeLogID,
        },
      );
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      throw Exception('Failed to delete the time: ${e.message}');
    }
  }
}

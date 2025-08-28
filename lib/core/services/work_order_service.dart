// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_order/add_work_order.dart';
import 'package:maintboard/core/models/work_order/work_order_detail_response.dart';
import 'package:maintboard/core/models/work_order/work_order_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkOrderService {
  final Dio _dio = DioClientService().dio;

  Future<Map<String, dynamic>> addWorkOrder(AddWorkOrder order) async {
    try {
      Response response = await _dio.post(
        '/work-orders',
        data: order.toJson(), // Use the model's toJson method for the payload
      );

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }

  Future<Map<String, dynamic>> backlogWorkOrder({
    required int workOrderID,
    required int workOrderStatusID,
  }) async {
    try {
      final response = await _dio.put('/work-orders/backlog', data: {
        'workOrderID': workOrderID.toString(),
        'workOrderStatusID': workOrderStatusID,
      });
      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }
    throw Exception('Failed to backlog work order.');
  }

  Future<Map<String, dynamic>> startWorkOrder({
    required int workOrderID,
    required int workOrderStatusID,
    required DateTime actualStartDT,
    required bool enableDowntimeTracking,
  }) async {
    try {
      final response = await _dio.put('/work-orders/in-progress', data: {
        'workOrderID': workOrderID.toString(),
        'workOrderStatusID': workOrderStatusID,
        'actualStartDT': actualStartDT.toUtc().toIso8601String(),
        'enableDowntimeTracking': enableDowntimeTracking,
      });
      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }
    throw Exception('Failed to start work order.');
  }

  Future<Map<String, dynamic>> completeWorkOrder({
    required int siteID,
    required int workOrderID,
    required int workOrderStatusID,
    required DateTime actualEndDT,
    String? technicianRemarks,
    int? completedMeterReading,
  }) async {
    try {
      final response = await _dio.put('/work-orders/complete', data: {
        'siteID': siteID,
        'workOrderID': workOrderID,
        'workOrderStatusID': workOrderStatusID,
        'actualEndDT': actualEndDT.toUtc().toIso8601String(),
        'technicianRemarks': technicianRemarks,
        'completedMeterReading': completedMeterReading,
      });
      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }
    throw Exception('Failed to complete work order.');
  }

  Future<Map<String, dynamic>> closeWorkOrder({
    required int workOrderID,
    required int workOrderStatusID,
    String? closureRemarks,
  }) async {
    try {
      final response = await _dio.put('/work-orders/close', data: {
        'workOrderID': workOrderID.toString(),
        'workOrderStatusID': workOrderStatusID,
        'closureRemarks': closureRemarks,
      });
      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }
    throw Exception('Failed to close work order.');
  }

  /// Fetches work requests and returns a list of WorkRequestResponse
  Future<WorkOrderDetailResponse> fetchWorkOrderDetail(
      {required int workOrderID}) async {
    try {
      // Send GET request with required query parameter
      Response response = await _dio.get(
        '/work-orders/details',
        queryParameters: {
          'workOrderID': workOrderID,
        },
      );

      final data = response.data;

      // Ensure the response is properly parsed
      if (data != null && data is Map<String, dynamic>) {
        return WorkOrderDetailResponse.fromJson(data);
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

  Future<List<WorkOrderResponse>> fetchWorkOrders(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/work-orders',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to WorkOrderResponse model
      return (data as List<dynamic>)
          .map((json) =>
              WorkOrderResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_order_part/work_order_part_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkOrderPartService {
  final Dio _dio = DioClientService().dio;

  /// Adds a part to a work order
  Future<Map<String, dynamic>> addWorkOrderPart({
    required int workOrderID,
    required int partID,
    required int quantityUsed,
    required int installedLoginID,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "parts": partID.toString(),
        "quantityUsed": quantityUsed,
        "installedLoginID": installedLoginID,
      };

      Response response = await _dio.post('/work-orders/parts', data: data);

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception('Unexpected error occurred while adding work order part.');
  }

  /// Fetches parts associated with a work order
  Future<List<WorkOrderPartResponse>> fetchWorkOrderParts({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.get(
        '/work-orders/parts',
        queryParameters: queryParams,
      );

      final data = response.data;

      return (data as List<dynamic>)
          .map((json) =>
              WorkOrderPartResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception(
        'Unexpected error occurred while fetching work order parts.');
  }

  /// Updates a work order part
  Future<Map<String, dynamic>> updateWorkOrderPart({
    required int workOrderID,
    required int workOrderPartID,
    required int quantityUsed,
    required int installedLoginID,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "workOrderPartID": workOrderPartID,
        "quantityUsed": quantityUsed,
        "installedLoginID": installedLoginID,
      };

      Response response = await _dio.patch('/work-orders/parts', data: data);

      return response.data;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception(
        'Unexpected error occurred while updating the work order part.');
  }

  /// Deletes a work order part
  Future<void> deleteWorkOrderPart({
    required int workOrderID,
    required int workOrderPartID,
  }) async {
    try {
      await _dio.delete(
        '/work-orders/parts',
        queryParameters: {
          "workOrderID": workOrderID,
          "workOrderPartID": workOrderPartID,
        },
      );
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      throw Exception('Failed to delete the work order part: ${e.message}');
    }
  }
}

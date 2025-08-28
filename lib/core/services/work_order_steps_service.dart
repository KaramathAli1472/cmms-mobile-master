// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_order_checklist/section_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkOrderStepsService {
  final Dio _dio = DioClientService().dio;

  /// Fetches the checklist sections and steps for a work order.
  Future<List<SectionResponse>> fetchWorkOrderSteps({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.get(
        '/work-orders/steps',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;

      List<SectionResponse> sections = data
          .map((json) => SectionResponse.fromJson(json as Map<String, dynamic>))
          .toList();

      return sections;
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    throw Exception('Unexpected error occurred while fetching checklist.');
  }

  /// Updates an integer-based result for a work order step
  Future<void> updateIntResult({
    required int workOrderID,
    required int workOrderStepID,
    required int? result,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "workOrderStepID": workOrderStepID,
        "result": result,
      };

      await _dio.put('/work-orders/steps/int-results', data: data);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      rethrow;
    }
  }

  /// Updates a numeric-based result for a work order step
  Future<void> updateNumericResult({
    required int workOrderID,
    required int workOrderStepID,
    required double? result,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "workOrderStepID": workOrderStepID,
        "result": result,
      };

      await _dio.put('/work-orders/steps/numeric-results', data: data);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      rethrow;
    }
  }

  /// Updates a text-based result for a work order step
  Future<void> updateTextResult({
    required int workOrderID,
    required int workOrderStepID,
    required String? result,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderID,
        "workOrderStepID": workOrderStepID,
        "result": result,
      };

      await _dio.put('/work-orders/steps/text-results', data: data);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      rethrow;
    }
  }

  /// ✅ Marks a work order step as completed or not completed
  Future<void> updateStepCompletion({
    required int workOrderId,
    required int sectionId,
    required int stepId,
    required bool completed,
  }) async {
    try {
      final data = {
        "workOrderID": workOrderId,
        "sectionID": sectionId,
        "stepID": stepId,
        "completed": completed,
      };

      await _dio.put('/work-orders/steps/completion', data: data);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
      rethrow;
    }
  }
}

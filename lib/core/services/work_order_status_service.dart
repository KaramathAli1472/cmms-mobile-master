// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:maintboard/core/models/work_order_status/work_order_status_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class WorkOrderStatusService {
  final Dio _dio = DioClientService().dio;

  /// Fetches work orders and returns a list of WorkOrderResponse
  Future<List<WorkOrderStatusResponse>> fetchWorkOrderStatuses(
      {Map<String, dynamic>? queryParams}) async {
    try {
      // Send GET request with optional query parameters
      Response response = await _dio.get(
        '/work-order-statuses',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      // Bind to WorkOrderStatusResponse model
      return (data as List<dynamic>)
          .map((json) =>
              WorkOrderStatusResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }
}

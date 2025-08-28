// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:maintboard/core/models/common/presigned_url_response.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/dio_client_service.dart';

class AwsService {
  final Dio _dio = DioClientService().dio;

  Future<PresignedUrlResponse> getPresignedUrl(String key) async {
    try {
      Response response = await _dio.post(
        '/aws/presigned-url',
        data: {
          "key": key,
        },
      );

      // Map the result to PresignedUrlResponse
      return PresignedUrlResponse.fromJson(response.data);
    } on DioException catch (e) {
      CommonService().handleDioError(e);
    }

    // Add a fallback throw to ensure all paths return or throw
    throw Exception('Unexpected error occurred while fetching asset list.');
  }

  Future<void> uploadFileToPresignedUrl(String presignedUrl, File file,
      String contentType, String filename) async {
    try {
      await Dio().put(
        presignedUrl,
        data: await file.readAsBytes(),
        options: Options(headers: {
          'Content-Type': contentType,
        }),
      );
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
}

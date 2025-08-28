// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommonService {
  String getFileNameFromPath(String filePath) {
    return filePath.split('/').last;
  }

  String lookupMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream'; // Fallback for unknown types
    }
  }

  void handleDioError(DioException e) {
    debugPrint('--- Dio Error Start ---');
    debugPrint('Type: ${e.type}');
    debugPrint('Message: ${e.message}');
    debugPrint('Status Code: ${e.response?.statusCode}');
    debugPrint('Response Data: ${e.response?.data}');
    debugPrint('--- Dio Error End ---');

    if (e.type == DioExceptionType.connectionError) {
      throw 'No Internet Connection';
    } else if (e.response?.statusCode == 401) {
      throw 'Invalid credentials or server error';
    } else {
      // TEMP: bubble up full backend error for investigation
      final errorMessage =
          e.response?.data.toString() ?? 'Unknown server error';
      throw 'Server error: $errorMessage';
    }
  }
}

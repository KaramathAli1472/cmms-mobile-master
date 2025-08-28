// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class PresignedUrlResponse {
  final String presignedUrl;
  final String objectKey;

  PresignedUrlResponse({
    required this.presignedUrl,
    required this.objectKey,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponse(
      presignedUrl: requireField<String>(json, 'presignedUrl'),
      objectKey: requireField<String>(json, 'objectKey'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presignedUrl': presignedUrl,
      'objectKey': objectKey,
    };
  }
}

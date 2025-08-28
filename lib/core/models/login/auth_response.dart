// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/common/contact_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class AuthResponse {
  final int loginID;
  final String loginName;
  final String? firebaseUID; // Nullable field
  final double hourlyRate;
  final String? defaultImageUrl; // Nullable field
  final int securityRoleID;
  final List<int> siteID;
  final ContactResponse? contact;
  final int? languageID; // ✅ Newly added optional field

  AuthResponse({
    required this.loginID,
    required this.loginName,
    this.firebaseUID,
    required this.hourlyRate,
    this.defaultImageUrl,
    required this.securityRoleID,
    required this.siteID,
    this.contact,
    this.languageID,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      loginID: requireField<int>(json, 'loginID'),
      loginName: requireField<String>(json, 'loginName'),
      firebaseUID: json['firebaseUID'],
      hourlyRate: (requireField<num>(json, 'hourlyRate')).toDouble(),
      defaultImageUrl: json['defaultImageUrl'],
      securityRoleID: requireField<int>(json, 'securityRoleID'),
      siteID: List<int>.from(json['siteID'] ?? []),
      contact: json['contact'] != null
          ? ContactResponse.fromJson(json['contact'])
          : null,
      languageID: json['languageID'],
    );
  }
}

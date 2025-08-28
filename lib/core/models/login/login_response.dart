// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/common/contact_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class LoginResponse {
  final int loginID;
  final String loginName;
  final double? hourlyRate;
  final int securityRoleID;
  final int? languageID;
  final ContactResponse? contact;

  LoginResponse({
    required this.loginID,
    required this.loginName,
    this.hourlyRate,
    required this.securityRoleID,
    this.languageID,
    this.contact,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      loginID: requireField<int>(json, 'loginID'),
      loginName: requireField<String>(json, 'loginName'),
      hourlyRate: json['hourlyRate'] != null
          ? (json['hourlyRate'] as num).toDouble()
          : null,
      securityRoleID: requireField<int>(json, 'securityRoleID'),
      languageID: json['languageID'],
      contact: json['contact'] != null
          ? ContactResponse.fromJson(json['contact'])
          : null,
    );
  }
}

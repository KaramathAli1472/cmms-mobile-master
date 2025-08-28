// language_response.dart

import 'package:maintboard/core/utils/json_utils.dart';

class LanguageResponse {
  final int languageID;
  final String languageName;
  final String nativeName;
  final String languageCode;
  final String locale;
  final bool isActive;

  LanguageResponse({
    required this.languageID,
    required this.languageName,
    required this.nativeName,
    required this.languageCode,
    required this.locale,
    required this.isActive,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      languageID: requireField<int>(json, 'languageID'),
      languageName: requireField<String>(json, 'languageName'),
      nativeName: requireField<String>(json, 'nativeName'),
      languageCode: requireField<String>(json, 'languageCode'),
      locale: requireField<String>(json, 'locale'),
      isActive: requireField<bool>(json, 'isActive'),
    );
  }
}

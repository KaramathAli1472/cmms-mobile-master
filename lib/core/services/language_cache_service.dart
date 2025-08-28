// language_cache_service.dart

import 'package:maintboard/core/models/common/language_response.dart';
import 'package:maintboard/core/services/language_service.dart';

class LanguageCacheService {
  // Singleton
  LanguageCacheService._internal();
  static final LanguageCacheService _instance =
      LanguageCacheService._internal();
  factory LanguageCacheService() => _instance;

  List<LanguageResponse> _languages = [];

  void loadLanguages(List<LanguageResponse> languages) {
    _languages = languages;
  }

  Future<void> loadLanguagesFromService() async {
    final languages = await LanguageService().fetchLanguageList();
    loadLanguages(languages);
  }

  bool hasData() => _languages.isNotEmpty;

  List<LanguageResponse> getLanguages() => _languages;

  static final LanguageResponse unknownLanguage = LanguageResponse(
    languageID: -1,
    languageName: "Unknown",
    nativeName: "Unknown",
    languageCode: "xx",
    locale: "xx-XX",
    isActive: false,
  );

  LanguageResponse getLanguageByID(int languageID) {
    return _languages.firstWhere(
      (lang) => lang.languageID == languageID,
      orElse: () => unknownLanguage,
    );
  }

  void clearCache() {
    _languages = [];
  }
}

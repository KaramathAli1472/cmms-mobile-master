// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String _accessTokenKey = 'accessToken';
  static const String _currentSiteIDKey = 'currentSiteID';

  // Access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Current Site ID
  static Future<void> saveCurrentSiteID(int currentSiteID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentSiteIDKey, currentSiteID);
  }

  static Future<int?> getCurrentSiteID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentSiteIDKey);
  }

  /// Clear JWT token
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_currentSiteIDKey);
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/login/login_response.dart';
import 'package:maintboard/core/services/login_service.dart';

class LoginCacheService {
  // Singleton Instance
  LoginCacheService._internal();
  static final LoginCacheService _instance = LoginCacheService._internal();
  factory LoginCacheService() => _instance;

  // In-memory cache for login details
  List<LoginResponse> _logins = [];

  /// Loads login details into the cache
  void loadLogins(List<LoginResponse> loginResponses) {
    _logins = loginResponses;
  }

  /// Loads login details from the API
  Future<void> loadLoginsFromService(
      {Map<String, dynamic>? queryParams}) async {
    final loginResponses =
        await LoginService().fetchLoginList(queryParams: queryParams);
    loadLogins(loginResponses);
  }

  /// Checks if the cache is populated
  bool hasData() => _logins.isNotEmpty;

  /// Fetches all cached login details
  List<LoginResponse> getLogins() => _logins;

  /// Fetches login details by loginID
  LoginResponse? getLoginByID(int loginID) {
    try {
      return _logins.firstWhere((login) => login.loginID == loginID);
    } catch (e) {
      return null; // Return null if no match is found
    }
  }

  /// Clears the login cache
  void clearCache() {
    _logins = [];
  }
}

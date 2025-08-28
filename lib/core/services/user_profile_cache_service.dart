// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/login/auth_response.dart';

class UserProfileCacheService {
  // Singleton Instance
  UserProfileCacheService._internal();

  static final UserProfileCacheService _instance =
      UserProfileCacheService._internal();
  factory UserProfileCacheService() => _instance;

  // In-memory cache for user profile
  AuthResponse? _userProfile;

  /// Loads the user profile into the cache
  void loadUserProfile(AuthResponse profile) {
    _userProfile = profile;
  }

  /// Fetches the user profile
  AuthResponse? getUserProfile() {
    return _userProfile;
  }

  /// Fetches specific properties of the user profile
  String getFullName() {
    return _userProfile?.contact?.name ?? "Unknown";
  }

  /// Fetches the initials from the user's full name
  String getInitials() {
    String fullName = _userProfile?.contact?.name ?? "Unknown";
    List<String> nameParts = fullName.split(" ");

    if (nameParts.isEmpty) return "U"; // Default to 'U' if no name is available

    String initials = nameParts
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase())
        .take(2) // Limit to two initials
        .join();

    return initials.isNotEmpty ? initials : "U";
  }

  /// Fetches specific properties of the user profile
  int getLoginID() {
    return _userProfile?.loginID ?? 0;
  }

  String getRole() {
    return _userProfile?.contact?.jobTitle ?? "Unknown";
  }

  int? getLanguageID() {
    return _userProfile?.languageID ?? 0;
  }

  String getDefaultImageUrl() {
    return _userProfile?.contact?.contactPhoto?.url ?? "";
  }

  /// Clears the user profile cache (e.g., during logout)
  void clearCache() {
    _userProfile = null;
  }
}

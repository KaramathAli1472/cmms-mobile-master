// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String _userName = "John Doe";
  String _email = "john.doe@example.com";
  String _profilePictureUrl = ""; // Placeholder for profile picture URL

  String get userName => _userName;
  String get email => _email;
  String get profilePictureUrl => _profilePictureUrl;

  void updateUserProfile(
      String newName, String newEmail, String newPictureUrl) {
    _userName = newName;
    _email = newEmail;
    _profilePictureUrl = newPictureUrl;
    notifyListeners(); // Notify the UI of state changes
  }

  void logout() {
    SnackbarService.showSuccess("User logged out");
  }
}

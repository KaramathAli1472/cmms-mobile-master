// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class SnackbarService {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // General method to show a Snackbar
  static void _showSnackbar(
    String message, {
    Color backgroundColor = Colors.red,
    SnackBarAction? action,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          action: action,
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
    }
  }

  // Shortcut for showing success messages
  static void showSuccess(String message) {
    _showSnackbar(
      message,
      backgroundColor: Colors.green, // Default success color
    );
  }

  // Shortcut for showing error messages
  static void showError(String message) {
    _showSnackbar(
      message,
      backgroundColor: Colors.red, // Default error color
    );
  }
}

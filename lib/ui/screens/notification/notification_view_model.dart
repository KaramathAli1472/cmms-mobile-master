// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  List<String> notifications = ["Notification 1", "Notification 2"];

  void addNotification(String notification) {
    notifications.add(notification);
    notifyListeners();
  }
}

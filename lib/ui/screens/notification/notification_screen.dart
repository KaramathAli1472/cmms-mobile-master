// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationViewModel _viewModel = NotificationViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        itemCount: _viewModel.notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_viewModel.notifications[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _viewModel.addNotification(
                "Notification ${_viewModel.notifications.length + 1}");
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/services/date_time_service.dart';

class DueDateIndicator extends StatelessWidget {
  final DateTime? dueDate;

  const DueDateIndicator({super.key, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.event, // Calendar event icon
          size: 16.0, // Icon size
          // color: Colors.blue, // Customize the icon color
        ),
        const SizedBox(width: 4.0), // Spacing between icon and text
        Text(
          DateTimeService.formatUtcToLocalTime(dueDate),
          style: const TextStyle(
            fontSize: 14.0, // Text size
            color: Colors.black, // Text color
          ),
        ),
      ],
    );
  }
}

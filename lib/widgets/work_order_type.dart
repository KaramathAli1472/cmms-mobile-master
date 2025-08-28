// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class WorkOrderTypeIndicator extends StatelessWidget {
  final int workOrderTypeID;

  const WorkOrderTypeIndicator({super.key, required this.workOrderTypeID});

  @override
  Widget build(BuildContext context) {
    // Determine the status text based on WorkOrderTypeID
    String statusText;

    switch (workOrderTypeID) {
      case 1:
        statusText = 'Type: Breakdown';
        break;
      case 2:
        statusText = 'Type: PM';
        break;
      default:
        statusText = 'Type: Unknown';
    }

    return Text(
      statusText,
      style: const TextStyle(
          // fontWeight: FontWeight.normal, // No bold or extra styling
          // color: Colors.black,           // Default text color
          // fontSize: 14,                  // Standard font size
          ),
    );
  }
}

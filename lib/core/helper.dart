import 'package:flutter/material.dart';

/// Utility functions related to Work Requests.
String getWorkRequestStatusText(int workRequestStatusID) {
  switch (workRequestStatusID) {
    case 0:
      return 'In Review';
    case 1:
      return 'Approved';
    case 2:
      return 'Rejected';
    default:
      return 'Unknown';
  }
}

/// Returns the color associated with the given WorkRequestStatusID.
Color getWorkRequestStatusColor(int workRequestStatusID) {
  switch (workRequestStatusID) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.green;
    case 2:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

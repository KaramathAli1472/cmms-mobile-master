// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class LocationIndicator extends StatelessWidget {
  final String locationName;

  const LocationIndicator({super.key, required this.locationName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Prevents unbounded width error
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16.0, // Adjust the size as needed
          color: Colors.grey, // Customize the icon color
        ),
        const SizedBox(width: 4.0), // Space between icon and text
        Flexible(
          child: Text(
            locationName,
            style: const TextStyle(
                // fontSize: 14.0, // Adjust text size
                // color: Colors.black, // Customize text color
                ),
            overflow: TextOverflow.ellipsis, // Handle long location names
          ),
        ),
      ],
    );
  }
}

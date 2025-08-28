// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class QuantityIndicator extends StatelessWidget {
  final int quantity;

  const QuantityIndicator({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures Row doesn't take infinite width
      children: [
        Icon(
          quantity > 0 ? Icons.check_circle : Icons.warning,
          size: 16.0, // Adjust the size as needed
          color: quantity > 0
              ? Colors.green
              : Colors.red, // Green if > 0, Red otherwise
        ),
        const SizedBox(width: 4.0), // Space between icon and text
        Text(
          quantity > 0 ? '$quantity pcs' : 'Out of Stock',
        ),
      ],
    );
  }
}

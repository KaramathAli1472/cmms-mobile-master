// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class CustomChoiceChip<T> extends StatelessWidget {
  final List<T> options;
  final T? selectedValue;
  final Function(T) onSelected;
  final String Function(T) labelBuilder; // Extracts label for display
  final double borderRadius; // Customizable border radius
  final Color borderColor; // Customizable border color

  const CustomChoiceChip({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    required this.labelBuilder,
    this.borderRadius = 8.0, // Default to 8.0 if not provided
    this.borderColor = Colors.grey, // Default to grey if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((T value) {
        return ChoiceChip(
          label: Text(labelBuilder(value)), // Uses custom label
          selected: selectedValue == value,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius), // Custom border radius
            side: BorderSide(color: borderColor), // Custom border color
          ),
          onSelected: (selected) {
            if (selected) {
              onSelected(value);
            }
          },
        );
      }).toList(),
    );
  }
}

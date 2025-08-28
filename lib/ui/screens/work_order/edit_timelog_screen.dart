// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_order_time_service.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/widgets/section_card.dart';
import 'package:maintboard/widgets/custom_choice_chip.dart';

class EditTimelogScreen extends StatefulWidget {
  final int workOrderID;
  final int timeLogID;
  final int initialTimeSpent;

  const EditTimelogScreen({
    super.key,
    required this.workOrderID,
    required this.timeLogID,
    required this.initialTimeSpent,
  });

  @override
  State<EditTimelogScreen> createState() => _EditTimelogScreenState();
}

class _EditTimelogScreenState extends State<EditTimelogScreen> {
  int _selectedHours = 0;
  int _selectedMinutes = 30; // Default minutes selection

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.initialTimeSpent ~/ 60; // Extract hours
    _selectedMinutes = widget.initialTimeSpent % 60; // Extract minutes
  }

  Future<void> _updateTimelog() async {
    final int timeSpent = (_selectedHours * 60) + _selectedMinutes;

    if (timeSpent == 0) {
      SnackbarService.showError('Time cannot be 0 minutes.');
      return;
    }

    try {
      await WorkOrderTimeService().updateTimeLog(
        workOrderID: widget.workOrderID,
        workOrderTimeLogID: widget.timeLogID,
        timeSpent: timeSpent,
      );

      SnackbarService.showSuccess('Time updated successfully');
      Navigator.pop(context, true); // Emit success status to the parent
    } catch (e) {
      SnackbarService.showError('Failed to update time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionCard(
              title: "Select Hours",
              child: CustomChoiceChip<int>(
                options: [0, 1, 2, 3, 4, 5, 6, 7, 8], // Available hours
                selectedValue: _selectedHours,
                labelBuilder: (value) => value == 0
                    ? "None"
                    : "$value h", // Display 'None' for 0 hours
                onSelected: (value) {
                  setState(() {
                    _selectedHours = value;
                  });
                },
              ),
            ),
            SectionCard(
              title: "Select Minutes",
              child: CustomChoiceChip<int>(
                options: [
                  0,
                  15,
                  30,
                  45
                ], // Add '0' minutes to allow full-hour selection
                selectedValue: _selectedMinutes,
                labelBuilder: (value) => value == 0
                    ? "None"
                    : "$value m", // Display 'None' for 0 minutes
                onSelected: (value) {
                  setState(() {
                    _selectedMinutes = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, // Full-width button
              child: PrimaryButton(
                text: 'Update Time',
                onPressed: _updateTimelog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

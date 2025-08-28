// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/user_profile_cache_service.dart';
import 'package:maintboard/core/services/work_order_time_service.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/widgets/section_card.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class AddTimeScreen extends StatefulWidget {
  final int workOrderID;

  const AddTimeScreen({super.key, required this.workOrderID});

  @override
  State<AddTimeScreen> createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  DateTime? fromDT;
  DateTime? toDT;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  bool isLoading = false;

  Future<void> _pickDateTime({required bool isFrom}) async {
    final picked = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 5,
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd HH:mm').format(picked);
      setState(() {
        if (isFrom) {
          fromDT = picked;
          _fromController.text = formatted;
        } else {
          toDT = picked;
          _toController.text = formatted;
        }
      });
    }
  }

  Future<void> _submitTimelog() async {
    if (fromDT == null || toDT == null) {
      SnackbarService.showError('Both start and end times are required.');
      return;
    }
    if (toDT!.isBefore(fromDT!)) {
      SnackbarService.showError('End time must be after start time.');
      return;
    }

    final int minutesSpent = toDT!.difference(fromDT!).inMinutes;
    if (minutesSpent == 0) {
      SnackbarService.showError('Time log cannot be 0 minutes.');
      return;
    }

    final int loginID = UserProfileCacheService().getLoginID();

    try {
      await WorkOrderTimeService().addTimeLog(
        workOrderID: widget.workOrderID,
        loginIDs: [loginID], // Updated to accept a list of loginIDs
        fromDT: fromDT!.toUtc(),
        toDT: toDT!.toUtc(),
      );

      SnackbarService.showSuccess('Timelog added successfully');
      Navigator.pop(context, true);
    } catch (e) {
      SnackbarService.showError('Failed to add timelog: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionCard(
              title: 'From',
              child: TextField(
                controller: _fromController,
                readOnly: true,
                onTap: () => _pickDateTime(isFrom: true),
                decoration: const InputDecoration(
                  labelText: 'From Date & Time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'To',
              child: TextField(
                controller: _toController,
                readOnly: true,
                onTap: () => _pickDateTime(isFrom: false),
                decoration: const InputDecoration(
                  labelText: 'To Date & Time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Add Time Log',
                isLoading: isLoading,
                onPressed: _submitTimelog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

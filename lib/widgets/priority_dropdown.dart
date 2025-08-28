// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/common/priority_response.dart';
import 'package:maintboard/core/services/priority_cache_service.dart';

class PriorityDropdown extends StatefulWidget {
  final PriorityResponse? selectedPriority;
  final ValueChanged<PriorityResponse?> onChanged;
  final String? Function(PriorityResponse?)? validator;

  const PriorityDropdown({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
    this.validator,
  });

  @override
  PriorityDropdownState createState() => PriorityDropdownState();
}

class PriorityDropdownState extends State<PriorityDropdown> {
  List<PriorityResponse> priorities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPriorities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPriorities() async {
    try {
      final loadedPriorities = PriorityCacheService().getPriorities();
      if (!mounted) return; // Ensure widget is still active

      setState(() {
        priorities = loadedPriorities;
        if (widget.selectedPriority == null && loadedPriorities.isNotEmpty) {
          widget.onChanged(loadedPriorities.first);
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Ensure widget is still active
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<PriorityResponse>(
      decoration: const InputDecoration(
        labelText: 'Select Priority',
        border: OutlineInputBorder(),
      ),
      value: widget.selectedPriority,
      items: priorities.map((priority) {
        return DropdownMenuItem<PriorityResponse>(
          value: priority,
          child: Text(priority.priorityName),
        );
      }).toList(),
      onChanged: widget.onChanged,
      validator: widget.validator ??
          (value) => value == null ? 'Please select a priority' : null,
    );
  }
}

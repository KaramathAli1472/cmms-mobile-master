// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/user_profile_cache_service.dart';
import 'package:maintboard/core/services/work_order_part_service.dart';
import 'package:maintboard/widgets/part_dropdown.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/widgets/section_card.dart';

class AddPartScreen extends StatefulWidget {
  final int workOrderID;

  const AddPartScreen({super.key, required this.workOrderID});

  @override
  State<AddPartScreen> createState() => _AddPartScreenState();
}

class _AddPartScreenState extends State<AddPartScreen> {
  PartResponse? _selectedPart;
  late TextEditingController _quantityController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: '1'); // Default quantity: 1
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submitPart() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPart == null) {
        SnackbarService.showError('Please select a part.');
        return;
      }

      final int quantity = int.tryParse(_quantityController.text) ?? 1;
      final int loginID = UserProfileCacheService().getLoginID();

      try {
        await WorkOrderPartService().addWorkOrderPart(
          workOrderID: widget.workOrderID,
          partID: _selectedPart!.partID,
          quantityUsed: quantity,
          installedLoginID: loginID,
        );

        SnackbarService.showSuccess('Part added successfully');

        // Return success response
        Navigator.pop(context, true);
      } catch (e) {
        SnackbarService.showError('Failed to add part: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Part'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionCard(
                title: "Part Details",
                child: Column(
                  children: [
                    PartDropdown(
                      selectedPart: _selectedPart,
                      onChanged: (part) => setState(() {
                        _selectedPart = part;
                      }),
                      validator: (value) =>
                          value == null ? "Please select a part" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Quantity",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter quantity";
                        }
                        final int? qty = int.tryParse(value);
                        if (qty == null || qty < 1) {
                          return "Quantity must be at least 1";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Full-width button
                child: PrimaryButton(
                  text: 'Add Part',
                  onPressed: _submitPart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/models/common/priority_response.dart';
import 'package:maintboard/core/models/work_order/add_work_order.dart';
import 'package:maintboard/core/models/work_order/category_response.dart';
import 'package:maintboard/core/services/work_order_service.dart';
import 'package:maintboard/widgets/asset_dropdown.dart';
import 'package:maintboard/widgets/button.dart';
import 'package:maintboard/widgets/category_dropdown.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/core/services/aws_service.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/widgets/priority_dropdown.dart';

class AddWorkOrderForm extends StatefulWidget {
  final Function(AddWorkOrder) onOrderAdded;

  const AddWorkOrderForm({super.key, required this.onOrderAdded});

  @override
  State<AddWorkOrderForm> createState() => _AddWorkOrderFormState();
}

class _AddWorkOrderFormState extends State<AddWorkOrderForm> {
  Timer? _debounceTimer;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  PriorityResponse? selectedPriority;
  AssetResponse? selectedAsset;
  CategoryResponse? selectedCategory;
  DateTime? selectedDateTime;
  bool isLoading = false;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!);
  }

  Future<void> _pickDateTime() async {
    final picked = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDateTime!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 5,
    );

    if (picked != null) {
      setState(() {
        selectedDateTime = picked;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(picked);
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    if (_selectedImages.length >= 3) {
      SnackbarService.showError('You can only upload up to 3 images.');
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final pickedFiles = await _picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        final remainingSlots = 3 - _selectedImages.length;
        final validFiles = pickedFiles.take(remainingSlots);

        for (var pickedFile in validFiles) {
          final contentType = CommonService().lookupMimeType(pickedFile.path);
          if (!contentType.startsWith('image/')) {
            SnackbarService.showError(
                'Invalid file type. Please select an image.');
            continue;
          }
          setState(() {
            _selectedImages.add(File(pickedFile.path));
          });
        }

        if (pickedFiles.length > remainingSlots) {
          SnackbarService.showError('You can only upload up to 3 images.');
        }
      } else if (source == ImageSource.camera) {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          final contentType = CommonService().lookupMimeType(pickedFile.path);
          if (!contentType.startsWith('image/')) {
            SnackbarService.showError(
                'Invalid file type. Please select an image.');
            return;
          }
          setState(() {
            _selectedImages.add(File(pickedFile.path));
          });
        } else {
          SnackbarService.showError('No image selected');
        }
      }
    } catch (e) {
      SnackbarService.showError('Failed to pick images: $e');
    }
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      List<String> objectKeys = [];
      for (var image in _selectedImages) {
        final filename = CommonService().getFileNameFromPath(image.path);
        final aws = await AwsService().getPresignedUrl(filename);
        final objectKey = aws.objectKey;
        objectKeys.add(objectKey);
        final contentType = CommonService().lookupMimeType(image.path);
        await AwsService().uploadFileToPresignedUrl(
            aws.presignedUrl, image, contentType, filename);
      }

      final siteID = await SharedPreferenceService.getCurrentSiteID() ?? 0;
      final workOrder = AddWorkOrder(
        siteID: siteID,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        assetID: selectedAsset!.assetID,
        plannedEndDT: selectedDateTime!.toUtc(),
        categoryID: selectedCategory!.categoryID,
        priorityID: selectedPriority!.priorityID,
        workOrderTypeID: 1,
        attachments: objectKeys,
      );

      await WorkOrderService().addWorkOrder(workOrder);
      SnackbarService.showSuccess('Work Order added successfully.');
      widget.onOrderAdded(workOrder);
      Navigator.of(context).pop();
    } catch (e) {
      SnackbarService.showError('Error: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Work Order')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              PriorityDropdown(
                selectedPriority: selectedPriority,
                onChanged: (value) => setState(() => selectedPriority = value),
                validator: (value) =>
                    value == null ? 'Please select a priority' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateTimeController,
                readOnly: true,
                onTap: _pickDateTime,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a due date'
                    : null,
              ),
              const SizedBox(height: 16),
              AssetDropdown(
                selectedAsset: selectedAsset,
                onChanged: (asset) => setState(() => selectedAsset = asset),
                validator: (value) =>
                    value == null ? 'Please select an asset' : null,
              ),
              const SizedBox(height: 16),
              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages.map((image) {
                    return Column(
                      children: [
                        Image.file(image,
                            height: 100, width: 100, fit: BoxFit.cover),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white12,
                              foregroundColor: Colors.red),
                          onPressed: () =>
                              setState(() => _selectedImages.remove(image)),
                          icon: const Icon(Icons.delete),
                          label: const Text('Remove'),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    text: 'Camera',
                    prependIcon: Icons.camera_alt_outlined,
                    onPressed: () => _pickImages(ImageSource.camera),
                  ),
                  Button(
                    text: 'Gallery',
                    prependIcon: Icons.photo_outlined,
                    onPressed: () => _pickImages(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: isLoading ? null : submitForm,
                text: 'Submit',
                isLoading: isLoading,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    titleController.dispose();
    descriptionController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }
}

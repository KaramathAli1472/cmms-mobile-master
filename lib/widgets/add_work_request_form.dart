// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/models/common/priority_response.dart';
import 'package:maintboard/core/services/priority_cache_service.dart';
import 'package:maintboard/widgets/asset_dropdown.dart';
import 'package:maintboard/widgets/button.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/core/services/aws_service.dart';
import 'package:maintboard/core/services/common_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_request_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/models/work_request/add_work_request.dart';
import 'package:maintboard/widgets/priority_dropdown.dart';
import 'package:maintboard/widgets/voice_input_modal.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AddWorkRequestForm extends StatefulWidget {
  final AssetResponse? prefilledAsset;
  final Function(AddWorkRequest) onRequestAdded;

  const AddWorkRequestForm({
    super.key,
    required this.onRequestAdded,
    this.prefilledAsset,
  });

  @override
  State<AddWorkRequestForm> createState() => _AddWorkRequestFormState();
}

class _AddWorkRequestFormState extends State<AddWorkRequestForm> {
  Timer? _debounceTimer;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  PriorityResponse? selectedPriority;
  List<PriorityResponse> priorities = [];
  bool isLoadingPriorities = true;

  AssetResponse? selectedAsset;
  bool isLoading = false;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  double _micOpacity = 1.0;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();

    selectedPriority = null; // Do not assign default
    selectedAsset = widget.prefilledAsset; // prefill if available
    _loadAndSetPriorities();

    titleController.addListener(() {
      setState(() {});
    });
  }

  // Load priorities and set default
  Future<void> _loadAndSetPriorities() async {
    final loaded = PriorityCacheService().getPriorities();
    setState(() {
      priorities = loaded;
      isLoadingPriorities = false;
      if (selectedPriority == null && loaded.isNotEmpty) {
        // Smart selection for "Medium"
        final medium = loaded.firstWhere(
          (p) => p.priorityName.toLowerCase() == 'medium',
          orElse: () => loaded.first,
        );
        selectedPriority = medium;
      }
    });
  }

  // void _startBlinking() {
  //   _blinkTimer?.cancel();
  //   _micOpacity = 1.0;
  //   _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     setState(() {
  //       _micOpacity = _micOpacity == 1.0 ? 0.3 : 1.0;
  //     });
  //   });
  // }

  // void _stopBlinking() {
  //   _blinkTimer?.cancel();
  //   setState(() {
  //     _micOpacity = 1.0;
  //   });
  // }

  // void _listen() async {
  //   if (!_isListening) {
  //     bool available = await _speechToText.initialize();
  //     if (available) {
  //       setState(() => _isListening = true);
  //       _startBlinking();
  //       _speechToText.listen(
  //         onResult: (result) async {
  //           setState(() {
  //             titleController.text = result.recognizedWords;
  //           });
  //         },
  //         localeId: 'en_IN',
  //       );
  //     }
  //   } else {
  //     setState(() => _isListening = false);
  //     _speechToText.stop();
  //     _stopBlinking();
  //   }
  // }

  Future<void> _pickImages(ImageSource source) async {
    if (_selectedImages.length >= 3) {
      SnackbarService.showError('You can only upload up to 3 images.');
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        // Allow the user to pick multiple images from the gallery
        final pickedFiles = await _picker.pickMultiImage(
          maxWidth: 1920, // Optional: Resize to optimize for uploads
          maxHeight: 1080,
          imageQuality: 85, // Optional: Compress the image
        );

        final remainingSlots = 3 - _selectedImages.length;
        final validFiles = pickedFiles.take(remainingSlots);

        for (var pickedFile in validFiles) {
          // Validate MIME type using CommonService
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
        // Allow the user to take a photo with the camera
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1920, // Optional: Resize to optimize for uploads
          maxHeight: 1080,
          imageQuality: 85, // Optional: Compress the image
        );

        if (pickedFile != null) {
          // Validate MIME type using CommonService
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

    setState(() {
      isLoading = true;
    });

    try {
      List<String> objectKeys = [];

      for (var image in _selectedImages) {
        final filename = CommonService()
            .getFileNameFromPath(image.path); // Extracts the filename

        // Get the presigned url from the AWS
        final aws = await AwsService().getPresignedUrl(filename);
        final objectKey = aws.objectKey;

        // Add the objectKey to the list
        objectKeys.add(objectKey);

        // Determine the content type of the file
        final contentType = CommonService().lookupMimeType(image.path);

        // Make a PUT request to upload the file
        await AwsService().uploadFileToPresignedUrl(
            aws.presignedUrl, image, contentType, filename);
      }

      final siteID = await SharedPreferenceService.getCurrentSiteID() ?? 0;

      final workRequest = AddWorkRequest(
        siteID: siteID,
        title: titleController.text.trim(),
        priorityID: selectedPriority!.priorityID,
        assetID: selectedAsset!.assetID,
        attachments: objectKeys,
      );

      // Add work request
      await WorkRequestService().addWorkRequest(workRequest);

      // Show success message
      SnackbarService.showSuccess('Your work request is sent for a review');

      // Emit back to the parent
      widget.onRequestAdded(workRequest);

      Navigator.of(context).pop();
    } catch (e) {
      SnackbarService.showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Work Request')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AssetDropdown(
                selectedAsset: selectedAsset,
                onChanged: widget.prefilledAsset != null
                    ? (AssetResponse? _) {} // no-op
                    : (AssetResponse? asset) {
                        setState(() {
                          selectedAsset = asset;
                        });
                      },
                validator: (value) =>
                    value == null ? 'Please select an asset' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                      maxLength: 1000,
                      minLines: 3,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Describe Problem',
                        hintText: 'Type here or use mic',
                        helperText: 'You can type or tap mic to record',
                        border: OutlineInputBorder(),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (titleController.text.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    titleController.clear();
                                  });
                                },
                              ),
                            IconButton(
                              icon: Icon(Icons.mic_none),
                              onPressed: () async {
                                final recognizedText =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => VoiceInputModal(),
                                );
                                if (recognizedText != null &&
                                    recognizedText.isNotEmpty) {
                                  setState(() {
                                    // Add a space or newline if needed
                                    if (titleController.text.trim().isEmpty) {
                                      titleController.text = recognizedText;
                                    } else {
                                      titleController.text =
                                          '${titleController.text.trim()} $recognizedText';
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Title is required'
                          : null,
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              PriorityDropdown(
                selectedPriority: selectedPriority,
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a priority' : null,
              ),
              const SizedBox(height: 16),

              // Image Picker Section with Multiple Images
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages.map((image) {
                    return Column(
                      children: [
                        Image.file(
                          image,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.white12, // Ensures visibility
                            foregroundColor: Colors.red, // Icon color
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedImages.remove(image);
                            });
                          },
                          label: const Text('Remove'),
                        ),
                      ],
                    );
                  }).toList(),
                ),

              // const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: "Attach Photo",
                  prependIcon: Icons.attach_file,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.camera_alt_outlined),
                                title: const Text('Take a Photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImages(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.photo_library_outlined),
                                title: const Text('Choose from Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImages(ImageSource.gallery);
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.close),
                                title: const Text('Cancel'),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
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
    _blinkTimer?.cancel();
    titleController.dispose();
    super.dispose();
  }
}

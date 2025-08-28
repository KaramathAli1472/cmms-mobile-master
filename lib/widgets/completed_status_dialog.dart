import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/widgets/voice_input_modal.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CompletedStatusDialog extends StatefulWidget {
  final int siteID;
  final int workOrderID;
  final int statusID;
  final VoidCallback? onStatusChanged;

  const CompletedStatusDialog({
    super.key,
    required this.siteID,
    required this.workOrderID,
    required this.statusID,
    this.onStatusChanged,
  });

  @override
  State<CompletedStatusDialog> createState() => _CompletedStatusDialogState();
}

class _CompletedStatusDialogState extends State<CompletedStatusDialog> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
  }

  Future<void> _pickDateTime() async {
    final DateTime? picked = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 5,
    );
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
      });
    }
  }

  Future<void> _submitCompleteWorkOrder() async {
    setState(() => isLoading = true);
    try {
      await WorkOrderService().completeWorkOrder(
        siteID: widget.siteID,
        workOrderID: widget.workOrderID,
        workOrderStatusID: widget.statusID,
        actualEndDT: selectedDateTime,
        technicianRemarks: _notesController.text.trim(),
        completedMeterReading: null,
      );
      SnackbarService.showSuccess('Status updated to Completed');
      widget.onStatusChanged?.call();
      Navigator.pop(context);
    } catch (e) {
      SnackbarService.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mark as Completed?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _dateTimeController,
            readOnly: true,
            onTap: _pickDateTime,
            decoration: const InputDecoration(
              labelText: 'Completion Date & Time',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: 'Technician Notes',
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_notesController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _notesController.clear();
                      }),
                    ),
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    onPressed: () async {
                      final recognizedText = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const VoiceInputModal(),
                      );
                      if (recognizedText != null && recognizedText.isNotEmpty) {
                        setState(() {
                          if (_notesController.text.trim().isEmpty) {
                            _notesController.text = recognizedText;
                          } else {
                            _notesController.text =
                                '${_notesController.text.trim()} $recognizedText';
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          onPressed: isLoading ? null : _submitCompleteWorkOrder,
          text: "Mark Complete",
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

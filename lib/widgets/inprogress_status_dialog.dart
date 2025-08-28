import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';

class InProgressStatusDialog extends StatefulWidget {
  final String statusName;
  final int workOrderID;
  final int newStatusID;
  final VoidCallback onStatusChanged;

  const InProgressStatusDialog({
    super.key,
    required this.statusName,
    required this.workOrderID,
    required this.newStatusID,
    required this.onStatusChanged,
  });

  @override
  State<InProgressStatusDialog> createState() => _InProgressStatusDialogState();
}

class _InProgressStatusDialogState extends State<InProgressStatusDialog> {
  bool enableDowntimeTracking = false;
  bool loading = false;
  DateTime actualStartDT = DateTime.now();
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(actualStartDT);
  }

  Future<void> _pickDateTime() async {
    final picked = await showOmniDateTimePicker(
      context: context,
      initialDate: actualStartDT,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 5,
    );

    if (picked != null) {
      setState(() {
        actualStartDT = picked;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(picked);
      });
    }
  }

  Future<void> _submitStartWorkOrder(BuildContext context) async {
    setState(() => loading = true);
    try {
      await WorkOrderService().startWorkOrder(
        workOrderID: widget.workOrderID,
        workOrderStatusID: widget.newStatusID,
        actualStartDT: actualStartDT,
        enableDowntimeTracking: enableDowntimeTracking,
      );
      widget.onStatusChanged();
      Navigator.pop(context);
      SnackbarService.showSuccess('Work order started.');
    } catch (e) {
      SnackbarService.showError(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Start Work Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text('Technician is starting this job now.'),
          // const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Record downtime (if needed)'),
            value: enableDowntimeTracking,
            onChanged: (val) =>
                setState(() => enableDowntimeTracking = val ?? false),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dateTimeController,
            readOnly: true,
            onTap: _pickDateTime,
            decoration: const InputDecoration(
              labelText: 'Started at',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
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
          onPressed: loading ? null : () => _submitStartWorkOrder(context),
          text: 'Start Work',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }
}

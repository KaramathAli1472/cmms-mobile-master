import 'package:flutter/material.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';
import 'package:maintboard/widgets/primary_button.dart';

class ClosedStatusDialog extends StatefulWidget {
  final String statusName;
  final int workOrderID;
  final int newStatusID;
  final VoidCallback onStatusChanged;

  const ClosedStatusDialog({
    super.key,
    required this.statusName,
    required this.workOrderID,
    required this.newStatusID,
    required this.onStatusChanged,
  });

  @override
  State<ClosedStatusDialog> createState() => _ClosedStatusDialogState();
}

class _ClosedStatusDialogState extends State<ClosedStatusDialog> {
  String _technicianNotes = '';

  Future<void> _submitCloseWorkOrder(BuildContext context) async {
    try {
      await WorkOrderService().closeWorkOrder(
        workOrderID: widget.workOrderID,
        workOrderStatusID: widget.newStatusID,
        closureRemarks: _technicianNotes,
      );
      widget.onStatusChanged();
      SnackbarService.showSuccess('Work order closed successfully.');
    } catch (e) {
      SnackbarService.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mark as Closed?'),
      content: TextField(
        maxLines: 3,
        maxLength: 200,
        onChanged: (val) => _technicianNotes = val,
        decoration: const InputDecoration(
          hintText: 'Technician Notes (optional)',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: "Close Order",
          onPressed: () {
            Navigator.pop(context);
            _submitCloseWorkOrder(context);
          },
        ),
      ],
    );
  }
}

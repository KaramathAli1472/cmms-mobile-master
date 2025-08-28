import 'package:flutter/material.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';

class BacklogStatusDialog extends StatelessWidget {
  final String statusName;
  final int workOrderID;
  final int newStatusID;
  final VoidCallback onStatusChanged;

  const BacklogStatusDialog({
    super.key,
    required this.statusName,
    required this.workOrderID,
    required this.newStatusID,
    required this.onStatusChanged,
  });

  Future<void> _submitBacklogWorkOrder(BuildContext context) async {
    try {
      await WorkOrderService().backlogWorkOrder(
        workOrderID: workOrderID,
        workOrderStatusID: newStatusID,
      );
      onStatusChanged();
      SnackbarService.showSuccess('Status updated to $statusName');
    } catch (e) {
      SnackbarService.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change status to "$statusName"?'),
      content: const Text(
          'Are you sure you want to move this work order to backlog?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _submitBacklogWorkOrder(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

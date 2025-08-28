import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_time/work_order_time_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/work_order_time_service.dart';
import 'package:maintboard/ui/screens/work_order/edit_timelog_screen.dart';
import 'package:maintboard/widgets/modal.dart';

class TimeEditableList extends StatelessWidget {
  final List<WorkOrderTimeResponse> timeLogs;
  final int workOrderID;
  final VoidCallback? onRefreshTimeLogList;

  const TimeEditableList({
    super.key,
    required this.timeLogs,
    required this.workOrderID,
    this.onRefreshTimeLogList,
  });

  void _editTimeLog(
      BuildContext context, WorkOrderTimeResponse log, VoidCallback onEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimelogScreen(
          workOrderID: workOrderID,
          timeLogID: log.workOrderTimeLogID,
          initialTimeSpent: log.hourlyRate,
        ),
      ),
    ).then((result) {
      if (result == true) {
        onEdit();
      }
    });
  }

  Future<void> _deleteTimeLog(
    BuildContext context,
    WorkOrderTimeResponse log,
    VoidCallback onDelete,
  ) async {
    Modal.confirm(
      context,
      'Are you sure you want to delete this time?',
      () async {
        try {
          await WorkOrderTimeService().deleteTimeLog(
            workOrderID: workOrderID,
            workOrderTimeLogID: log.workOrderTimeLogID,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time deleted successfully')),
          );

          onDelete();

          if (onRefreshTimeLogList != null) {
            onRefreshTimeLogList!();
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete time: $e')),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (timeLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No time logs available.'),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    return Column(
      children: timeLogs.map((item) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: ListTile(
            title: Text(DateTimeService.formatDuration(item.hourlyRate)),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editTimeLog(context, item, () {
                    if (onRefreshTimeLogList != null) {
                      onRefreshTimeLogList!();
                    }
                  });
                } else if (value == 'delete') {
                  _deleteTimeLog(context, item, () {
                    if (onRefreshTimeLogList != null) {
                      onRefreshTimeLogList!();
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined, color: Colors.black),
                    title: Text('Edit'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outlined, color: Colors.red),
                    title: Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

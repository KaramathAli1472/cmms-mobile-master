import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_part/work_order_part_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/core/services/part_cache_service.dart';
import 'package:maintboard/core/services/work_order_part_service.dart';
import 'package:maintboard/widgets/modal.dart';

class PartsUsageEditableList extends StatelessWidget {
  final int workOrderID;
  final List<WorkOrderPartResponse> partsUsageList;
  final VoidCallback? onRefreshPartUsageList;

  const PartsUsageEditableList({
    super.key,
    required this.workOrderID,
    required this.partsUsageList,
    this.onRefreshPartUsageList,
  });

  @override
  Widget build(BuildContext context) {
    if (partsUsageList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No parts usage available.'),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    Future<void> _deletePartLog(
      BuildContext context,
      WorkOrderPartResponse log,
      VoidCallback onDelete,
    ) async {
      Modal.confirm(
        context,
        'Are you sure you want to delete this time?',
        () async {
          try {
            await WorkOrderPartService().deleteWorkOrderPart(
              workOrderID: workOrderID,
              workOrderPartID: log.workOrderPartID,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order Part deleted successfully')),
            );

            onDelete();

            if (onRefreshPartUsageList != null) {
              onRefreshPartUsageList!();
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete order part: $e')),
              );
            }
          }
        },
      );
    }

    return Column(
      children: partsUsageList.map((item) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: ListTile(
            leading: Text(
              "${item.quantityUsed} x ",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            title: Text(
              PartCacheService().getPartByID(item.partID).partName,
            ),
            subtitle: Text(
              "${LoginCacheService().getLoginByID(item.installedLoginID)?.contact?.name} used on ${DateTimeService.formatUtcToLocalDateTime(item.modifiedDT)}",
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deletePartLog(context, item, () {
                    if (onRefreshPartUsageList != null) {
                      onRefreshPartUsageList!();
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
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

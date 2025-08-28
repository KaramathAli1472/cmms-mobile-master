import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_part/work_order_part_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/core/services/part_cache_service.dart';

class PartsUsageReadonlyList extends StatelessWidget {
  final List<WorkOrderPartResponse> partsUsageList;

  const PartsUsageReadonlyList({
    super.key,
    required this.partsUsageList,
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
            title: Text(
              PartCacheService().getPartByID(item.partID).partName,
            ),
            subtitle: Text(
              "${LoginCacheService().getLoginByID(item.installedLoginID)?.contact?.name} used on ${DateTimeService.formatUtcToLocalDateTime(item.modifiedDT)}",
            ),
            trailing: Text(
              "x ${item.quantityUsed.toString()}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
        );
      }).toList(),
    );
  }
}

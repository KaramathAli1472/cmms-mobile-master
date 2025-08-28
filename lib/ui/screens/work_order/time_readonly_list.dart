import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_time/work_order_time_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';

class TimeReadonlyList extends StatelessWidget {
  final List<WorkOrderTimeResponse> timeLogs;

  const TimeReadonlyList({
    super.key,
    required this.timeLogs,
  });

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
          ),
        );
      }).toList(),
    );
  }
}

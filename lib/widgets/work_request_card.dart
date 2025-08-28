import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_request/work_request_response.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/ui/screens/work_request/work_request_detail_screen.dart';
import 'package:maintboard/widgets/icon_text_row.dart';
import 'package:maintboard/widgets/priority_indicator.dart';
import 'package:maintboard/widgets/work_request_status.dart';

class WorkRequestCard extends StatelessWidget {
  final WorkRequestResponse request;

  const WorkRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkRequestDetailScreen(
              workRequestID: request.workRequestID,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Work Request Number
                  Text(
                    '#${request.workRequestNumber}',
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  // Asset & Requested Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTextRow(
                        icon: Icons.widgets_outlined,
                        text: request.assetName ?? '-',
                      ),
                      const SizedBox(height: 2),
                      IconTextRow(
                        icon: Icons.person_outline,
                        text: LoginCacheService()
                                .getLoginByID(request.createdLoginID)
                                ?.contact
                                ?.name ??
                            '-',
                      ),
                      const SizedBox(height: 2),
                      IconTextRow(
                        icon: Icons.calendar_today_outlined,
                        text: DateTimeService.formatUtcToLocalDateTime(
                            request.createdDT),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Status and Priority
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WorkRequestStatusIndicator(
                        workRequestStatusID: request.workRequestStatusID,
                      ),
                      PriorityIndicator(priorityID: request.priorityID),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron icon
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_checklist/section_response.dart';

typedef StepToggleCallback = Future<void> Function(int sectionId, int stepId, bool completed);

class PerformChecklistView extends StatelessWidget {
  final int workOrderID;
  final List<SectionResponse> sections;
  final bool isEditable;
  final StepToggleCallback? onStepToggled;
  final Future<void> Function()? onRefresh;

  const PerformChecklistView({
    super.key,
    required this.workOrderID,
    required this.sections,
    this.isEditable = false,
    this.onStepToggled,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.sectionName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  if (section.description != null &&
                      section.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(section.description!,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  const SizedBox(height: 6),
                  ...section.steps.map((step) {
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: Text(step.description ?? step.stepName),
                      value: step.completed,
                      onChanged: isEditable
                          ? (value) async {
                        if (value != null && onStepToggled != null) {
                          await onStepToggled!(
                              section.sectionID, step.workOrderStepID, value);
                        }
                      }
                          : null,
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

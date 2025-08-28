import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_checklist/section_response.dart';

class ViewChecklistScreen extends StatelessWidget {
  final int workOrderID;
  final List<SectionResponse> sections;

  const ViewChecklistScreen({
    super.key,
    required this.workOrderID,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                    onChanged: null, // Read-only
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

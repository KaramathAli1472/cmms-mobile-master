import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order_checklist/section_response.dart';
import 'package:maintboard/widgets/section_card.dart';

class ChecklistSummary extends StatelessWidget {
  final List<SectionResponse> sections;

  const ChecklistSummary({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final summary = _calculateSummary();

    return SectionCard(
      title: "Summary",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem(
              "Pass", summary[1]!, Icons.check_circle, Colors.green),
          _buildSummaryItem("Fail", summary[2]!, Icons.cancel, Colors.red),
          _buildSummaryItem(
              "Warning", summary[null]!, Icons.help_outline, Colors.grey),
        ],
      ),
    );
  }

  /// Calculate summary counts for Pass, Fail, and N/A
  Map<int?, int> _calculateSummary() {
    final Map<int?, int> summary = {1: 0, 2: 0, null: 0};

    for (var section in sections) {
      for (var step in section.steps) {
        if (_isCountableStep(step.stepTypeID)) {
          summary[step.intResult] = (summary[step.intResult] ?? 0) + 1;
        }
      }
    }
    return summary;
  }

  /// Build a summary item with an icon and count
  Widget _buildSummaryItem(
      String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text("$label: $count",
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  /// Determine which step types should be counted in the summary
  bool _isCountableStep(int stepTypeID) {
    return {4, 5, 8, 9}
        .contains(stepTypeID); // PassFail, YesNo, OkNotOk, DoneNotDone
  }
}

import 'package:flutter/material.dart';
import 'custom_list_tile.dart'; // Import the CustomListTile widget

class WorkOrderListTile extends StatelessWidget {
  final String title;
  final String workOrderNumber;
  final String subtitle;
  final bool areFilesAttached;
  final VoidCallback? onTap;

  const WorkOrderListTile({
    super.key,
    required this.title,
    required this.workOrderNumber,
    required this.subtitle,
    this.areFilesAttached = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      title: "$title - #$workOrderNumber",
      subtitle: subtitle,
      areFilesAttached: areFilesAttached,
      onTap: onTap,
    );
  }
}

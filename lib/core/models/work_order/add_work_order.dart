// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class AddWorkOrder {
  final String title;
  final String description;
  final int priorityID;
  final int assetID;
  final DateTime plannedEndDT;
  final int categoryID;
  final int siteID;
  final int workOrderTypeID;
  final List<String> attachments; // Added attachments field

  AddWorkOrder({
    required this.siteID,
    required this.title,
    required this.description,
    required this.assetID,
    required this.priorityID,
    required this.plannedEndDT,
    required this.categoryID,
    required this.workOrderTypeID,
    required this.attachments, // Initialize attachments
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priorityID': priorityID,
      'assetID': assetID,
      'plannedEndDT': plannedEndDT.toIso8601String(),
      'categoryID': categoryID,
      'workOrderTypeID': workOrderTypeID,
      'siteID': siteID,
      'attachments': attachments, // Include attachments in JSON
    };
  }
}

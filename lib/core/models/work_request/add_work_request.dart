// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class AddWorkRequest {
  final int siteID;
  final String title;
  final int? assetID;
  final int priorityID;
  final List<String> attachments; // Added attachments field

  AddWorkRequest({
    required this.siteID,
    required this.title,
    this.assetID,
    required this.priorityID,
    required this.attachments, // Initialize attachments
  });

  Map<String, dynamic> toJson() {
    return {
      'siteID': siteID,
      'title': title,
      'assetID': assetID,
      'priorityID': priorityID,
      'attachments': attachments, // Include attachments in JSON
    };
  }
}

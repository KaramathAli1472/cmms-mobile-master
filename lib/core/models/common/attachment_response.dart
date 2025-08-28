// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class AttachmentResponse {
  final int? attachmentID; // Database generated unique ID - primary key
  final String? url; // Presigned URL
  final String? fileName; // Extracted filename
  final int? fileSize; // File size in bytes
  final String? contentType; // MIME type (e.g., PDF, JPEG)
  final DateTime? lastModifiedDT; // Last updated timestamp

  AttachmentResponse({
    this.attachmentID,
    this.url,
    this.fileName,
    this.fileSize,
    this.contentType,
    this.lastModifiedDT,
  });

  factory AttachmentResponse.fromJson(Map<String, dynamic> json) {
    return AttachmentResponse(
      attachmentID: json['attachmentID'],
      url: json['url'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      contentType: json['contentType'],
      lastModifiedDT: json['lastModifiedDT'] != null
          ? DateTime.parse(json['lastModifiedDT'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attachmentID': attachmentID,
      'url': url,
      'fileName': fileName,
      'fileSize': fileSize,
      'contentType': contentType,
      'lastModifiedDT': lastModifiedDT?.toIso8601String(),
    };
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/common/attachment_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class WorkRequestDetailResponse {
  final int workRequestID;
  final String title;
  final String? description;
  final String workRequestNumber;
  final int workRequestStatusID;
  final DateTime createdDT;
  final int createdLoginID;
  final int? approvedLoginID;
  final DateTime? approvedDT;
  final String? approverComments;
  final int? rejectedLoginID;
  final String? rejectionReason;
  final DateTime? rejectedDT;
  final int? assetID;
  final String? assetName;
  final int? priorityID;
  final String priorityName;
  final int? workOrderStatusID;
  final List<AttachmentResponse> photos;

  WorkRequestDetailResponse({
    required this.workRequestID,
    required this.title,
    this.description,
    required this.workRequestNumber,
    required this.workRequestStatusID,
    required this.createdDT,
    required this.createdLoginID,
    this.approvedLoginID,
    this.approvedDT,
    this.approverComments,
    this.rejectedLoginID,
    this.rejectionReason,
    this.rejectedDT,
    this.assetID,
    this.assetName,
    this.priorityID,
    required this.priorityName,
    this.workOrderStatusID,
    required this.photos,
  });

  factory WorkRequestDetailResponse.fromJson(Map<String, dynamic> json) {
    return WorkRequestDetailResponse(
      workRequestID: requireField<int>(json, 'workRequestID'),
      title: requireField<String>(json, 'title'),
      description: json['description'],
      workRequestNumber: requireField<String>(json, 'workRequestNumber'),
      workRequestStatusID: requireField<int>(json, 'workRequestStatusID'),
      createdDT: DateTime.parse(requireField<String>(json, 'createdDT')),
      createdLoginID: requireField<int>(json, 'createdLoginID'),
      approvedLoginID: json['approvedLoginID'],
      approvedDT: json['approvedDT'] != null
          ? DateTime.parse(json['approvedDT'])
          : null,
      approverComments: json['approverComments'],
      rejectedLoginID: json['rejectedLoginID'],
      rejectionReason: json['rejectionReason'],
      rejectedDT: json['rejectedDT'] != null
          ? DateTime.parse(json['rejectedDT'])
          : null,
      assetID: json['assetID'],
      assetName: json['assetName'],
      priorityID: json['priorityID'],
      priorityName: requireField<String>(json, 'priorityName'),
      workOrderStatusID: json['workOrderStatusID'],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => AttachmentResponse.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class WorkOrderResponse {
  final int workOrderID;
  final String title;
  final String? description;
  final String workOrderNumber;
  final int assetID;
  final String assetName;
  final DateTime? plannedStartDT;
  final DateTime? plannedEndDT;
  final DateTime? actualStartDT;
  final DateTime? actualEndDT;
  final String? resources;
  final int actualDuration;
  final int estimatedDuration;
  final String? action;
  final int createdLoginID;
  final int? completedLoginID;
  final DateTime? lastActivityDT;
  final int workOrderTypeID;
  final int categoryID;
  final int? teamID;
  final int priorityID;
  final String priorityName;
  final int workOrderStatusID;
  final int repeatTypeID;
  final int frequencyTypeID;
  final String workOrderTypeName;
  final List<String> attachments;
  final int attachmentsCount;

  WorkOrderResponse({
    required this.workOrderID,
    required this.title,
    this.description,
    required this.workOrderNumber,
    required this.assetID,
    required this.assetName,
    this.plannedStartDT,
    this.plannedEndDT,
    this.actualStartDT,
    this.actualEndDT,
    this.resources,
    required this.actualDuration,
    required this.estimatedDuration,
    this.action,
    required this.createdLoginID,
    this.completedLoginID,
    this.lastActivityDT,
    required this.workOrderTypeID,
    required this.categoryID,
    this.teamID,
    required this.priorityID,
    required this.priorityName,
    required this.workOrderStatusID,
    required this.repeatTypeID,
    required this.frequencyTypeID,
    required this.workOrderTypeName,
    required this.attachments,
    required this.attachmentsCount,
  });

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderResponse(
      workOrderID: requireField<int>(json, 'workOrderID'),
      title: requireField<String>(json, 'title'),
      description: json['description'],
      workOrderNumber: requireField<String>(json, 'workOrderNumber'),
      assetID: requireField<int>(json, 'assetID'),
      assetName: requireField<String>(json, 'assetName'),
      plannedStartDT: json['plannedStartDT'] != null
          ? DateTime.parse(json['plannedStartDT'])
          : null,
      plannedEndDT: json['plannedEndDT'] != null
          ? DateTime.parse(json['plannedEndDT'])
          : null,
      actualStartDT: json['actualStartDT'] != null
          ? DateTime.parse(json['actualStartDT'])
          : null,
      actualEndDT: json['actualEndDT'] != null
          ? DateTime.parse(json['actualEndDT'])
          : null,
      resources: json['resources'],
      actualDuration: requireField<int>(json, 'actualDuration'),
      estimatedDuration: requireField<int>(json, 'estimatedDuration'),
      action: json['action'],
      createdLoginID: requireField<int>(json, 'createdLoginID'),
      completedLoginID: json['completedLoginID'],
      lastActivityDT: json['lastActivityDT'] != null
          ? DateTime.parse(json['lastActivityDT'])
          : null,
      workOrderTypeID: requireField<int>(json, 'workOrderTypeID'),
      categoryID: requireField<int>(json, 'categoryID'),
      teamID: json['teamID'],
      priorityID: requireField<int>(json, 'priorityID'),
      priorityName: requireField<String>(json, 'priorityName'),
      workOrderStatusID: requireField<int>(json, 'workOrderStatusID'),
      repeatTypeID: requireField<int>(json, 'repeatTypeID'),
      frequencyTypeID: requireField<int>(json, 'frequencyTypeID'),
      workOrderTypeName: requireField<String>(json, 'workOrderTypeName'),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      attachmentsCount: requireField<int>(json, 'attachmentsCount'),
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.

import 'package:maintboard/core/models/common/attachment_response.dart';
import 'package:maintboard/core/utils/json_utils.dart';

class SectionResponse {
  final int sectionID;
  final String sectionName;
  final String? description;
  final int sortOrder;
  final List<StepResponse> steps;

  SectionResponse({
    required this.sectionID,
    required this.sectionName,
    this.description,
    required this.sortOrder,
    required this.steps,
  });

  factory SectionResponse.fromJson(Map<String, dynamic> json) {
    return SectionResponse(
      sectionID: requireField<int>(json, 'sectionID'),
      sectionName: requireField<String>(json, 'sectionName'),
      description: json['description'],
      sortOrder: requireField<int>(json, 'sortOrder'),
      steps: (json['steps'] as List<dynamic>)
          .map((step) => StepResponse.fromJson(step))
          .toList(),
    );
  }
}

class StepResponse {
  int workOrderStepID;
  int sectionID;
  int stepTypeID;
  String? stepTypeName;
  String stepName;
  String? description;
  int sortOrder;
  int? intResult;
  double? numericResult;
  String? textResult;
  AttachmentResponse? attachment;
  bool completed;

  StepResponse({
    required this.workOrderStepID,
    required this.sectionID,
    required this.stepTypeID,
    this.stepTypeName,
    required this.stepName,
    this.description,
    required this.sortOrder,
    this.intResult,
    this.numericResult,
    this.textResult,
    this.attachment,
    this.completed = false,
  });

  factory StepResponse.fromJson(Map<String, dynamic> json) {
    return StepResponse(
      workOrderStepID: requireField<int>(json, 'workOrderStepID'),
      sectionID: requireField<int>(json, 'sectionID'),
      stepTypeID: requireField<int>(json, 'stepTypeID'),
      stepTypeName: json['stepTypeName'],
      stepName: requireField<String>(json, 'stepName'),
      description: json['description'],
      sortOrder: requireField<int>(json, 'sortOrder'),
      intResult: json['intResult'],
      numericResult: (json['numericResult'] as num?)?.toDouble(),
      textResult: json['textResult'],
      attachment: json['attachment'] != null
          ? AttachmentResponse.fromJson(json['attachment'])
          : null,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderStepID': workOrderStepID,
      'sectionID': sectionID,
      'stepTypeID': stepTypeID,
      'stepTypeName': stepTypeName,
      'stepName': stepName,
      'description': description,
      'sortOrder': sortOrder,
      'intResult': intResult,
      'numericResult': numericResult,
      'textResult': textResult,
      'attachment': attachment?.toJson(),
      'completed': completed,
    };
  }
}

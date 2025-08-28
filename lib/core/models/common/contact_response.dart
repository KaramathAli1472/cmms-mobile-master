// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'attachment_response.dart';

class ContactResponse {
  final int? contactID;
  final int? contactTypeID;
  final int? entityID;
  final String? name;
  final String? jobTitle;
  final String? phone;
  final String? email;
  final int? departmentID;
  final String? remarks;
  final bool? isActive;
  final bool? isPrimary;
  final AttachmentResponse? contactPhoto;
  final DateTime? createdDT;
  final DateTime? updatedDT;

  ContactResponse({
    this.contactID,
    this.contactTypeID,
    this.entityID,
    this.name,
    this.jobTitle,
    this.phone,
    this.email,
    this.departmentID,
    this.remarks,
    this.isActive,
    this.isPrimary,
    this.contactPhoto,
    this.createdDT,
    this.updatedDT,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      contactID: json['contactID'],
      contactTypeID: json['contactTypeID'],
      entityID: json['entityID'],
      name: json['name'],
      jobTitle: json['jobTitle'],
      phone: json['phone'],
      email: json['email'],
      departmentID: json['departmentID'],
      remarks: json['remarks'],
      isActive: json['isActive'],
      isPrimary: json['isPrimary'],
      contactPhoto: json['contactPhoto'] != null
          ? AttachmentResponse.fromJson(json['contactPhoto'])
          : null,
      createdDT: json['createdDT'] != null
          ? DateTime.parse(json['createdDT']).toUtc()
          : null,
      updatedDT: json['updatedDT'] != null
          ? DateTime.parse(json['updatedDT']).toUtc()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactID': contactID,
      'contactTypeID': contactTypeID,
      'entityID': entityID,
      'name': name,
      'jobTitle': jobTitle,
      'phone': phone,
      'email': email,
      'departmentID': departmentID,
      'remarks': remarks,
      'isActive': isActive,
      'isPrimary': isPrimary,
      'contactPhoto': contactPhoto?.toJson(),
      'createdDT': createdDT?.toIso8601String(),
      'updatedDT': updatedDT?.toIso8601String(),
    };
  }
}

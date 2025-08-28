import 'package:maintboard/core/utils/json_utils.dart';

class AssetHistoryResponse {
  final int workOrderID;
  final String workOrderNumber;
  final String title;
  final int downtimeDuration;
  final int priorityID;
  final int assetID;
  final int categoryID;
  final int workOrderStatusID;
  final String assetName;
  final String? technicianRemarks;
  final String? closureRemarks;
  final int? completedLoginID;
  final DateTime? actualEndDT;
  final int? requestedLoginID; // ✅ made optional
  final DateTime? requestedDT; // ✅ made optional
  final String? issueCode;
  final String? failureCode;

  AssetHistoryResponse({
    required this.workOrderID,
    required this.workOrderNumber,
    required this.title,
    required this.downtimeDuration,
    required this.priorityID,
    required this.assetID,
    required this.categoryID,
    required this.workOrderStatusID,
    required this.assetName,
    this.requestedLoginID,
    this.requestedDT,
    this.technicianRemarks,
    this.closureRemarks,
    this.completedLoginID,
    this.actualEndDT,
    this.issueCode,
    this.failureCode,
  });

  factory AssetHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AssetHistoryResponse(
      workOrderID: requireField<int>(json, 'workOrderID'),
      workOrderNumber: requireField<String>(json, 'workOrderNumber'),
      title: requireField<String>(json, 'title'),
      downtimeDuration: requireField<int>(json, 'downtimeDuration'),
      priorityID: requireField<int>(json, 'priorityID'),
      assetID: requireField<int>(json, 'assetID'),
      categoryID: requireField<int>(json, 'categoryID'),
      workOrderStatusID: requireField<int>(json, 'workOrderStatusID'),
      assetName: requireField<String>(json, 'assetName'),
      technicianRemarks: json['technicianRemarks'],
      closureRemarks: json['closureRemarks'],
      completedLoginID: json['completedLoginID'],
      actualEndDT: json['actualEndDT'] != null
          ? DateTime.parse(json['actualEndDT'])
          : null,
      requestedLoginID: json['requestedLoginID'] ?? 0,
      requestedDT: json['requestedDT'] != null
          ? DateTime.parse(json['requestedDT'])
          : DateTime.now(),
      issueCode: json['issueCode'] is Map
          ? json['issueCode']['issueCodeName']
          : json['issueCode'],
      failureCode: json['failureCode'] is Map
          ? json['failureCode']['failureCodeName']
          : json['failureCode'],
    );
  }
}

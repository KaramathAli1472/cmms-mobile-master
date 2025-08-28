// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/enums/work_order_status_enum.dart';
import 'package:maintboard/core/models/work_order_status/work_order_status_response.dart';

class WorkOrderStatusCacheService {
  // Singleton Instance
  WorkOrderStatusCacheService._internal();

  static final WorkOrderStatusCacheService _instance =
      WorkOrderStatusCacheService._internal();
  factory WorkOrderStatusCacheService() => _instance;

  // In-memory cache for work order statuses
  final Map<int, String> _statusCache = {};
  List<WorkOrderStatusResponse> _allStatuses = [];

  /// Loads statuses into the cache
  void loadStatuses(List<WorkOrderStatusResponse> statuses) {
    _statusCache.clear();
    _allStatuses = _sortStatusesByControlOrder(statuses);
    for (var status in _allStatuses) {
      _statusCache[status.workOrderStatusID] = status.workOrderStatusName;
    }
  }

  /// Returns the control enum for a given status ID
  WorkOrderStatusControlEnum getControlEnum(int statusID) {
    var status = getStatusByID(statusID);
    return status?.controlEnum ?? WorkOrderStatusControlEnum.backlog;
  }

  /// Fetches the status name by ID
  String getStatusName(int statusID) {
    return _statusCache[statusID] ?? "Unknown";
  }

  /// Fetches the full status object by ID
  WorkOrderStatusResponse? getStatusByID(int statusID) {
    try {
      return _allStatuses.firstWhere(
        (status) => status.workOrderStatusID == statusID,
      );
    } catch (_) {
      return null;
    }
  }

  /// Fetches the full sorted list of statuses
  List<WorkOrderStatusResponse> getAllStatuses() {
    return _allStatuses;
  }

  /// Clears the cache (e.g., during logout)
  void clearCache() {
    _statusCache.clear();
    _allStatuses = [];
  }

  /// Sorts statuses based on predefined controlID order
  List<WorkOrderStatusResponse> _sortStatusesByControlOrder(
      List<WorkOrderStatusResponse> statuses) {
    const List<int> controlOrder = [
      1,
      2,
      3,
      5
    ]; // backlog → inProgress → completed → closed

    statuses.sort((a, b) {
      final int indexA = controlOrder.indexOf(a.controlEnum.controlID);
      final int indexB = controlOrder.indexOf(b.controlEnum.controlID);
      return (indexA == -1 ? 999 : indexA)
          .compareTo(indexB == -1 ? 999 : indexB);
    });

    return statuses;
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maintboard/core/enums/work_order_status_enum.dart';
import 'package:maintboard/core/models/work_order/work_order_detail_response.dart';
import 'package:maintboard/core/models/work_order_checklist/section_response.dart';
import 'package:maintboard/core/models/work_order_part/work_order_part_response.dart';
import 'package:maintboard/core/models/work_order_time/work_order_time_response.dart';
import 'package:maintboard/core/services/category_cache_service.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/language_cache_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/core/services/user_profile_cache_service.dart';
import 'package:maintboard/core/services/work_order_steps_service.dart';
import 'package:maintboard/core/services/work_order_part_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';
import 'package:maintboard/core/services/work_order_status_cache_service.dart';
import 'package:maintboard/core/services/work_order_time_service.dart';
import 'package:maintboard/ui/screens/work_order/add_part_screen.dart';
import 'package:maintboard/ui/screens/work_order/add_time_screen.dart';
import 'package:maintboard/ui/screens/work_order/parts_usage_editable_list.dart';
import 'package:maintboard/ui/screens/work_order/parts_usage_readonly_list.dart';
import 'package:maintboard/ui/screens/work_order/time_editable_list.dart';
import 'package:maintboard/ui/screens/work_order/time_readonly_list.dart';
import 'package:maintboard/ui/screens/work_order/perform_checklist_screen.dart';
import 'package:maintboard/ui/screens/work_order/view_checklist_screen.dart';
import 'package:maintboard/widgets/image_gallary.dart';
import 'package:maintboard/widgets/data_table_row.dart';
import 'package:maintboard/widgets/section_card.dart';
import 'package:maintboard/widgets/work_order_status_indicator.dart';

class WorkOrderDetailScreen extends StatefulWidget {
  final int workOrderID;

  const WorkOrderDetailScreen({super.key, required this.workOrderID});

  @override
  State<WorkOrderDetailScreen> createState() => _WorkOrderDetailScreenState();
}

class _WorkOrderDetailScreenState extends State<WorkOrderDetailScreen> {
  final _logger = Logger();
  late WorkOrderDetailResponse _workOrderDetail;
  List<SectionResponse> _steps = [];
  List<WorkOrderTimeResponse> _timeLogList = [];
  List<WorkOrderPartResponse> _partsUsageList = [];
  bool isWorkOrderEditable = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _fetchWorkOrder();
      await _fetchChecklist();
      await _fetchTimeLogs();
      await _fetchPartsUsageList();
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to load data. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWorkOrder() async {
    try {
      final fetched = await WorkOrderService()
          .fetchWorkOrderDetail(workOrderID: widget.workOrderID);
      setState(() {
        _workOrderDetail = fetched;
        isWorkOrderEditable = WorkOrderStatusCacheService()
            .getControlEnum(fetched.workOrderStatusID) !=
            WorkOrderStatusControlEnum.closed;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to fetch work order.';
      });
    }
  }

  Future<void> _fetchChecklist() async {
    try {
      int? languageID = UserProfileCacheService().getLanguageID();
      String? languageCode;

      if (languageID != null) {
        final language = LanguageCacheService().getLanguageByID(languageID);
        languageCode = language.languageCode;
      }

      final queryParams = {
        'workOrderID': _workOrderDetail.workOrderID,
        'sort': 'StepOrder_asc',
      };

      if (languageCode != null && languageCode.isNotEmpty) {
        queryParams['languageCode'] = languageCode;
      }

      final fetchedChecklist =
      await WorkOrderStepsService().fetchWorkOrderSteps(
        queryParams: queryParams,
      );

      setState(() {
        _steps = fetchedChecklist;
      });
    } catch (e, stackTrace) {
      _logger.e('Checklist Fetch Error', error: e, stackTrace: stackTrace);
      setState(() {
        _errorMessage = 'Failed to load checklist.';
      });
    }
  }

  Future<void> _fetchTimeLogs() async {
    try {
      final loginID = UserProfileCacheService().getLoginID();
      final fetched = await WorkOrderTimeService().fetchWorkOrderTimeLogs(
        queryParams: {
          'workOrderID': _workOrderDetail.workOrderID,
          'loginID': loginID
        },
      );
      setState(() {
        _timeLogList = fetched;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to load time logs.';
      });
    }
  }

  Future<void> _fetchPartsUsageList() async {
    try {
      final fetched = await WorkOrderPartService().fetchWorkOrderParts(
        queryParams: {'workOrderID': _workOrderDetail.workOrderID},
      );
      setState(() {
        _partsUsageList = fetched;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to load parts usage.';
      });
    }
  }

  Future<void> _onStepToggled(int sectionId, int stepId, bool completed) async {
    try {
      await WorkOrderStepsService().updateStepCompletion(
        workOrderId: widget.workOrderID,
        sectionId: sectionId,
        stepId: stepId,
        completed: completed,
      );
      _fetchChecklist();
    } catch (e) {
      _logger.e('Step Toggle Error', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Order Details'),
        leading: BackButton(onPressed: () => Navigator.pop(context, true)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            if (_workOrderDetail.photos.isNotEmpty)
              SectionCard(
                title: 'Attached Photos',
                child: ImageGallery(
                  imageUrls: _workOrderDetail.photos
                      .map((e) => e.url ?? '')
                      .where((u) => u.isNotEmpty)
                      .toList(),
                ),
              ),
            _buildOrderDetailsDisplay(),
            const SizedBox(height: 10),
            _buildTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsDisplay() {
    final isClosed = WorkOrderStatusCacheService()
        .getControlEnum(_workOrderDetail.workOrderStatusID) ==
        WorkOrderStatusControlEnum.closed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isClosed)
          WorkOrderStatusIndicator(
            workOrderStatusID: _workOrderDetail.workOrderStatusID,
            workOrderID: _workOrderDetail.workOrderID,
            onStatusChanged: _fetchData,
          ),
        const SizedBox(height: 12),
        SectionCard(
          title: _workOrderDetail.title,
          subtitle: _workOrderDetail.workOrderNumber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade300),
                ),
                children: [
                  DataTableRow.build(
                    label: 'Asset',
                    value: Text(_workOrderDetail.assetName),
                  ),
                  if (_workOrderDetail.plannedEndDT != null)
                    DataTableRow.build(
                      label: 'Due Date',
                      value: Text(DateTimeService.formatUtcToLocalDateTime(
                          _workOrderDetail.plannedEndDT)),
                    ),
                  DataTableRow.build(
                    label: 'Priority',
                    value: Text(_workOrderDetail.priorityName),
                  ),
                  DataTableRow.build(
                    label: 'Duration',
                    value: Text(DateTimeService.formatDuration(
                        _workOrderDetail.estimatedDuration)),
                  ),
                  if (_workOrderDetail.action != null)
                    DataTableRow.build(
                      label: 'Action',
                      value: Text(_workOrderDetail.action!),
                    ),
                  if (_workOrderDetail.completedLoginID != null)
                    DataTableRow.build(
                      label: 'Completed By',
                      value: Text(LoginCacheService()
                          .getLoginByID(_workOrderDetail.completedLoginID!)
                          ?.contact
                          ?.name ??
                          '-'),
                    ),
                  DataTableRow.build(
                    label: 'Category',
                    value: Text(CategoryCacheService()
                        .getCategoryByID(_workOrderDetail.categoryID)
                        ?.categoryName ??
                        _workOrderDetail.categoryID.toString()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      _workOrderDetail.description ?? '-',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Steps'),
                Tab(text: 'Time Logs'),
                Tab(text: 'Parts Used'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Steps
                  isWorkOrderEditable
                      ? PerformChecklistView(
                    workOrderID: _workOrderDetail.workOrderID,
                    sections: _steps,
                    isEditable: true,
                    onStepToggled: _onStepToggled, // ab error nahi aayega
                    onRefresh: _fetchChecklist,
                  )
                      : ViewChecklistScreen(
                    workOrderID: _workOrderDetail.workOrderID,
                    sections: _steps,
                  ),
                  // Time Logs
                  SectionCard(
                    title: 'Time Logs',
                    trailing: isWorkOrderEditable
                        ? IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add Time',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTimeScreen(
                              workOrderID: _workOrderDetail.workOrderID),
                        ),
                      ).then((r) {
                        if (r == true) _fetchTimeLogs();
                      }),
                    )
                        : null,
                    child: isWorkOrderEditable
                        ? TimeEditableList(
                        timeLogs: _timeLogList,
                        workOrderID: _workOrderDetail.workOrderID,
                        onRefreshTimeLogList: _fetchTimeLogs)
                        : TimeReadonlyList(timeLogs: _timeLogList),
                  ),
                  // Parts Used
                  SectionCard(
                    title: 'Parts Used',
                    trailing: isWorkOrderEditable
                        ? IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add Part',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPartScreen(
                              workOrderID: _workOrderDetail.workOrderID),
                        ),
                      ).then((r) {
                        if (r == true) _fetchPartsUsageList();
                      }),
                    )
                        : null,
                    child: isWorkOrderEditable
                        ? PartsUsageEditableList(
                        workOrderID: _workOrderDetail.workOrderID,
                        partsUsageList: _partsUsageList,
                        onRefreshPartUsageList: _fetchPartsUsageList)
                        : PartsUsageReadonlyList(partsUsageList: _partsUsageList),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

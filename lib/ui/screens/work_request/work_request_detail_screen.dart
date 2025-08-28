// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_request/work_request_detail_response.dart';
import 'package:maintboard/core/services/work_request_service.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/widgets/image_gallary.dart';
import 'package:maintboard/widgets/data_table_row.dart';
import 'package:maintboard/widgets/section_card.dart';
import 'package:maintboard/widgets/work_request_status.dart';

class WorkRequestDetailScreen extends StatefulWidget {
  final int workRequestID;

  const WorkRequestDetailScreen({super.key, required this.workRequestID});

  @override
  State<WorkRequestDetailScreen> createState() =>
      _WorkRequestDetailScreenState();
}

class _WorkRequestDetailScreenState extends State<WorkRequestDetailScreen> {
  WorkRequestDetailResponse? _workRequest;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWorkRequestDetail();
  }

  Future<void> _fetchWorkRequestDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await WorkRequestService()
          .fetchWorkRequestDetail(workRequestID: widget.workRequestID);

      if (mounted) {
        setState(() {
          _workRequest = response;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load work request details.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Request Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _workRequest == null
                  ? const Center(child: Text('Work request not found'))
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView(
                        children: [
                          if (_workRequest!.photos.isNotEmpty)
                            SectionCard(
                              title: "Attached Photos",
                              child: ImageGallery(
                                imageUrls: _workRequest!.photos
                                    .map((e) => e.url ?? '')
                                    .where((url) => url.isNotEmpty)
                                    .toList(),
                              ),
                            ),
                          SectionCard(
                            title: _workRequest!.title,
                            subtitle: _workRequest!.workRequestNumber,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(3),
                                  },
                                  border: TableBorder(
                                    horizontalInside:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  children: [
                                    DataTableRow.build(
                                      label: 'Asset',
                                      value:
                                          Text(_workRequest!.assetName ?? "-"),
                                    ),
                                    DataTableRow.build(
                                      label: 'Priority',
                                      value: Text(_workRequest!.priorityName),
                                    ),
                                    DataTableRow.build(
                                      label: 'Status',
                                      value: WorkRequestStatusIndicator(
                                        workRequestStatusID:
                                            _workRequest!.workRequestStatusID,
                                      ),
                                    ),
                                    DataTableRow.build(
                                      label: 'Requested Date',
                                      value: Text(
                                        DateTimeService
                                            .formatUtcToLocalDateTime(
                                                _workRequest!.createdDT),
                                      ),
                                    ),
                                    DataTableRow.build(
                                      label: 'Requested By',
                                      value: Text(LoginCacheService()
                                              .getLoginByID(_workRequest
                                                      ?.createdLoginID ??
                                                  0)
                                              ?.contact
                                              ?.name ??
                                          '-'),
                                    ),
                                    DataTableRow.build(
                                      label: 'Approved By',
                                      value: Text(LoginCacheService()
                                              .getLoginByID(_workRequest
                                                      ?.approvedLoginID ??
                                                  0)
                                              ?.contact
                                              ?.name ??
                                          '-'),
                                    ),
                                    if (_workRequest!.approvedDT != null)
                                      DataTableRow.build(
                                        label: 'Approved Date',
                                        value: Text(
                                          DateTimeService
                                              .formatUtcToLocalDateTime(
                                                  _workRequest!.approvedDT!),
                                        ),
                                      ),
                                    if (_workRequest!.approverComments != null)
                                      DataTableRow.build(
                                        label: 'Approver Comments',
                                        value: Text(
                                            _workRequest!.approverComments!),
                                      ),
                                    if (_workRequest!.rejectedLoginID != null)
                                      DataTableRow.build(
                                        label: 'Rejected By',
                                        value: Text(LoginCacheService()
                                                .getLoginByID(_workRequest
                                                        ?.rejectedLoginID ??
                                                    0)
                                                ?.contact
                                                ?.name ??
                                            '-'),
                                      ),
                                    if (_workRequest!.rejectionReason != null)
                                      DataTableRow.build(
                                        label: 'Rejection Reason',
                                        value: Text(
                                            _workRequest!.rejectionReason!),
                                      ),
                                    if (_workRequest!.rejectedDT != null)
                                      DataTableRow.build(
                                        label: 'Rejected Date',
                                        value: Text(
                                          DateTimeService
                                              .formatUtcToLocalDateTime(
                                                  _workRequest!.rejectedDT!),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Description',
                                          style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 4),
                                      Text(
                                        _workRequest!.description ??
                                            'No description provided',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
    );
  }
}

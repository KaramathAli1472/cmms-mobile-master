import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_history_response.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/services/asset_history_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/widgets/asset_maintenance_log_widget.dart';
import 'package:maintboard/widgets/data_table_row.dart';
import 'package:maintboard/widgets/image_gallary.dart';
import 'package:maintboard/widgets/section_card.dart';

class AssetDetailScreen extends StatefulWidget {
  final AssetResponse asset;

  const AssetDetailScreen({super.key, required this.asset});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<AssetHistoryResponse> _workOrderHistory = [];
  bool _isMaintenanceLogLoading = true;
  bool _isLoadMoreLoading = false;
  bool _hasLogError = false;
  int _currentPageNumber = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchWorkOrderHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchWorkOrderHistory({bool isLoadMore = false}) async {
    try {
      setState(() {
        if (isLoadMore) {
          _isLoadMoreLoading = true;
        } else {
          _isMaintenanceLogLoading = true;
          _hasLogError = false;
        }
      });

      final int? siteID = await SharedPreferenceService.getCurrentSiteID();
      final queryParams = {
        'pageNumber': _currentPageNumber,
        'rowsPerPage': _rowsPerPage,
        'assetID': widget.asset.assetID,
        'siteID': siteID,
        'sort': 'WorkOrderID_DESC',
      };

      final results = await AssetHistoryService()
          .fetchAssetHistory(queryParams: queryParams);

      setState(() {
        if (isLoadMore) {
          _workOrderHistory.addAll(results);
        } else {
          _workOrderHistory = results;
        }
        _isMaintenanceLogLoading = false;
        _isLoadMoreLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error fetching asset history: $e');
      debugPrintStack(stackTrace: stackTrace);

      SnackbarService.showError('Failed to fetch asset history: $e');

      setState(() {
        _hasLogError = true;
        _isMaintenanceLogLoading = false;
        _isLoadMoreLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Asset Details'),
          leading: BackButton(onPressed: () => Navigator.pop(context, true)),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Maintenance Log'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Details Tab
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ListView(
                      children: [
                        SectionCard(
                          title: widget.asset.assetName,
                          subtitle: widget.asset.assetCode ?? "-",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.asset.photo?.url != null &&
                                  widget.asset.photo!.url!.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ImageGallery(
                                    imageUrls: [widget.asset.photo!.url!],
                                  ),
                                ),
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
                                    label: 'Location',
                                    value: Text(
                                        widget.asset.fullLocationPathDisplay ??
                                            "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Asset Type',
                                    value: Text(
                                        widget.asset.assetType!.assetTypeName),
                                  ),
                                  DataTableRow.build(
                                    label: 'Serial Number',
                                    value:
                                        Text(widget.asset.serialNumber ?? "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Manufacturer',
                                    value:
                                        Text(widget.asset.manufacturer ?? "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Model',
                                    value: Text(widget.asset.model ?? "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Supplier',
                                    value: Text(widget.asset.supplier ?? "-"),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       const Text('Description',
                              //           style: TextStyle(color: Colors.grey)),
                              //       const SizedBox(height: 4),
                              //       Text(
                              //         widget.asset.description ?? '-',
                              //         style:
                              //             const TextStyle(color: Colors.black),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Maintenance Log Tab
                  AssetMaintenanceLogWidget(assetID: widget.asset.assetID),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

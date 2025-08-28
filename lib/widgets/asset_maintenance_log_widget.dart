// lib/widgets/asset_maintenance_log_widget.dart

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_history_response.dart';
import 'package:maintboard/core/services/asset_history_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/ui/screens/work_order/work_order_detail_screen.dart';
import 'package:maintboard/widgets/work_order_history_card.dart';
import 'package:maintboard/widgets/primary_button.dart';

class AssetMaintenanceLogWidget extends StatefulWidget {
  final int assetID;

  const AssetMaintenanceLogWidget({super.key, required this.assetID});

  @override
  State<AssetMaintenanceLogWidget> createState() =>
      _AssetMaintenanceLogWidgetState();
}

class _AssetMaintenanceLogWidgetState extends State<AssetMaintenanceLogWidget> {
  List<AssetHistoryResponse> _history = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isLoadMore = false;
  int _page = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory({bool loadMore = false}) async {
    try {
      if (loadMore) {
        setState(() => _isLoadMore = true);
      } else {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      }

      final siteID = await SharedPreferenceService.getCurrentSiteID();
      final queryParams = {
        'pageNumber': _page,
        'rowsPerPage': _rowsPerPage,
        'assetID': widget.assetID,
        'siteID': siteID,
        'sort': 'WorkOrderID_DESC',
      };

      final results = await AssetHistoryService()
          .fetchAssetHistory(queryParams: queryParams);

      setState(() {
        if (loadMore) {
          _history.addAll(results);
        } else {
          _history = results;
        }
        _isLoading = false;
        _isLoadMore = false;
      });
    } catch (e, stack) {
      debugPrint('Error fetching asset history: $e');
      debugPrintStack(stackTrace: stack);
      SnackbarService.showError('Failed to fetch asset history: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
        _isLoadMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
          child: Text('Failed to load history',
              style: TextStyle(color: Colors.red)));
    }

    if (_history.isEmpty) {
      return const Center(child: Text('No history available for this asset.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        _page = 0;
        await _fetchHistory();
      },
      child: ListView.builder(
        itemCount: _history.length + 1,
        itemBuilder: (context, index) {
          if (index == _history.length) {
            return _isLoadMore
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: PrimaryButton(
                      text: 'Load More',
                      onPressed: () {
                        _page += 1;
                        _fetchHistory(loadMore: true);
                      },
                    ),
                  );
          }

          final order = _history[index];
          return WorkOrderHistoryCard(
            workOrder: order,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorkOrderDetailScreen(workOrderID: order.workOrderID),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/models/work_request/add_work_request.dart';
import 'package:maintboard/core/models/work_request/work_request_response.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/work_request_service.dart';
import 'package:maintboard/search_provider.dart';
import 'package:maintboard/ui/screens/work_request/work_request_detail_screen.dart';
import 'package:maintboard/widgets/add_work_request_form.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:maintboard/widgets/primary_floating_button.dart';
import 'package:maintboard/widgets/work_order_list_tile.dart';
import 'package:maintboard/widgets/work_request_card.dart';

class WorkRequestListScreen extends ConsumerStatefulWidget {
  const WorkRequestListScreen({super.key});

  @override
  ConsumerState<WorkRequestListScreen> createState() =>
      _WorkRequestListScreenState();
}

class _WorkRequestListScreenState extends ConsumerState<WorkRequestListScreen> {
  List<WorkRequestResponse> _workRequests = [];
  bool _isLoading = true;
  bool _isLoadMoreLoading = false;
  int _currentPage = 0;
  final int _rowsPerPage = 20;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchWorkRequests(); // ✅ Fetch on first load
  }

  Future<void> _fetchWorkRequests({bool isLoadMore = false}) async {
    if (_isFetchingMore) return; // ✅ Prevent duplicate calls
    _isFetchingMore = true;

    try {
      if (!isLoadMore) {
        setState(() => _isLoading = true); // ✅ Show loading only for first load
        _currentPage = 0;
      } else {
        setState(() => _isLoadMoreLoading = true); // ✅ Show Load More loading
      }

      final int? siteID = await SharedPreferenceService.getCurrentSiteID();
      final searchQuery = ref.read(searchQueryProvider);
      final newWorkRequests = await WorkRequestService().fetchWorkRequests(
        queryParams: {
          'siteID': siteID,
          'pageNumber': _currentPage,
          'rowsPerPage': _rowsPerPage,
          'searchTerm': searchQuery,
          'sort': 'WorkRequestID_DESC',
        },
      );

      setState(() {
        if (isLoadMore) {
          _workRequests.addAll(newWorkRequests); // ✅ Append new items
        } else {
          _workRequests = newWorkRequests; // ✅ Fresh load
        }
        _currentPage++; // ✅ Increase page number
      });
    } catch (e) {
      debugPrint("Error fetching work requests: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadMoreLoading = false; // ✅ Reset Load More state
      });
      _isFetchingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (previous != next) {
        _currentPage = 0;
        _fetchWorkRequests(); // ✅ Fetch when search changes
      }
    });

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchWorkRequests(),
              child: _workRequests.isEmpty
                  ? const Center(child: Text('No work requests found'))
                  : ListView.builder(
                      itemCount: _workRequests.length + 1, // ✅ +1 for Load More
                      itemBuilder: (context, index) {
                        if (index == _workRequests.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isLoadMoreLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : PrimaryButton(
                                    text: 'Load More',
                                    onPressed: () =>
                                        _fetchWorkRequests(isLoadMore: true),
                                  ),
                          );
                        }

                        final request = _workRequests[index];

                        return WorkRequestCard(
                          request: request,
                        );
                      },
                    ),
            ),
      floatingActionButton: PrimaryFloatingButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddWorkRequestForm(
                onRequestAdded: (AddWorkRequest workRequest) async {
                  await _fetchWorkRequests();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Work Request Added.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

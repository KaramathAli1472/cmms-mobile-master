import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/core/services/part_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/search_provider.dart';
import 'package:maintboard/widgets/part_card.dart';
import 'package:maintboard/widgets/primary_button.dart';

class PartListScreen extends ConsumerStatefulWidget {
  const PartListScreen({super.key});

  @override
  ConsumerState<PartListScreen> createState() => _PartListScreenState();
}

class _PartListScreenState extends ConsumerState<PartListScreen> {
  List<PartResponse> _parts = [];
  bool _isLoading = true;
  bool _isLoadMoreLoading = false;
  int _currentPage = 0;
  final int _rowsPerPage = 20;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchParts(); // ✅ Fetch on first load
  }

  Future<void> _fetchParts({bool isLoadMore = false}) async {
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
      final newParts = await PartService().fetchPartList(
        queryParams: {
          'siteID': siteID,
          'pageNumber': _currentPage,
          'rowsPerPage': _rowsPerPage,
          'searchTerm': searchQuery,
          'sort': 'PartName_ASC',
        },
      );

      setState(() {
        if (isLoadMore) {
          _parts.addAll(newParts); // ✅ Append new items
        } else {
          _parts = newParts; // ✅ Fresh load
        }
        _currentPage++; // ✅ Increase page number
      });
    } catch (e) {
      debugPrint("Error fetching parts: $e");
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
        _fetchParts(); // ✅ Fetch when search changes
      }
    });

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchParts(),
              child: _parts.isEmpty
                  ? const Center(child: Text('No inventory items found'))
                  : ListView.builder(
                      itemCount: _parts.length + 1, // ✅ +1 for Load More
                      itemBuilder: (context, index) {
                        if (index == _parts.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isLoadMoreLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : PrimaryButton(
                                    text: 'Load More',
                                    onPressed: () =>
                                        _fetchParts(isLoadMore: true),
                                  ),
                          );
                        }

                        final part = _parts[index];

                        return PartCard(part: part);
                        ;
                      },
                    ),
            ),
    );
  }
}

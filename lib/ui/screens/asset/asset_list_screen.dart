import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/services/asset_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/search_provider.dart';
import 'package:maintboard/ui/screens/asset/asset_detail_screen.dart';
import 'package:maintboard/widgets/asset_card.dart';
import 'package:maintboard/widgets/custom_list_tile.dart';
import 'package:maintboard/widgets/primary_button.dart';

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  List<AssetResponse> _assets = [];
  bool _isLoading = true;
  bool _isLoadMoreLoading = false;
  int _currentPage = 0;
  final int _rowsPerPage = 20;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchAssets(); // ✅ Fetch on first load
  }

  Future<void> _fetchAssets({bool isLoadMore = false}) async {
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
      final newAssets = await AssetService().fetchAssetList(
        queryParams: {
          'siteID': siteID,
          'pageNumber': _currentPage,
          'rowsPerPage': _rowsPerPage,
          'searchTerm': searchQuery,
          'sort': 'AssetName_ASC',
        },
      );

      setState(() {
        if (isLoadMore) {
          _assets.addAll(newAssets); // ✅ Append new items
        } else {
          _assets = newAssets; // ✅ Fresh load
        }
        _currentPage++; // ✅ Increase page number
      });
    } catch (e) {
      debugPrint("Error fetching assets: $e");
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
        _fetchAssets(); // ✅ Fetch when search changes
      }
    });

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchAssets(),
              child: _assets.isEmpty
                  ? const Center(child: Text('No assets found'))
                  : ListView.builder(
                      itemCount: _assets.length + 1, // ✅ +1 for Load More
                      itemBuilder: (context, index) {
                        if (index == _assets.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isLoadMoreLoading
                                ? const Center(
                                    child:
                                        CircularProgressIndicator()) // ✅ Show loading
                                : PrimaryButton(
                                    text: 'Load More',
                                    onPressed: () =>
                                        _fetchAssets(isLoadMore: true),
                                  ),
                          );
                        }

                        final asset = _assets[index];
                        return AssetCard(asset: asset);
                      },
                    ),
            ),
    );
  }
}

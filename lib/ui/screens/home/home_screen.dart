// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/models/work_request/add_work_request.dart';
import 'package:maintboard/core/services/asset_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/user_profile_cache_service.dart';
import 'package:maintboard/core/services/work_order_status_cache_service.dart';
import 'package:maintboard/search_provider.dart';
import 'package:maintboard/ui/screens/asset/asset_list_screen.dart';
import 'package:maintboard/ui/screens/asset/asset_maintenance_log_screen.dart';
import 'package:maintboard/ui/screens/part/part_list_screen.dart';
import 'package:maintboard/ui/screens/qrcode_scanner/qr_scanner_screen.dart';
import 'package:maintboard/ui/screens/work_order/work_order_list_screen.dart';
import 'package:maintboard/ui/screens/work_request/work_request_list_screen.dart';
import 'package:maintboard/widgets/add_work_request_form.dart';
import 'package:maintboard/widgets/data_table_row.dart';
import 'package:maintboard/widgets/modal.dart';
import 'package:maintboard/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool _isSearching = false;
  String _appBarTitle = "Orders";

  final List<Map<String, dynamic>?> _screens = [
    {"widget": WorkOrderListScreen(), "title": "Orders"},
    {"widget": WorkRequestListScreen(), "title": "Requests"},
    null, // QR tab
    {"widget": AssetListScreen(), "title": "Assets"},
    {"widget": PartListScreen(), "title": "Parts"},
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QRScannerScreen(
            onScanned: (qrUrl) async {
              try {
                final tokenResponse =
                    await AssetService().fetchAssetByQRCodeUrl(qrUrl);

                final asset = AssetResponse.fromToken(tokenResponse);

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.6,
                      minChildSize: 0.3,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                asset.assetName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                      label: 'Asset Code',
                                      value: Text(asset.assetCode ?? '-')),
                                  DataTableRow.build(
                                      label: 'Serial Number',
                                      value: Text(asset.serialNumber ?? '-')),
                                  DataTableRow.build(
                                      label: 'Model',
                                      value: Text(asset.model ?? '-')),
                                  DataTableRow.build(
                                      label: 'Manufacturer',
                                      value: Text(asset.manufacturer ?? '-')),
                                  if (asset.fullLocationPath != null &&
                                      asset.fullLocationPath!.isNotEmpty)
                                    DataTableRow.build(
                                      label: 'Location',
                                      value:
                                          Text(asset.fullLocationPathDisplay),
                                    ),
                                  if (asset.fullAssetPath != null &&
                                      asset.fullAssetPath!.isNotEmpty)
                                    DataTableRow.build(
                                      label: 'Asset Hierarchy',
                                      value: Text(asset.fullAssetPathDisplay),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              ListTile(
                                leading: const Icon(Icons.add_circle_outline),
                                title: const Text('Create Work Request'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(Duration.zero, () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddWorkRequestForm(
                                          prefilledAsset: asset,
                                          onRequestAdded: (AddWorkRequest
                                              workRequest) async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Work Request Added.'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.history),
                                title: const Text('View Maintenance Log Book'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(Duration.zero, () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AssetMaintenanceLogScreen(
                                                asset: asset),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              } catch (e) {
                SnackbarService.showError('Failed to fetch asset info.');
              }
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index >= 2 ? index : index;
      _appBarTitle = _screens[index]?["title"] ?? "";
      _isSearching = false;
    });
  }

  Future<void> _logout() async {
    try {
      await _firebaseAuth.signOut();
      WorkOrderStatusCacheService().clearCache();
      SharedPreferenceService.clearAll();
      Navigator.pushReplacementNamed(context, '/');
      SnackbarService.showSuccess('Logout successful');
    } catch (e) {
      SnackbarService.showError(e.toString());
    }
  }

  Widget _buildNavIcon(BuildContext context, int index, IconData icon) {
    final bool isSelected = _selectedIndex == index;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withAlpha((0.20 * 255).round())
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? primaryColor : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Consumer(
                builder: (context, ref, child) {
                  return SearchBarWidget(
                    hintText: "Search $_appBarTitle...",
                    onClose: () {
                      setState(() {
                        _isSearching = false;
                      });
                      ref.read(searchQueryProvider.notifier).state = "";
                    },
                  );
                },
              )
            : Text(_appBarTitle),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                  if (!_isSearching) {
                    ref.read(searchQueryProvider.notifier).state = "";
                  }
                },
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex]?["widget"] ?? const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, 0, Icons.assignment_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, 1, Icons.campaign_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, 3, Icons.widgets_outlined),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(context, 4, Icons.handyman_outlined),
            label: 'Parts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserProfileCacheService()
                                    .getDefaultImageUrl()
                                    .isNotEmpty
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        UserProfileCacheService()
                                            .getDefaultImageUrl()),
                                    onBackgroundImageError: (_, __) async {
                                      final connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();
                                      if (connectivityResult
                                          .contains(ConnectivityResult.none)) {
                                        SnackbarService.showError(
                                            "No internet connection");
                                      } else {
                                        SnackbarService.showError(
                                            "Failed to load profile image");
                                      }
                                    },
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey[800],
                                    child: Text(
                                      UserProfileCacheService().getInitials(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Text(
                              UserProfileCacheService().getFullName(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              UserProfileCacheService().getRole(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Modal.confirm(
                  context,
                  'Are you sure you want to logout?',
                  () async {
                    await _logout();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

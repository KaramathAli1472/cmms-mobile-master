// lib/ui/screens/asset/asset_maintenance_log_screen.dart

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/widgets/asset_maintenance_log_widget.dart';

class AssetMaintenanceLogScreen extends StatelessWidget {
  final AssetResponse asset;

  const AssetMaintenanceLogScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${asset.assetName} - Maintenance Log'),
      ),
      body: AssetMaintenanceLogWidget(assetID: asset.assetID),
    );
  }
}

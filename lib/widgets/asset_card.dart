import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/ui/screens/asset/asset_detail_screen.dart';
import 'package:maintboard/widgets/icon_text_row.dart';

class AssetCard extends StatelessWidget {
  final AssetResponse asset;

  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetailScreen(asset: asset),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset Name
                  Text(
                    asset.assetName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Asset Code (if present)
                  if (asset.assetCode != null &&
                      asset.assetCode!.trim().isNotEmpty)
                    Text(
                      '#${asset.assetCode}',
                      style: const TextStyle(color: Colors.grey),
                    ),

                  const SizedBox(height: 10),

                  // Location
                  IconTextRow(
                    icon: Icons.location_on_outlined,
                    text: asset.fullLocationPathDisplay ?? 'Unknown Location',
                  ),
                ],
              ),
            ),

            // Chevron icon
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

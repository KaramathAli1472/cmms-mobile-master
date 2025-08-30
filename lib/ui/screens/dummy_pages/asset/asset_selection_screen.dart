import 'package:flutter/material.dart';

class AssetSelectionScreen extends StatefulWidget {
  const AssetSelectionScreen({super.key});

  @override
  State<AssetSelectionScreen> createState() => _AssetSelectionScreenState();
}

class _AssetSelectionScreenState extends State<AssetSelectionScreen> {
  int? selectedIndex;

  void _createAsset() {
    // Asset creation logic yahan add karein
    // Filhal koi asset list nahi hai
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Asset pressed')),
    );
  }

  void _onDone() {
    Navigator.pop(context);
  }

  void _onScan() {
    // Scan functionality yahan add karein
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        actions: [
          TextButton(
            onPressed: _onDone,
            child: const Text('DONE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan',
            onPressed: _onScan,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Create Asset Button just below search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: InkWell(
              onTap: _createAsset,
              child: Row(
                children: const [
                  Icon(Icons.add_circle, color: Colors.blue, size: 24),
                  SizedBox(width: 8),
                  Text("Create Asset",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
          // No asset list as requested
        ],
      ),
    );
  }
}

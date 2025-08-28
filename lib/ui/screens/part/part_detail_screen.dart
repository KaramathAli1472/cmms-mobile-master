import 'package:flutter/material.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/widgets/data_table_row.dart';
import 'package:maintboard/widgets/section_card.dart';

class PartDetailScreen extends StatefulWidget {
  final PartResponse inventory;

  const PartDetailScreen({super.key, required this.inventory});

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Part Details'),
          leading: BackButton(onPressed: () => Navigator.pop(context, true)),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Usage History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // DETAILS TAB
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView(
                      children: [
                        if (widget.inventory.defaultImageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Image.network(
                              widget.inventory.defaultImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                        SectionCard(
                          title: widget.inventory.partName,
                          subtitle: widget.inventory.partCode ?? "-",
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
                                    label: 'Store Room',
                                    value: Text(widget.inventory.storeRoomName),
                                  ),
                                  DataTableRow.build(
                                    label: 'Stock Level',
                                    value: Text(widget
                                        .inventory.quantityAvailable
                                        .toString()),
                                  ),
                                  DataTableRow.build(
                                    label: 'Critical',
                                    value: Text(widget.inventory.isCritical
                                        ? 'Yes'
                                        : 'No'),
                                  ),
                                  DataTableRow.build(
                                    label: 'Serial Number',
                                    value: Text(
                                        widget.inventory.serialNumber ?? "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Model',
                                    value: Text(widget.inventory.model ?? "-"),
                                  ),
                                  DataTableRow.build(
                                    label: 'Manufacturer',
                                    value: Text(
                                        widget.inventory.manufacturer ?? "-"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.inventory.description!,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // USAGE HISTORY TAB
                  const Center(
                    child: Text("Usage history will be displayed here."),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

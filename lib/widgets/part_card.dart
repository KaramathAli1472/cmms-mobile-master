import 'package:flutter/material.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/ui/screens/part/part_detail_screen.dart';
import 'package:maintboard/widgets/icon_text_row.dart';
import 'package:maintboard/widgets/tonal_chip.dart';

class PartCard extends StatelessWidget {
  final PartResponse part;

  const PartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartDetailScreen(inventory: part),
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
                  Text(
                    part.partName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (part.partCode != null && part.partCode!.trim().isNotEmpty)
                    Text(
                      '#${part.partCode}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 10),
                  IconTextRow(
                    icon: Icons.location_on_outlined,
                    text: part.storeRoomName,
                  ),
                  const SizedBox(height: 20),
                  TonalChip(
                    label: part.quantity > 0
                        ? '${part.quantity} available'
                        : 'Out of stock',
                    baseColor: part.quantity > 0 ? Colors.green : Colors.red,
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

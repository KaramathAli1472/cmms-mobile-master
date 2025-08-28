// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/widgets/full_screen_image_viewer.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: index < imageUrls.length
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrls: imageUrls,
                            initialIndex: index,
                          ),
                        ),
                      );
                    }
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: index < imageUrls.length
                    ? Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 80);
                        },
                      )
                    : Container(color: Colors.transparent), // Placeholder
              ),
            ),
          ),
        );
      }),
    );
  }
}

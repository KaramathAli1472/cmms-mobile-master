// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'dart:io';
import 'package:flutter/material.dart';

class DrawOnImageScreen extends StatefulWidget {
  final File imageFile;

  const DrawOnImageScreen({super.key, required this.imageFile});

  @override
  _DrawOnImageScreenState createState() => _DrawOnImageScreenState();
}

class _DrawOnImageScreenState extends State<DrawOnImageScreen> {
  List<Offset?> points = []; // Stores points for freehand drawing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw on Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(); // Handle saving if needed
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.file(
            widget.imageFile,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null); // Add null to break the line
              });
            },
            child: CustomPaint(
              painter: ImageDrawingPainter(points: points),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageDrawingPainter extends CustomPainter {
  final List<Offset?> points;

  ImageDrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? prependIcon;
  final IconData? appendIcon;

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.prependIcon,
    this.appendIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Adapts button size to content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          else ...[
            if (prependIcon != null) ...[
              Icon(prependIcon, size: 16),
              const SizedBox(width: 8), // Space between icon and text
            ],
            Text(text),
            if (appendIcon != null) ...[
              const SizedBox(width: 8), // Space between text and icon
              Icon(appendIcon, size: 16),
            ],
          ],
        ],
      ),
    );
  }
}

// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';

class PrimaryFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const PrimaryFloatingButton(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: child,
    );
  }
}

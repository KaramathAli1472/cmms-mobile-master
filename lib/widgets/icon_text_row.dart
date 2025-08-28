import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final bool truncate;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black87,
    this.textColor = Colors.black87,
    this.iconSize = 18,
    this.fontSize = 14,
    this.truncate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: textColor),
            overflow: truncate ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }
}

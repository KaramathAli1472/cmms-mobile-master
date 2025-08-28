import 'package:flutter/material.dart';

class DataTableRow {
  static TableRow build({
    required String label,
    required Widget value,
    IconData? icon,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(icon, size: 16, color: Colors.grey),
                ),
              Text(
                label,
                style: labelStyle ?? const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle.merge(
            style: valueStyle ?? const TextStyle(color: Colors.black),
            child: value,
          ),
        ),
      ],
    );
  }
}

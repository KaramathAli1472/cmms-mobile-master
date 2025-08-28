import 'package:flutter/material.dart';

class TonalChip extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final Color baseColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const TonalChip({
    super.key,
    this.label,
    this.labelWidget,
    required this.baseColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: labelWidget ??
          Text(
            label!,
            style: textStyle ??
                const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
          ),
      backgroundColor: baseColor.withAlpha((0.15 * 255).round()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: baseColor.withAlpha((0.40 * 255).round()),
          width: 1,
        ),
      ),
      padding: padding,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

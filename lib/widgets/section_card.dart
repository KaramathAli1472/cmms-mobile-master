import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null || (subtitle != null && subtitle!.isNotEmpty))
                ListTile(
                  title: title != null && title!.isNotEmpty
                      ? Text(title!,
                          style: Theme.of(context).textTheme.titleMedium)
                      : null,
                  subtitle: subtitle != null && subtitle!.isNotEmpty
                      ? Text(subtitle!)
                      : null,
                  contentPadding: EdgeInsets.zero,
                  trailing: trailing != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [trailing!],
                        )
                      : null,
                ),
              if (title == null && subtitle == null) const SizedBox(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

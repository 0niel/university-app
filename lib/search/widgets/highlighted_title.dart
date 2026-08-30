import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HighlightedTitle extends StatelessWidget {
  const HighlightedTitle({
    required this.name,
    required this.query,
    super.key,
    this.baseColor,
    this.highlightColor,
  });

  final String name;
  final String query;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final baseStyle = NinjaText.title.copyWith(
      color: baseColor ?? colors.ink,
    );

    final trimmed = query.trim();
    final start = trimmed.isEmpty
        ? -1
        : name.toLowerCase().indexOf(trimmed.toLowerCase());
    if (start < 0) {
      return Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }
    final end = start + trimmed.length;

    return Text.rich(
      TextSpan(
        children: [
          if (start > 0) TextSpan(text: name.substring(0, start)),
          TextSpan(
            text: name.substring(start, end),
            style: baseStyle.copyWith(
              color: highlightColor ?? colors.brand,
            ),
          ),
          if (end < name.length) TextSpan(text: name.substring(end)),
        ],
        style: baseStyle,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

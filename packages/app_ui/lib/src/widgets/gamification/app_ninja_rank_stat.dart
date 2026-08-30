import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppNinjaRankStat extends StatelessWidget {
  const AppNinjaRankStat({
    required this.value,
    required this.label,
    required this.color,
    super.key,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppText.title.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: AppText.captionSmall.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

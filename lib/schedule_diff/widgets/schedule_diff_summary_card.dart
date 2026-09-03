import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleDiffSummaryCard extends StatelessWidget {
  const ScheduleDiffSummaryCard({
    required this.count,
    required this.label,
    required this.color,
    required this.icon,
    super.key,
  });
  final int count;
  final String label;
  final Color color;
  final AppLineIcon icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scale = Theme.of(context).scale;
    return Container(
      padding: .all(scale.space(16)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        children: [
          AppLineIconWidget(icon, color: color),
          SizedBox(height: scale.space(12)),
          Text(
            '$count',
            style: AppText.title.copyWith(
              fontWeight: .bold,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppText.subtext.copyWith(
              color: colors.muted,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }
}

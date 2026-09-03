import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class EventsEmptyCard extends StatelessWidget {
  const EventsEmptyCard({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentGap,
        vertical: AppSpacing.sheetBottom,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.section.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.xsm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppText.sans(13.5, FontWeight.w500).copyWith(
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

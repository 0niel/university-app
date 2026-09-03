import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchCoachCallout extends StatelessWidget {
  const SearchCoachCallout({
    required this.title,
    required this.body,
    required this.gesture,
    super.key,
  });

  final String title;
  final String body;
  final String gesture;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppText.headline.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: AppText.body.copyWith(color: colors.muted),
            ),
            const SizedBox(height: 12),
            Text(
              gesture,
              style: AppText.button.copyWith(color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

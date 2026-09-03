import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TrendingRow extends StatelessWidget {
  const TrendingRow({required this.item, required this.onTap, super.key});

  final TrendingSearch item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = item.count > 0
        ? context.l10n.searchTrendingTimes(item.count)
        : null;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: [item.query, ?count].join(', '),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: SizedBox.square(
                dimension: 42,
                child: AppLineIconWidget(
                  AppLineIcon.chart,
                  size: 19,
                  color: colors.accent,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.query,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (count != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      count,
                      style: AppText.subtext.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.sm,
              color: colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}

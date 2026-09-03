part of '../create_schedule_page.dart';

class _WayCard extends StatelessWidget {
  const _WayCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.recommended = false,
    this.badge,
  });

  final AppLineIcon icon;
  final String title;
  final String description;
  final bool recommended;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final badge = this.badge;
    return AppCard(
      onTap: onTap,
      semanticsLabel: title,
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          Container(
            width: AppControlSize.touchTarget,
            height: AppControlSize.touchTarget,
            margin: const .only(right: AppSpacing.xsm),
            decoration: BoxDecoration(
              color: colors.tint,
              shape: .circle,
            ),
            child: Center(
              child: AppLineIconWidget(
                icon,
                size: 21,
                color: colors.accent,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: ScheduleMetrics.compactGap,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppText.body.copyWith(
                          color: colors.ink,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    if (recommended && badge != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const .symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: colors.accent,
                          borderRadius: .circular(AppRadius.full),
                        ),
                        child: Text(
                          badge,
                          style: AppText.badge.copyWith(
                            color: colors.onAccent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  description,
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          AppLineIconWidget(.chevronR, size: 16, color: colors.muted2),
        ],
      ),
    );
  }
}

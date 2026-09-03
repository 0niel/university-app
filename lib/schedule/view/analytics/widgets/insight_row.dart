part of '../analytics_page.dart';

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final _Insight insight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Container(
            width: AppControlSize.touchTarget,
            height: AppControlSize.touchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              insight.icon,
              size: 19,
              color: colors.muted,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  insight.title,
                  style: AppText.body.copyWith(
                    color: colors.ink,
                    fontWeight: .w600,
                  ),
                ),
                Text(
                  insight.sub,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

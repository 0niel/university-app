part of '../analytics_page.dart';

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final _Insight insight;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaScheduleSurface(
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              insight.icon,
              size: 19,
              color: colors.mutedDark,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 2,
              children: [
                Text(
                  insight.title,
                  style: NinjaText.body.copyWith(
                    color: colors.ink,
                    fontWeight: .w600,
                  ),
                ),
                Text(
                  insight.sub,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

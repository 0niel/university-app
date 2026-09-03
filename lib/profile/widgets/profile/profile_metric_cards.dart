part of 'profile_widgets.dart';

class ProfileMetric {
  const ProfileMetric({
    required this.value,
    required this.label,
    this.onTap,
    this.danger = false,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;
  final bool danger;
}

class ProfileMetricCards extends StatelessWidget {
  const ProfileMetricCards({required this.metrics, super.key});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        for (final (index, metric) in metrics.indexed) ...[
          if (index != 0) const SizedBox(width: AppSpacing.xsm),
          Expanded(
            child: AppCard(
              radius: AppRadius.field,
              padding: const EdgeInsets.all(AppSpacing.md),
              onTap: metric.onTap,
              semanticsLabel: '${metric.value}, ${metric.label}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.metric.copyWith(
                      color: metric.danger ? colors.danger : colors.ink,
                      height: 24 / 19,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    metric.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      11.5,
                      FontWeight.w500,
                      height: 15 / 11.5,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

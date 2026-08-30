part of 'profile_page.dart';

class _ProfileMetrics extends StatelessWidget {
  const _ProfileMetrics({required this.metrics, required this.stacked});

  final List<_ProfileMetricData> metrics;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return Column(
        crossAxisAlignment: .stretch,
        children: [
          for (final (index, metric) in metrics.indexed) ...[
            if (index > 0) const SizedBox(height: 10),
            _ProfileMetric(metric: metric, stacked: true),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: .start,
      children: [
        for (final (index, metric) in metrics.indexed) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(child: _ProfileMetric(metric: metric)),
        ],
      ],
    );
  }
}

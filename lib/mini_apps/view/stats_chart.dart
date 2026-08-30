part of 'mini_app_stats_page.dart';

class _StatsChart extends StatelessWidget {
  const _StatsChart({required this.stats});

  final List<MiniAppDailyStat> stats;

  double get _maxValue {
    var max = 0;
    for (final s in stats) {
      max = math.max(max, math.max(s.launches, s.uniqueUsers));
    }
    return max.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final step = math.max(1, (_maxValue / 3).ceil());
    final maxY = _maxValue <= 0
        ? 1.0
        : (_maxValue / step).ceil() * step.toDouble();
    final xStep = math.max(1, ((stats.length - 1) / 4).ceil()).toDouble();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(1, stats.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: step.toDouble(),
          getDrawingHorizontalLine: (_) =>
              FlLine(color: colors.line, strokeWidth: NinjaMetrics.lineWidth),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 30,
              interval: step.toDouble(),
              getTitlesWidget: (value, _) => _LeftLabel(value: value),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: xStep,
              getTitlesWidget: (value, _) =>
                  _BottomLabel(stats: stats, value: value),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colors.surface,
            getTooltipItems: (spots) => _tooltipItems(context, spots),
          ),
        ),
        lineBarsData: [
          _line(_spots((s) => s.launches), colors.ink),
          _line(_spots((s) => s.uniqueUsers), colors.brand),
        ],
      ),
    );
  }

  List<FlSpot> _spots(int Function(MiniAppDailyStat s) value) => [
    for (var i = 0; i < stats.length; i++)
      FlSpot(i.toDouble(), value(stats[i]).toDouble()),
  ];

  LineChartBarData _line(List<FlSpot> data, Color color) => .new(
    spots: data,
    color: color,
    barWidth: 2.5,
    isCurved: true,
    preventCurveOverShooting: true,
    dotData: const FlDotData(show: false),
  );

  List<LineTooltipItem?> _tooltipItems(
    BuildContext context,
    List<LineBarSpot> spots,
  ) {
    if (spots.isEmpty) return const [];
    final colors = context.ninja;
    final l10n = context.l10n;
    final index = spots.firstOrNull?.x.toInt();
    final day = index == null ? null : stats.elementAtOrNull(index)?.day;
    final header = day == null
        ? ''
        : MaterialLocalizations.of(context).formatShortMonthDay(day);
    int valueFor(int barIndex) {
      for (final spot in spots) {
        if (spot.barIndex == barIndex) return spot.y.toInt();
      }
      return 0;
    }

    final item = LineTooltipItem(
      header,
      NinjaText.subtext.copyWith(color: colors.ink, fontWeight: .w700),
      children: [
        TextSpan(
          text: '\n${l10n.miniAppsStatsLaunches}: ${valueFor(0)}',
          style: NinjaText.helper.copyWith(color: colors.ink),
        ),
        TextSpan(
          text: '\n${l10n.miniAppsStatsUsers}: ${valueFor(1)}',
          style: NinjaText.helper.copyWith(color: colors.brandInk),
        ),
      ],
    );
    return [for (var i = 0; i < spots.length; i++) i == 0 ? item : null];
  }
}

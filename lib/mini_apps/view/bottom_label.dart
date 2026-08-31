part of 'mini_app_stats_page.dart';

class _BottomLabel extends StatelessWidget {
  const _BottomLabel({required this.stats, required this.value});

  final List<MiniAppDailyStat> stats;
  final double value;

  @override
  Widget build(BuildContext context) {
    final index = value.toInt();
    if (index < 0 || index >= stats.length) return const SizedBox.shrink();
    final day = stats.elementAtOrNull(index)?.day;
    if (day == null) return const SizedBox.shrink();
    final label = MaterialLocalizations.of(context).formatShortMonthDay(day);
    return Padding(
      padding: const .only(top: 8),
      child: Text(
        label,
        style: NinjaText.helper.copyWith(color: context.ninja.muted),
      ),
    );
  }
}

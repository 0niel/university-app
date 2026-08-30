part of 'mini_app_stats_page.dart';

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.range});

  final MiniAppStatsRange range;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaSegmented<MiniAppStatsRange>(
      value: range,
      expanded: true,
      onChanged: (value) =>
          context.read<MiniAppStatsCubit>().rangeChanged(value),
      segments: [
        for (final value in MiniAppStatsRange.values)
          NinjaSegment(
            value: value,
            label: l10n.miniAppsStatsDaysShort(value.days),
          ),
      ],
    );
  }
}

part of '../schedule_page.dart';

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.value, required this.onChanged});

  final _ScheduleFilter value;
  final ValueChanged<_ScheduleFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final items = _filterOptions(l10n);
    final label =
        items.firstWhereOrNull((item) => item.$1 == value)?.$2 ??
        l10n.filterAll;
    final active = value != .all;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.classesList,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
          ),
          AppPressable(
            onTap: () => unawaited(_openFilterSheet(context, items)),
            semanticsLabel: '${l10n.filtersTitle}: $label',
            child: Container(
              constraints: const BoxConstraints(
                minHeight: NinjaMetrics.minTouchTarget,
              ),
              padding: const .symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: .circular(NinjaRadius.pill),
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  AppLineIconWidget(
                    AppLineIcon.filter,
                    size: 18,
                    color: active ? colors.ink : colors.mutedDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: NinjaText.buttonSmall.copyWith(
                      color: active ? colors.ink : colors.mutedDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet(
    BuildContext context,
    List<(_ScheduleFilter, String)> items,
  ) {
    final colors = context.ninja;
    return showAppSheet<void>(
      context,
      title: context.l10n.filtersTitle,
      backgroundColor: colors.canvas,
      contentPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: .min,
        children: [
          for (final (index, item) in items.indexed)
            NinjaListCell(
              title: item.$2,
              showChevron: false,
              showDivider: index < items.length - 1,
              titleColor: item.$1 == value ? colors.ink : colors.mutedDark,
              trailing: item.$1 == value
                  ? AppLineIconWidget(
                      AppLineIcon.check,
                      size: 18,
                      color: colors.brand,
                    )
                  : null,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                onChanged(item.$1);
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

List<(_ScheduleFilter, String)> _filterOptions(AppLocalizations l10n) {
  return [
    (.all, l10n.filterAll),
    (.lecture, l10n.filterLectures),
    (.seminar, l10n.filterSeminars),
    (.laboratory, l10n.filterLabs),
    (.exam, l10n.filterExams),
  ];
}

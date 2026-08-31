part of '../schedule_page.dart';

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.day,
    required this.lessonColors,
    required this.activityTypes,
    required this.selected,
    required this.today,
    required this.layoutKey,
    required this.onTap,
  });

  final DateTime day;
  final List<Color> lessonColors;
  final List<UserActivityType> activityTypes;
  final bool selected;
  final bool today;
  final GlobalKey layoutKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final dayInfo = RussianWorkCalendar.dayInfo(day);
    final load = monthCellLoadLevel(lessonColors.length);
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final todayForeground = colors.onBrand;
    final number = today
        ? todayForeground
        : selected
        ? colors.brandInk
        : dayInfo.isSpecial
        ? _scheduleDayAccent(colors, dayInfo)
        : colors.ink;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final locale = Localizations.localeOf(context).toString();
    final semantics = [
      DateFormat.yMMMMd(locale).format(day),
      if (load > 0) context.l10n.legendLessons,
      if (load == 3) context.l10n.busyDayBadge,
      if (activityTypes.contains(UserActivityType.retake))
        context.l10n.legendRetake,
      if (activityTypes.any((type) => type != UserActivityType.retake))
        context.l10n.legendEvent,
      if (dayInfo.isSpecial) _scheduleDayLabel(context, dayInfo),
    ].join(', ');
    final keySuffix = '${day.year}-${day.month}-${day.day}';

    final child = AppPressable(
      key: layoutKey,
      onTap: onTap,
      semanticsLabel: semantics,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : NinjaMotion.fast,
        curve: NinjaMotion.enter,
        margin: const .all(2),
        padding: const .only(top: 6),
        decoration: BoxDecoration(
          color: today
              ? colors.brand
              : selected
              ? colors.surfaceAlt
              : dayInfo.isSpecial
              ? _scheduleDaySurface(colors, dayInfo)
              : load > 0 || activityTypes.isNotEmpty
              ? colors.surfaceAlt
              : Colors.transparent,
          border: selected && !today
              ? Border.all(color: colors.brandInk, width: 1.5)
              : null,
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Column(
          children: [
            Text(
              '${day.day}',
              key: ValueKey('month-day-number-$keySuffix'),
              textScaler: TextScaler.noScaling,
              style: NinjaText.tabular(
                NinjaText.body.copyWith(
                  fontSize: largeText ? 15 : 13,
                  color: number,
                ),
              ),
            ),
            SizedBox(height: largeText ? 6 : 3),
            if (load > 0)
              Padding(
                padding: const .symmetric(horizontal: 8),
                child: Column(
                  key: ValueKey('month-day-load-$keySuffix'),
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    for (var i = 0; i < load; i++) ...[
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: today
                              ? todayForeground
                              : (lessonColors.elementAtOrNull(
                                      i * lessonColors.length ~/ load,
                                    ) ??
                                    colors.brand),
                          borderRadius: .circular(NinjaRadius.pill),
                        ),
                      ),
                      if (i != load - 1) const SizedBox(height: 2),
                    ],
                  ],
                ),
              ),
            const Spacer(),
            if (dayInfo.isSpecial || activityTypes.isNotEmpty)
              Padding(
                padding: const .only(bottom: 5),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    if (dayInfo.isSpecial)
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: 5,
                          height: 5,
                          margin: const .symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: today
                                ? todayForeground
                                : _scheduleDayAccent(colors, dayInfo),
                            borderRadius: .circular(1),
                          ),
                        ),
                      ),
                    for (final type in activityTypes.take(3))
                      Padding(
                        padding: const .symmetric(horizontal: 1),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: today
                                ? todayForeground
                                : _activityColor(colors, type),
                            shape: .circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    final morph = _CalendarMorphScope.maybeOf(context);
    if (morph == null ||
        !morph.enabled ||
        morph.layerView != _ScheduleView.month) {
      return child;
    }
    return _CalendarMorphMonthCell(scope: morph, day: day, child: child);
  }
}

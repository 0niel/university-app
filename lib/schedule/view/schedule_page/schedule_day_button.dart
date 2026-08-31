part of '../schedule_page.dart';

class _ScheduleDayButton extends StatelessWidget {
  const _ScheduleDayButton({
    required this.day,
    required this.lessonColors,
    required this.activityTypes,
    required this.shortLabel,
    required this.selected,
    required this.today,
    required this.locale,
    required this.layoutKey,
    required this.onTap,
  });

  final DateTime day;
  final List<Color> lessonColors;
  final List<UserActivityType> activityTypes;
  final String shortLabel;
  final bool selected;
  final bool today;
  final String locale;
  final GlobalKey layoutKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final dayInfo = RussianWorkCalendar.dayInfo(day);
    final dayAccent = _scheduleDayAccent(colors, dayInfo);
    final foreground = selected
        ? colors.onBrand
        : today
        ? colors.brandInk
        : dayInfo.isSpecial
        ? dayAccent
        : colors.mutedDark;
    final numberColor = selected
        ? colors.onBrand
        : today
        ? colors.brandInk
        : dayInfo.isSpecial
        ? dayAccent
        : colors.ink;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    final semantics = [
      DateFormat('EEEE, d MMMM', locale).format(day),
      if (lessonColors.isNotEmpty)
        context.l10n.lessonsCount(lessonColors.length),
      if (activityTypes.isNotEmpty) context.l10n.legendEvent,
      if (dayInfo.isSpecial) _scheduleDayLabel(context, dayInfo),
    ].join(', ');
    final child = AppPressable(
      key: layoutKey,
      onTap: onTap,
      semanticsLabel: semantics,
      semanticsSelected: selected,
      child: AnimatedContainer(
        margin: const .symmetric(horizontal: 2, vertical: 4),
        padding: const .symmetric(horizontal: 2, vertical: 7),
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected
              ? colors.brand
              : today
              ? colors.brandTint
              : dayInfo.isSpecial
              ? _scheduleDaySurface(colors, dayInfo)
              : colors.surfaceAlt.withValues(alpha: .62),
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Row(
              mainAxisSize: .min,
              children: [
                if (dayInfo.isSpecial) ...[
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: selected ? colors.onBrand : dayAccent,
                      shape: .circle,
                    ),
                  ),
                  const SizedBox(width: 3),
                ],
                Flexible(
                  child: Text(
                    shortLabel,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.microLabel.copyWith(color: foreground),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${day.day}',
              maxLines: 1,
              style: NinjaText.tabular(
                NinjaText.headline.copyWith(
                  fontSize: 16,
                  color: numberColor,
                ),
              ),
            ),
            const SizedBox(height: 5),
            _ScheduleDayLoadDots(
              key: ValueKey('schedule-day-load-${_dayKey(day)}'),
              lessonColors: lessonColors,
              activityColors: [
                for (final type in activityTypes) _activityColor(colors, type),
              ],
              selected: selected,
            ),
          ],
        ),
      ),
    );
    final morph = _CalendarMorphScope.maybeOf(context);
    if (morph == null || !morph.enabled || !morph.isShared(day)) return child;
    return _CalendarMorphSharedCell(
      scope: morph,
      monthCell: false,
      child: child,
    );
  }
}

class _ScheduleDayLoadDots extends StatelessWidget {
  const _ScheduleDayLoadDots({
    required this.lessonColors,
    required this.activityColors,
    required this.selected,
    super.key,
  });

  final List<Color> lessonColors;
  final List<Color> activityColors;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final visibleLessons = lessonColors.take(5).toList();
    final overflow = lessonColors.length - visibleLessons.length;
    final activity = activityColors.firstOrNull;
    final empty = visibleLessons.isEmpty && activity == null;

    return SizedBox(
      height: 8,
      child: Center(
        child: empty
            ? Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: selected
                      ? colors.onBrand.withValues(alpha: .35)
                      : colors.disabled.withValues(alpha: .45),
                  shape: .circle,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    for (final (index, color) in visibleLessons.indexed) ...[
                      if (index > 0) const SizedBox(width: 2),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: selected
                              ? Color.lerp(color, colors.onBrand, .28)
                              : color,
                          shape: .circle,
                        ),
                      ),
                    ],
                    if (overflow > 0) ...[
                      const SizedBox(width: 2),
                      Text(
                        '+$overflow',
                        textScaler: TextScaler.noScaling,
                        style: NinjaText.badge.copyWith(
                          fontSize: 8,
                          height: 1,
                          color: selected ? colors.onBrand : colors.mutedDark,
                        ),
                      ),
                    ],
                    if (activity != null) ...[
                      if (visibleLessons.isNotEmpty || overflow > 0)
                        const SizedBox(width: 3),
                      Transform.rotate(
                        key: const ValueKey('schedule-day-activity-dot'),
                        angle: math.pi / 4,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: selected
                                ? Color.lerp(
                                    activity,
                                    colors.onBrand,
                                    .28,
                                  )
                                : activity,
                            borderRadius: .circular(1),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_badge.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCalendarMonth extends StatelessWidget {
  const AppCalendarMonth({
    required this.month,
    required this.onMonthChanged,
    required this.onDaySelected,
    super.key,
    this.selectedDay,
    this.today,
    this.dotsForDay,
    this.headerLabelBuilder,
    this.weekdayLabelBuilder,
    this.firstDayOfWeek = DateTime.monday,
  });

  final DateTime month;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;
  final DateTime? selectedDay;
  final DateTime? today;
  final List<Color> Function(DateTime day)? dotsForDay;
  final String Function(DateTime month)? headerLabelBuilder;
  final String Function(DateTime day)? weekdayLabelBuilder;
  final int firstDayOfWeek;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toString();
    final normalizedMonth = DateTime(month.year, month.month);
    final now = today ?? DateTime.now();
    final selected = selectedDay;

    final daysBefore = (normalizedMonth.weekday - firstDayOfWeek + 7) % 7;
    final gridStart = normalizedMonth.subtract(Duration(days: daysBefore));
    final daysInMonth = DateTime(
      normalizedMonth.year,
      normalizedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((daysBefore + daysInMonth + 6) ~/ 7) * 7;
    final headerLabel = headerLabelBuilder?.call(normalizedMonth) ??
        _defaultHeaderLabel(normalizedMonth, locale);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sectionGap,
        AppSpacing.lg,
        AppSpacing.sectionGap,
        AppSpacing.lg,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity > 200) {
            onMonthChanged(
              DateTime(normalizedMonth.year, normalizedMonth.month - 1),
            );
          } else if (velocity < -200) {
            onMonthChanged(
              DateTime(normalizedMonth.year, normalizedMonth.month + 1),
            );
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    headerLabel,
                    style: AppText.section.copyWith(color: colors.ink),
                  ),
                ),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.chevronL),
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).previousMonthTooltip,
                  tone: AppIconButtonTone.plain,
                  onPressed: () => onMonthChanged(
                    DateTime(normalizedMonth.year, normalizedMonth.month - 1),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.chevronR),
                  tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
                  tone: AppIconButtonTone.plain,
                  onPressed: () => onMonthChanged(
                    DateTime(normalizedMonth.year, normalizedMonth.month + 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Center(
                      child: Text(
                        weekdayLabelBuilder?.call(
                              gridStart.add(Duration(days: i)),
                            ) ??
                            _defaultWeekdayLabel(
                              gridStart.add(Duration(days: i)),
                              locale,
                            ),
                        style: AppText.sans(
                          10,
                          FontWeight.w700,
                          letterSpacingEm: .04,
                        ).copyWith(color: colors.muted),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            for (var row = 0; row < totalCells ~/ 7; row++)
              Row(
                children: [
                  for (var column = 0; column < 7; column++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        child: _AppCalendarDayCell(
                          day: gridStart.add(Duration(days: row * 7 + column)),
                          month: normalizedMonth.month,
                          today: now,
                          selected: selected,
                          dots: dotsForDay,
                          onTap: onDaySelected,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _defaultHeaderLabel(DateTime month, String locale) {
    final formatted = DateFormat.yMMMM(locale).format(month);
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  static String _defaultWeekdayLabel(DateTime day, String locale) =>
      DateFormat.E(locale).format(day).toUpperCase();
}

class _AppCalendarDayCell extends StatelessWidget {
  const _AppCalendarDayCell({
    required this.day,
    required this.month,
    required this.today,
    required this.selected,
    required this.dots,
    required this.onTap,
  });

  final DateTime day;
  final int month;
  final DateTime today;
  final DateTime? selected;
  final List<Color> Function(DateTime day)? dots;
  final ValueChanged<DateTime> onTap;

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    if (day.month != month) {
      return const SizedBox(height: AppControlSize.navCircle);
    }
    final colors = context.colors;
    final isToday = _isSameDay(day, today);
    final selectedDay = selected;
    final isSelected = selectedDay != null && _isSameDay(day, selectedDay);
    final dotColors = dots?.call(day) ?? const <Color>[];
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return AppPressState(
      key: ValueKey(
        'app-calendar-month-day-${day.year}-${day.month}-${day.day}',
      ),
      semanticsLabel: DateFormat.yMMMMEEEEd(
        Localizations.localeOf(context).toString(),
      ).format(day),
      semanticsSelected: isSelected,
      onTap: () => onTap(day),
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: AppControlSize.navCircle),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent
              : (pressed ? colors.surface2 : colors.surface),
          borderRadius: BorderRadius.circular(AppRadius.iconTile),
          border: isToday && !isSelected
              ? Border.all(color: colors.accent, width: AppSpacing.xxs)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: AppText.time.copyWith(
                color: isSelected ? colors.onAccent : colors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSpacing.xs),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: [
                  for (final color in dotColors.take(4))
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: isSelected ? colors.surface : null,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(.75),
                        child: AppDot(size: 4, color: color),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeWeekPills extends StatelessWidget {
  const HomeWeekPills({
    required this.days,
    required this.selectedIndex,
    required this.today,
    required this.lessonCounts,
    required this.changedDays,
    required this.onSelected,
    this.lessonColors = const [],
    this.lessonCountForDay,
    this.lessonColorsForDay,
    this.onWeekChanged,
    super.key,
  });

  final List<DateTime> days;
  final int selectedIndex;
  final DateTime today;
  final List<int> lessonCounts;
  final List<List<Color>> lessonColors;
  final Set<int> changedDays;
  final ValueChanged<int> onSelected;
  final ValueChanged<int>? onWeekChanged;
  final int Function(DateTime)? lessonCountForDay;
  final List<Color> Function(DateTime)? lessonColorsForDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final format = DateFormat.E(locale);
    String? rangeLabel(int offset) {
      if (days.isEmpty) return null;
      final start = AppWeekPager.offsetWeek(days.first, offset);
      final end = AppWeekPager.offsetWeek(days.last, offset);
      return '${DateFormat.yMMMd(locale).format(start)} — '
          '${DateFormat.yMMMd(locale).format(end)}';
    }

    AppWeekDay day(DateTime date) {
      final index = days.indexWhere(
        (value) => DateUtils.isSameDay(value, date),
      );
      final count =
          lessonCountForDay?.call(date) ??
          (index < 0 ? 0 : lessonCounts.elementAtOrNull(index) ?? 0);
      return AppWeekDay(
        '${date.day}',
        short: format.format(date).replaceAll('.', '').toUpperCase(),
        isWeekend: date.weekday >= DateTime.saturday,
        isToday: DateUtils.isSameDay(date, today),
        semanticsLabel:
            '${DateFormat.yMMMMd(locale).format(date)}, '
            '${l10n.scheduleDayLessons(count)}',
        dots:
            lessonColorsForDay?.call(date) ??
            (index < 0 ? null : lessonColors.elementAtOrNull(index)) ??
            List.filled(count, colors.accent),
      );
    }

    List<AppWeekDay> week(DateTime start) => [
      for (var offset = 0; offset < days.length; offset++)
        day(DateTime(start.year, start.month, start.day + offset)),
    ];
    return AppTourAnchor(
      target: .homeDays,
      child: Semantics(
        container: true,
        label: l10n.schedule,
        value: rangeLabel(0),
        increasedValue: onWeekChanged == null ? null : rangeLabel(1),
        decreasedValue: onWeekChanged == null ? null : rangeLabel(-1),
        onIncrease: onWeekChanged == null ? null : () => onWeekChanged!(1),
        onDecrease: onWeekChanged == null ? null : () => onWeekChanged!(-1),
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: days.isEmpty || onWeekChanged == null
              ? AppWeekStrip(
                  padding: EdgeInsets.zero,
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                  days: days.isEmpty ? const [] : week(days.first),
                )
              : AppWeekPager(
                  weekStart: days.first,
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                  daysBuilder: week,
                  onWeekChanged: (start) {
                    final from = DateTime.utc(
                      days.first.year,
                      days.first.month,
                      days.first.day,
                    );
                    final to = DateTime.utc(start.year, start.month, start.day);
                    onWeekChanged!(to.difference(from).inDays ~/ 7);
                  },
                ),
        ),
      ),
    );
  }
}

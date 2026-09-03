import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart' show Tooltip, TooltipTriggerMode;
import 'package:flutter/widgets.dart';

class AppHeatmapDay {
  const AppHeatmapDay({required this.date, required this.count});

  final DateTime date;
  final int count;
}

class AppActivityHeatmap extends StatelessWidget {
  const AppActivityHeatmap({
    required this.days,
    super.key,
    this.today,
    this.cellSize = 13,
    this.gap = 3,
    this.weekdayLabels,
    this.monthLabelBuilder,
    this.tooltipBuilder,
    this.legendLessLabel,
    this.legendMoreLabel,
  });

  final List<AppHeatmapDay> days;
  final DateTime? today;
  final double cellSize;
  final double gap;
  final List<String?>? weekdayLabels;
  final String Function(DateTime monthStart)? monthLabelBuilder;
  final String Function(DateTime day, int count)? tooltipBuilder;
  final String? legendLessLabel;
  final String? legendMoreLabel;

  static const double _labelColumnWidth = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();
    final byDay = <DateTime, int>{
      for (final entry in days)
        DateTime(entry.date.year, entry.date.month, entry.date.day):
            entry.count,
    };
    final sortedDates = byDay.keys.toList()..sort();
    final earliest = sortedDates.first;
    final latest = today != null
        ? DateTime(today!.year, today!.month, today!.day)
        : sortedDates.last;
    final maxCount = byDay.values.fold(0, (m, c) => c > m ? c : m);
    final weeks = _buildWeeks(earliest, latest, byDay);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnStep = cellSize + gap;
        final available = constraints.maxWidth - _labelColumnWidth - gap;
        final weeksFit = (available / columnStep).floor().clamp(
              1,
              weeks.length,
            );
        final visible = weeks.length <= weeksFit
            ? weeks
            : weeks.sublist(weeks.length - weeksFit);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MonthLabelsRow(
              weeks: visible,
              cellSize: cellSize,
              gap: gap,
              labelColumnWidth: _labelColumnWidth,
              monthLabelBuilder: monthLabelBuilder,
            ),
            SizedBox(height: gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WeekdayLabels(
                  labels: weekdayLabels,
                  cellSize: cellSize,
                  gap: gap,
                  width: _labelColumnWidth,
                ),
                for (final week in visible) ...[
                  SizedBox(width: gap),
                  Column(
                    children: [
                      for (final day in week) ...[
                        if (day != null)
                          _HeatmapCell(
                            date: day,
                            count: byDay[day] ?? 0,
                            level: _levelOf(byDay[day] ?? 0, maxCount),
                            size: cellSize,
                            isToday: day == latest,
                            tooltipBuilder: tooltipBuilder,
                          )
                        else
                          SizedBox(width: cellSize, height: cellSize),
                        if (day != week.last) SizedBox(height: gap),
                      ],
                    ],
                  ),
                ],
              ],
            ),
            if (legendLessLabel != null || legendMoreLabel != null) ...[
              SizedBox(height: gap * 2),
              _Legend(
                lessLabel: legendLessLabel,
                moreLabel: legendMoreLabel,
                cellSize: cellSize * .7,
                gap: gap,
              ),
            ],
          ],
        );
      },
    );
  }

  List<List<DateTime?>> _buildWeeks(
    DateTime earliest,
    DateTime latest,
    Map<DateTime, int> byDay,
  ) {
    final leadingPad = earliest.weekday - 1;
    final start = earliest.subtract(Duration(days: leadingPad));
    final totalDays = latest.difference(start).inDays + 1;
    final trailingPad = (7 - totalDays % 7) % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < leadingPad; i++) null,
      for (var i = 0; i <= latest.difference(earliest).inDays; i++)
        earliest.add(Duration(days: i)),
      for (var i = 0; i < trailingPad; i++) null,
    ];
    return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
  }

  static int _levelOf(int count, int maxCount) {
    if (count <= 0) return 0;
    if (maxCount <= 0) return 1;
    final ratio = count / maxCount;
    if (ratio >= .99) return 4;
    if (ratio >= .66) return 3;
    if (ratio >= .33) return 2;
    return 1;
  }
}

Color appHeatmapLevelColor(AppColors colors, int level) => switch (level) {
      1 => colors.tintOf(colors.accent, .24),
      2 => colors.tintOf(colors.accent, .44),
      3 => colors.tintOf(colors.accent, .7),
      4 => colors.accent,
      _ => colors.surface2,
    };

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({
    required this.date,
    required this.count,
    required this.level,
    required this.size,
    required this.isToday,
    required this.tooltipBuilder,
  });

  final DateTime date;
  final int count;
  final int level;
  final double size;
  final bool isToday;
  final String Function(DateTime day, int count)? tooltipBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cell = DecoratedBox(
      decoration: BoxDecoration(
        color: appHeatmapLevelColor(colors, level),
        borderRadius: BorderRadius.circular(AppRadius.bar),
        border: isToday ? Border.all(color: colors.accent, width: 2) : null,
      ),
      child: SizedBox(width: size, height: size),
    );
    final builder = tooltipBuilder;
    if (builder == null) return cell;
    return Tooltip(
      message: builder(date, count),
      triggerMode: TooltipTriggerMode.longPress,
      child: cell,
    );
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels({
    required this.labels,
    required this.cellSize,
    required this.gap,
    required this.width,
  });

  final List<String?>? labels;
  final double cellSize;
  final double gap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labels = this.labels;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          for (var i = 0; i < 7; i++) ...[
            SizedBox(
              height: cellSize,
              child: Align(
                alignment: Alignment.centerLeft,
                child: labels != null && labels.length > i && labels[i] != null
                    ? Text(
                        labels[i]!,
                        style: AppText.captionSmall.copyWith(
                          color: colors.muted2,
                        ),
                      )
                    : null,
              ),
            ),
            if (i != 6) SizedBox(height: gap),
          ],
        ],
      ),
    );
  }
}

class _MonthLabelsRow extends StatelessWidget {
  const _MonthLabelsRow({
    required this.weeks,
    required this.cellSize,
    required this.gap,
    required this.labelColumnWidth,
    required this.monthLabelBuilder,
  });

  final List<List<DateTime?>> weeks;
  final double cellSize;
  final double gap;
  final double labelColumnWidth;
  final String Function(DateTime monthStart)? monthLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final builder = monthLabelBuilder;
    if (builder == null) return const SizedBox.shrink();
    final colors = context.colors;
    int? lastMonth;
    return SizedBox(
      height: AppText.captionSmall.fontSize! * 1.4,
      child: Row(
        children: [
          SizedBox(width: labelColumnWidth),
          for (final week in weeks) ...[
            SizedBox(width: gap),
            SizedBox(
              width: cellSize,
              child: Builder(
                builder: (context) {
                  final anchor = week.firstWhere(
                    (day) => day != null,
                    orElse: () => null,
                  );
                  if (anchor == null || anchor.month == lastMonth) {
                    return const SizedBox.shrink();
                  }
                  lastMonth = anchor.month;
                  return Text(
                    builder(anchor),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: AppText.captionSmall.copyWith(
                      color: colors.muted2,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.lessLabel,
    required this.moreLabel,
    required this.cellSize,
    required this.gap,
  });

  final String? lessLabel;
  final String? moreLabel;
  final double cellSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = AppText.captionSmall.copyWith(color: colors.muted2);
    return Row(
      children: [
        if (lessLabel != null)
          Flexible(
            child: Text(
              lessLabel!,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (lessLabel != null) SizedBox(width: gap * 2),
        for (var level = 0; level < 5; level++) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: appHeatmapLevelColor(colors, level),
              borderRadius: BorderRadius.circular(AppRadius.bar),
            ),
            child: SizedBox(width: cellSize, height: cellSize),
          ),
          if (level != 4) SizedBox(width: gap),
        ],
        if (moreLabel != null) SizedBox(width: gap * 2),
        if (moreLabel != null)
          Flexible(
            child: Text(
              moreLabel!,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

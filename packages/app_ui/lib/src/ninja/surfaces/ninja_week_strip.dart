import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaWeekDay {
  const NinjaWeekDay(
    this.label, {
    this.short,
    this.isWeekend = false,
    this.isPast = false,
    this.isToday = false,
    this.dots = const <Color>[],
    this.semanticsLabel,
  });

  final String label;
  final String? short;
  final bool isWeekend;
  final bool isPast;
  final bool isToday;
  final List<Color> dots;
  final String? semanticsLabel;
}

class NinjaWeekStrip extends StatelessWidget {
  const NinjaWeekStrip({
    required this.days,
    required this.selectedIndex,
    super.key,
    this.onSelected,
    this.dense = false,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    this.gap = 6,
    this.scheduleStyle = false,
    this.fitWeek = false,
  });

  final List<NinjaWeekDay> days;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final bool dense;
  final EdgeInsets padding;
  final double gap;
  final bool scheduleStyle;
  final bool fitWeek;

  static ({int columns, double gap, double cellHeight, double height}) layout(
    BuildContext context, {
    required double width,
    required List<NinjaWeekDay> days,
    bool scheduleStyle = false,
  }) {
    final scaler = MediaQuery.textScalerOf(context);
    final minimum = math.max(44, scaler.scale(16) * 2 + 12);
    final count = math.max(1, days.length);
    final capacity = math.max(1, ((width + 2) / (minimum + 2)).floor());
    final rows = (count / capacity).ceil();
    final columns = (count / rows).ceil();
    final gap = columns <= 1
        ? 0.0
        : ((width - minimum * columns) / (columns - 1)).clamp(2.0, 6.0);
    final cellWidth = (width - (columns - 1) * gap) / columns;
    final dotColumns = math.max(1, ((cellWidth - 12 - 4 + 2) / 6).floor());
    final maxDots =
        days.fold(0, (value, day) => math.max(value, day.dots.length));
    final dotRows = (maxDots / dotColumns).ceil();
    final markHeight = dotRows == 0 ? 0 : AppSpacing.micro + dotRows * 6 - 2;
    final cellHeight = math
        .max(
          AppControlSize.dayPill,
          scaler.scale(scheduleStyle ? 10 : 10.5) * 1.3 +
              AppSpacing.micro +
              scaler.scale(scheduleStyle ? 15 : 16) * 1.3 +
              AppSpacing.xsm * 2 +
              markHeight +
              4,
        )
        .ceilToDouble();
    return (
      columns: columns,
      gap: gap,
      cellHeight: cellHeight,
      height: cellHeight * rows + gap * (rows - 1)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (fitWeek && constraints.hasBoundedWidth && days.isNotEmpty) {
            final metrics = layout(
              context,
              width: constraints.maxWidth,
              days: days,
              scheduleStyle: scheduleStyle,
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: metrics.gap,
              children: [
                for (var start = 0;
                    start < days.length;
                    start += metrics.columns)
                  Row(
                    spacing: metrics.gap,
                    children: [
                      for (var column = 0; column < metrics.columns; column++)
                        Expanded(
                          child: SizedBox(
                            height: metrics.cellHeight,
                            child: start + column >= days.length
                                ? null
                                : NinjaDayPill(
                                    day: days[start + column],
                                    selected: start + column == selectedIndex,
                                    dense: dense,
                                    scheduleStyle: scheduleStyle,
                                    onTap: onSelected == null
                                        ? null
                                        : () => onSelected!(start + column),
                                  ),
                          ),
                        ),
                    ],
                  ),
              ],
            );
          }
          final textWidth = MediaQuery.textScalerOf(context).scale(16) * 2 + 12;
          final cellWidth = textWidth < 44 ? 44.0 : textWidth;
          final minimum = days.length * cellWidth +
              (days.isEmpty ? 0 : days.length - 1) * gap;
          final width =
              constraints.hasBoundedWidth && constraints.maxWidth > minimum
                  ? constraints.maxWidth
                  : minimum;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: Row(
                children: [
                  for (var index = 0; index < days.length; index++) ...[
                    if (index != 0) SizedBox(width: gap),
                    Expanded(
                      child: NinjaDayPill(
                        day: days[index],
                        selected: index == selectedIndex,
                        dense: dense,
                        scheduleStyle: scheduleStyle,
                        onTap: onSelected == null
                            ? null
                            : () => onSelected!(index),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NinjaDayPill extends StatelessWidget {
  const NinjaDayPill({
    required this.day,
    super.key,
    this.selected = false,
    this.dense = false,
    this.onTap,
    this.scheduleStyle = false,
  });

  final NinjaWeekDay day;
  final bool selected;
  final bool dense;
  final VoidCallback? onTap;
  final bool scheduleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    final foreground = selected
        ? colors.onAccent
        : (day.isWeekend || day.isPast)
            ? colors.muted2
            : colors.ink;

    final ring = !selected && day.isToday ? colors.accent : null;
    final short = day.short;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: day.semanticsLabel ??
          (short == null ? day.label : '$short ${day.label}'),
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        constraints: BoxConstraints(
          minHeight:
              dense ? AppControlSize.touchTarget : AppControlSize.dayPill,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xsm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface,
          borderRadius:
              BorderRadius.circular(dense ? AppRadius.iconTile : AppRadius.lg),
          border: ring == null ? null : Border.all(color: ring, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (short != null) ...[
              Opacity(
                opacity: .8,
                child: Text(
                  short,
                  style: (dense
                          ? AppText.sans(9.5, FontWeight.w700)
                          : AppText.sans(
                              scheduleStyle ? 10 : 10.5,
                              FontWeight.w600,
                              letterSpacingEm: .04,
                            ))
                      .copyWith(color: foreground),
                ),
              ),
              const SizedBox(height: AppSpacing.micro),
            ],
            Text(
              day.label,
              style: AppText.sans(
                dense
                    ? 14
                    : scheduleStyle
                        ? 15
                        : 16,
                FontWeight.w700,
                tabular: true,
              ).copyWith(color: foreground),
            ),
            if (day.dots.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.micro),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xsm),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  children: [
                    for (var i = 0; i < day.dots.length; i++)
                      DecoratedBox(
                        key: ValueKey('day-mark-$i'),
                        decoration: BoxDecoration(
                          color: day.dots[i],
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(color: colors.surface, width: .75)
                              : null,
                        ),
                        child: const SizedBox.square(dimension: AppSpacing.xs),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

typedef AppWeekStrip = NinjaWeekStrip;

typedef AppDayPill = NinjaDayPill;

typedef AppWeekDay = NinjaWeekDay;

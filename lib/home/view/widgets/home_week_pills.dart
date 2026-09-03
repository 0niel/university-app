import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeWeekPills extends StatefulWidget {
  const HomeWeekPills({
    required this.days,
    required this.selectedIndex,
    required this.today,
    required this.lessonCounts,
    required this.changedDays,
    required this.onSelected,
    this.lessonColors = const [],
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

  @override
  State<HomeWeekPills> createState() => _HomeWeekPillsState();
}

class _HomeWeekPillsState extends State<HomeWeekPills> {
  double _drag = 0;
  double _edgeDrag = 0;

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.horizontal) return false;
    if (notification is ScrollStartNotification) _edgeDrag = 0;
    if (notification is OverscrollNotification) {
      _edgeDrag += notification.overscroll;
    }
    if (notification is ScrollUpdateNotification &&
        notification.metrics.outOfRange) {
      final metrics = notification.metrics;
      final distance = metrics.pixels < metrics.minScrollExtent
          ? metrics.pixels - metrics.minScrollExtent
          : metrics.pixels - metrics.maxScrollExtent;
      if (distance.abs() > _edgeDrag.abs()) _edgeDrag = distance;
    }
    if (notification is ScrollEndNotification && _edgeDrag.abs() >= 48) {
      final step = _edgeDrag > 0 ? 1 : -1;
      _edgeDrag = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onWeekChanged?.call(step);
      });
    }
    return false;
  }

  void _finishDrag(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 240 && _drag.abs() < 48) return;
    final forward = velocity.abs() >= 240 ? velocity < 0 : _drag < 0;
    widget.onWeekChanged?.call(forward ? 1 : -1);
    _drag = 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final format = DateFormat.E(locale);
    final todayDate = DateUtils.dateOnly(widget.today);
    String? rangeLabel(int offset) {
      if (widget.days.isEmpty) return null;
      final start = widget.days.first.add(Duration(days: offset));
      final end = widget.days.last.add(Duration(days: offset));
      return '${DateFormat.yMMMd(locale).format(start)} — '
          '${DateFormat.yMMMd(locale).format(end)}';
    }

    int lessonCount(int index) =>
        widget.lessonCounts.elementAtOrNull(index) ?? 0;
    return AppTourAnchor(
      target: .homeDays,
      child: Semantics(
        container: true,
        label: context.l10n.schedule,
        value: rangeLabel(0),
        increasedValue: widget.onWeekChanged == null ? null : rangeLabel(7),
        decreasedValue: widget.onWeekChanged == null ? null : rangeLabel(-7),
        onIncrease: widget.onWeekChanged == null
            ? null
            : () => widget.onWeekChanged!(1),
        onDecrease: widget.onWeekChanged == null
            ? null
            : () => widget.onWeekChanged!(-1),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: widget.onWeekChanged == null
              ? null
              : (_) => _drag = 0,
          onHorizontalDragUpdate: widget.onWeekChanged == null
              ? null
              : (details) => _drag += details.delta.dx,
          onHorizontalDragEnd: widget.onWeekChanged == null
              ? null
              : _finishDrag,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: AppWeekStrip(
                padding: EdgeInsets.zero,
                selectedIndex: widget.selectedIndex,
                onSelected: widget.onSelected,
                days: [
                  for (final (index, day) in widget.days.indexed)
                    AppWeekDay(
                      '${day.day}',
                      short: format
                          .format(day)
                          .replaceAll('.', '')
                          .toUpperCase(),
                      isWeekend: day.weekday >= DateTime.saturday,
                      isToday: DateUtils.isSameDay(day, todayDate),
                      semanticsLabel:
                          '${DateFormat.yMMMMd(locale).format(day)}, '
                          '${l10n.scheduleDayLessons(lessonCount(index))}',
                      dots:
                          widget.lessonColors.elementAtOrNull(index) ??
                          [
                            for (
                              var mark = 0;
                              mark <
                                  (widget.lessonCounts.elementAtOrNull(index) ??
                                      0);
                              mark++
                            )
                              colors.accent,
                          ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

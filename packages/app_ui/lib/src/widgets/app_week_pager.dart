import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/ninja/surfaces/ninja_week_strip.dart';
import 'package:flutter/widgets.dart';

class AppWeekPager extends StatefulWidget {
  const AppWeekPager({
    required this.weekStart,
    required this.selectedIndex,
    required this.daysBuilder,
    required this.onWeekChanged,
    required this.onSelected,
    this.scheduleStyle = false,
    super.key,
  });

  final DateTime weekStart;
  final int selectedIndex;
  final List<NinjaWeekDay> Function(DateTime weekStart) daysBuilder;
  final ValueChanged<DateTime> onWeekChanged;
  final ValueChanged<int> onSelected;
  final bool scheduleStyle;

  static DateTime offsetWeek(DateTime start, int offset) =>
      DateTime(start.year, start.month, start.day + offset * 7);

  @override
  State<AppWeekPager> createState() => _AppWeekPagerState();
}

class _AppWeekPagerState extends State<AppWeekPager> {
  static const _originPage = 100000;
  late final _origin = DateTime.utc(
    widget.weekStart.year,
    widget.weekStart.month,
    widget.weekStart.day,
  );
  late final _controller = PageController(initialPage: _originPage);
  int? _target;
  int? _reported;
  int _visiblePage = _originPage;
  var _dragging = false;
  double _retainedHeight = 0;
  double? _width;
  double? _fontScale;

  int _pageOf(DateTime date) =>
      _originPage +
      DateTime.utc(date.year, date.month, date.day)
              .difference(_origin)
              .inDays ~/
          7;

  DateTime _weekOf(int page) {
    final utc = _origin.add(Duration(days: (page - _originPage) * 7));
    return DateTime(utc.year, utc.month, utc.day);
  }

  @override
  void didUpdateWidget(covariant AppWeekPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final page = _pageOf(widget.weekStart);
    if (page == _reported &&
        _controller.hasClients &&
        _controller.page?.round() == page) {
      _reported = null;
      return;
    }
    if (page == _pageOf(oldWidget.weekStart)) return;
    _reported = null;
    _target = page;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients || _target != page) return;
      final current = _controller.page ?? _controller.initialPage.toDouble();
      if (MediaQuery.disableAnimationsOf(context) ||
          MediaQuery.accessibleNavigationOf(context) ||
          (page - current).abs() > 7) {
        _controller.jumpToPage(page);
      } else {
        unawaited(
          _controller.animateToPage(
            page,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0 ||
        notification.metrics.axis != Axis.horizontal) {
      return false;
    }
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _target = null;
      _dragging = true;
    }
    if (notification is ScrollEndNotification && _controller.hasClients) {
      final page = _controller.page!.round();
      setState(() {
        _visiblePage = page;
        _dragging = false;
        _retainedHeight = 0;
      });
      if (_target != null) {
        _target = null;
      } else if (page != _pageOf(widget.weekStart) && page != _reported) {
        _reported = page;
        widget.onWeekChanged(_weekOf(page));
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final current = _pageOf(widget.weekStart);
          final pages = <int>{
            for (var offset = -1; offset <= 1; offset++) ...[
              current + offset,
              _visiblePage + offset,
            ],
            if ((current - _visiblePage).abs() <= 7)
              for (var page = math.min(current, _visiblePage);
                  page <= math.max(current, _visiblePage);
                  page++)
                page,
          };
          final data = <int, List<NinjaWeekDay>>{
            for (final page in pages) page: widget.daysBuilder(_weekOf(page)),
          };
          final measured = data.values
              .map(
                (days) => NinjaWeekStrip.layout(
                  context,
                  width: constraints.maxWidth,
                  days: days,
                  scheduleStyle: widget.scheduleStyle,
                ).height,
              )
              .reduce(math.max);
          final scale = MediaQuery.textScalerOf(context).scale(16);
          if (_width != constraints.maxWidth || _fontScale != scale) {
            _retainedHeight = 0;
            _width = constraints.maxWidth;
            _fontScale = scale;
          }
          final height = _retainedHeight = _dragging || _target != null
              ? math.max(measured, _retainedHeight)
              : measured;
          return SizedBox(
            height: height,
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (page) => setState(() => _visiblePage = page),
                itemBuilder: (context, page) => Align(
                  alignment: Alignment.topCenter,
                  child: IgnorePointer(
                    ignoring: page != current,
                    child: NinjaWeekStrip(
                      key: ValueKey(_weekOf(page)),
                      padding: EdgeInsets.zero,
                      fitWeek: true,
                      scheduleStyle: widget.scheduleStyle,
                      selectedIndex: widget.selectedIndex,
                      onSelected: widget.onSelected,
                      days: data[page] ?? widget.daysBuilder(_weekOf(page)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}

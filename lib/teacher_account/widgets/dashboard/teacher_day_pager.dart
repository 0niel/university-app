import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_day_size_reporter.dart';

class TeacherDayPager extends StatefulWidget {
  const TeacherDayPager({
    required this.day,
    required this.onDay,
    required this.builder,
    super.key,
  });

  final DateTime day;
  final ValueChanged<DateTime> onDay;
  final Widget Function(BuildContext, DateTime) builder;

  @override
  State<TeacherDayPager> createState() => _TeacherDayPagerState();
}

class _TeacherDayPagerState extends State<TeacherDayPager> {
  static const _origin = 100000;
  static const double _minimumHeight = AppControlSize.dayPill + AppSpacing.xlg;
  late final _controller = PageController(initialPage: _pageOf(widget.day));
  late int _visible = _pageOf(widget.day);
  final _heights = <int, double>{};
  DateTime? _reportedDay;
  int? _target;
  var _revision = 0;
  var _dragging = false;
  double? _width;
  double? _scale;

  int _pageOf(DateTime day) => _origin + scheduleDayIndex(day);
  DateTime _dayOf(int page) => scheduleDayOfIndex(page - _origin);

  @override
  void didUpdateWidget(covariant TeacherDayPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = _pageOf(widget.day);
    if (widget.day == _reportedDay) {
      _reportedDay = null;
      return;
    }
    if (target == _pageOf(oldWidget.day)) return;
    _target = target;
    final revision = ++_revision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients || revision != _revision) return;
      final current = _controller.page?.round() ?? _visible;
      if (NinjaMotion.of(context) == Duration.zero ||
          schedulePagerShouldJump(current, target)) {
        _controller.jumpToPage(target);
      } else {
        unawaited(
          _controller.animateToPage(
            target,
            duration: NinjaMotion.of(context),
            curve: NinjaMotion.enter,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _revision++;
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
      _revision++;
      setState(() => _dragging = true);
    }
    if (notification is ScrollEndNotification && _controller.hasClients) {
      final page = _controller.page!.round();
      setState(() {
        _visible = page;
        _dragging = false;
      });
      if (_target != null) {
        if (page == _target) _target = null;
        return false;
      } else if (page != _pageOf(widget.day)) {
        _reportedDay = _dayOf(page);
        widget.onDay(_reportedDay!);
      }
    }
    return false;
  }

  void _measure(int page, Size size) {
    if (!mounted) return;
    final height = math.max(_minimumHeight, size.height);
    if (_heights[page] == height) return;
    setState(() {
      _heights[page] = height;
      _heights.removeWhere((index, _) => (index - _visible).abs() > 7);
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      if (_width != constraints.maxWidth || _scale != scale) {
        _width = constraints.maxWidth;
        _scale = scale;
        _heights.clear();
      }
      final selected = _pageOf(widget.day);
      var height = _heights[_visible] ?? _heights[selected] ?? _minimumHeight;
      if (_dragging || _target != null) {
        for (var page = _visible - 1; page <= _visible + 1; page++) {
          height = math.max(height, _heights[page] ?? _minimumHeight);
        }
      }
      return AnimatedContainer(
        alignment: Alignment.topCenter,
        duration: _dragging ? Duration.zero : NinjaMotion.of(context),
        curve: NinjaMotion.enter,
        height: height,
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: PageView.builder(
            key: const ValueKey('teacher-dashboard-day-pager'),
            controller: _controller,
            allowImplicitScrolling: true,
            onPageChanged: (page) => setState(() => _visible = page),
            itemBuilder: (context, page) => ExcludeSemantics(
              excluding: page != selected,
              child: IgnorePointer(
                ignoring: page != selected,
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Offstage(
                    offstage: page != selected && !_dragging && _target == null,
                    child: TickerMode(
                      enabled: page == selected || _dragging || _target != null,
                      child: TeacherDaySizeReporter(
                        key: ValueKey((page, constraints.maxWidth, scale)),
                        onSize: (size) => _measure(page, size),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: widget.builder(context, _dayOf(page)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

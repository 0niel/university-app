import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';

class ScheduleDatePager extends StatefulWidget {
  const ScheduleDatePager({
    required this.day,
    required this.anchor,
    required this.view,
    required this.onDay,
    required this.builder,
    super.key,
  });

  final DateTime day;
  final DateTime anchor;
  final ScheduleView view;
  final ValueChanged<DateTime> onDay;
  final Widget Function(BuildContext, DateTime) builder;

  @override
  State<ScheduleDatePager> createState() => _ScheduleDatePagerState();
}

class _ScheduleDatePagerState extends State<ScheduleDatePager> {
  late final _paging = SchedulePaging(today: widget.anchor);
  late final _months = ScheduleMonthPaging(today: widget.anchor);
  late final _controller = PageController(initialPage: _pageOf(widget.day));
  late int _page;
  late int _preferredDay;
  int? _target;
  int _syncRevision = 0;
  DateTime? _reportedDay;

  @override
  void initState() {
    super.initState();
    _page = _pageOf(widget.day);
    _preferredDay = widget.day.day;
  }

  int _pageOf(DateTime day) => switch (widget.view) {
    ScheduleView.day => _paging.dayPageOf(day),
    ScheduleView.week => _paging.weekPageOf(day),
    ScheduleView.month => _months.pageOf(day),
  };

  DateTime _dayOf(int page) => switch (widget.view) {
    ScheduleView.day => _paging.dayOfPage(page),
    ScheduleView.week => _paging.dayOfPage(
      _paging.dayPageInWeek(page, widget.day.weekday),
    ),
    ScheduleView.month => _months.dayInPage(page, _preferredDay),
  };

  @override
  void didUpdateWidget(covariant ScheduleDatePager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.day != oldWidget.day && widget.day != _reportedDay) {
      _preferredDay = widget.day.day;
    }
    _reportedDay = null;
    final target = _pageOf(widget.day);
    if (target == _target || target == _page && _target == null) return;
    _target = target;
    final revision = ++_syncRevision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients || revision != _syncRevision) {
        return;
      }
      if (MediaQuery.disableAnimationsOf(context) ||
          MediaQuery.accessibleNavigationOf(context) ||
          schedulePagerShouldJump(_page, target)) {
        _controller.jumpToPage(target);
      } else {
        unawaited(
          _controller.animateToPage(
            target,
            duration: NinjaMotion.of(
              context,
              const Duration(milliseconds: 300),
            ),
            curve: Curves.easeOutCubic,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _syncRevision++;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth != 0 ||
              notification.metrics.axis != Axis.horizontal) {
            return false;
          }
          if (notification is ScrollStartNotification &&
              notification.dragDetails != null) {
            _target = null;
            _syncRevision++;
          }
          if (notification is ScrollEndNotification && _controller.hasClients) {
            final page = _controller.page?.round();
            if (_target != null) {
              if (page == _target) _target = null;
              return false;
            }
            if (page != null && page != _pageOf(widget.day)) {
              final day = _dayOf(page);
              _page = page;
              _reportedDay = day;
              widget.onDay(day);
            }
          }
          return false;
        },
        child: PageView.builder(
          key: ValueKey('schedule-${widget.view.name}-pager'),
          controller: _controller,
          itemCount: switch (widget.view) {
            ScheduleView.day => _paging.dayPageCount,
            ScheduleView.week => _paging.weekPageCount,
            ScheduleView.month => _months.pageCount,
          },
          onPageChanged: (page) {
            _page = page;
          },
          itemBuilder: (context, page) {
            final day = _dayOf(page);
            return CustomScrollView(
              key: PageStorageKey('schedule-${widget.view.name}-$page'),
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    widget.view == ScheduleView.day ? AppSpacing.xsm : 0,
                    AppSpacing.screen,
                    100 + ninjaBottomInset(context),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: widget.builder(context, day),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

part of '../schedule_page.dart';

const _kScheduleViewMorphDuration = Duration(milliseconds: 520);

Widget _withScheduleEntrance(BuildContext context, Widget child) {
  final reduceMotion =
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);
  return reduceMotion ? child : child.animatePageEntrance();
}

class _ScheduleViewTransition extends StatefulWidget {
  const _ScheduleViewTransition({
    required this.view,
    required this.selectedDay,
    required this.agendaDayKeys,
    required this.monthDayKeys,
    required this.lessonColors,
    required this.activityTypes,
    required this.child,
  });

  final _ScheduleView view;
  final DateTime selectedDay;
  final Map<int, GlobalKey> agendaDayKeys;
  final Map<int, GlobalKey> monthDayKeys;
  final Map<int, List<Color>> lessonColors;
  final Map<int, List<UserActivityType>> activityTypes;
  final Widget child;

  @override
  State<_ScheduleViewTransition> createState() =>
      _ScheduleViewTransitionState();
}

class _ScheduleViewTransitionState extends State<_ScheduleViewTransition>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stageKey = GlobalKey();
  late final AnimationController _controller;
  late _ScheduleView _fromView;
  late _ScheduleView _toView;
  late _ScheduleView _targetView;
  late Widget _fromChild;
  late Widget _toChild;
  List<_CalendarMorphGeometry> _calendarGeometry = const [];
  bool _transitioning = false;
  bool _calendarTransition = false;
  bool _morphReady = false;
  int _prepareToken = 0;

  bool get _reduceMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  bool _isDayMonthPair(_ScheduleView a, _ScheduleView b) =>
      (a == _ScheduleView.agenda && b == _ScheduleView.month) ||
      (a == _ScheduleView.month && b == _ScheduleView.agenda);

  @override
  void initState() {
    super.initState();
    _fromView = widget.view;
    _toView = widget.view;
    _targetView = widget.view;
    _fromChild = widget.child;
    _toChild = widget.child;
    _controller = AnimationController(
      vsync: this,
      duration: _kScheduleViewMorphDuration,
    )..addStatusListener(_handleStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion && _transitioning) {
      _controller.stop();
      _prepareToken++;
      _settle(widget.view, widget.child);
    }
  }

  @override
  void didUpdateWidget(covariant _ScheduleViewTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view == widget.view) {
      if (!_transitioning) {
        _fromChild = widget.child;
        _toChild = widget.child;
      } else if (_targetView == _fromView) {
        _fromChild = widget.child;
      } else {
        _toChild = widget.child;
      }
      return;
    }

    if (_reduceMotion) {
      _controller.stop();
      _prepareToken++;
      _settle(widget.view, widget.child);
      return;
    }

    if (_transitioning && widget.view == _fromView) {
      _targetView = _fromView;
      _fromChild = widget.child;
      if (_morphReady || !_calendarTransition) {
        unawaited(_controller.reverse());
      } else {
        _prepareToken++;
        _settle(_fromView, _fromChild);
      }
      return;
    }

    if (_transitioning && widget.view == _toView) {
      _targetView = _toView;
      _toChild = widget.child;
      if (_morphReady || !_calendarTransition) {
        unawaited(_controller.forward());
      }
      return;
    }

    if (_transitioning) {
      _controller.stop();
      _prepareToken++;
      _settle(widget.view, widget.child);
      return;
    }

    _fromView = _targetView;
    _fromChild = _toChild;
    _toView = widget.view;
    _targetView = widget.view;
    _toChild = widget.child;
    _transitioning = true;
    _calendarTransition = _isDayMonthPair(_fromView, _toView);
    _morphReady = false;
    _calendarGeometry = const [];
    _controller.value = 0;

    if (_calendarTransition) {
      _scheduleGeometryPreparation();
    } else {
      unawaited(_controller.forward());
    }
  }

  void _scheduleGeometryPreparation() {
    final token = ++_prepareToken;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || token != _prepareToken || !_transitioning) return;
      final geometry = _measureCalendarGeometry();
      if (geometry.isEmpty) {
        _calendarTransition = false;
        unawaited(_controller.forward());
        return;
      }
      setState(() {
        _calendarGeometry = geometry;
        _morphReady = true;
      });
      unawaited(_controller.forward());
    });
  }

  List<_CalendarMorphGeometry> _measureCalendarGeometry() {
    final stage = _stageKey.currentContext?.findRenderObject();
    if (stage is! RenderBox || !stage.attached) return const [];
    final colors = context.ninja;
    final result = <_CalendarMorphGeometry>[];
    for (final day in weekDaysFor(widget.selectedDay)) {
      final key = _dayKey(day);
      final agenda = _rectInStage(widget.agendaDayKeys[key], stage);
      final month = _rectInStage(widget.monthDayKeys[key], stage);
      if (agenda == null || month == null) continue;
      result.add(
        _CalendarMorphGeometry(
          day: day,
          agendaRect: agenda,
          monthRect: month,
          lessonColors: widget.lessonColors[key] ?? const [],
          activityColors: [
            for (final type
                in widget.activityTypes[key] ?? const <UserActivityType>[])
              _activityColor(colors, type),
          ],
        ),
      );
    }
    return result;
  }

  Rect? _rectInStage(GlobalKey? key, RenderBox stage) {
    final renderObject = key?.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return null;
    final origin = renderObject.localToGlobal(Offset.zero, ancestor: stage);
    return origin & renderObject.size;
  }

  void _handleStatus(AnimationStatus status) {
    if (!_transitioning) return;
    switch (status) {
      case AnimationStatus.completed:
        if (_targetView == _toView) {
          setState(() => _settle(_toView, _toChild));
        }
      case AnimationStatus.dismissed:
        if (_targetView == _fromView) {
          setState(() => _settle(_fromView, _fromChild));
        }
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
    }
  }

  void _settle(_ScheduleView view, Widget child) {
    _fromView = view;
    _toView = view;
    _targetView = view;
    _fromChild = child;
    _toChild = child;
    _calendarGeometry = const [];
    _transitioning = false;
    _calendarTransition = false;
    _morphReady = false;
  }

  @override
  void dispose() {
    _prepareToken++;
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _stageKey,
      child: ClipRect(
        child: AnimatedBuilder(
          key: const ValueKey('schedule-view-transition'),
          animation: _controller,
          builder: (context, child) {
            if (_reduceMotion || !_transitioning) {
              return Stack(
                fit: .expand,
                children: [
                  _buildLayer(
                    view: widget.view,
                    child: widget.child,
                    active: true,
                    opacity: 1,
                    sharedDays: const {},
                    blockPointer: false,
                  ),
                ],
              );
            }
            final targetReveal = Curves.easeOutCubic.transform(
              ((_controller.value - 0.08) / 0.82).clamp(0, 1),
            );
            final sharedDays = {
              for (final geometry in _calendarGeometry) _dayKey(geometry.day),
            };
            return Stack(
              fit: .expand,
              children: [
                _buildLayer(
                  view: _fromView,
                  child: _fromChild,
                  active: _targetView == _fromView,
                  opacity: 1,
                  sharedDays: sharedDays,
                  blockPointer: true,
                ),
                _buildLayer(
                  view: _toView,
                  child: _toChild,
                  active: _targetView == _toView,
                  opacity: targetReveal,
                  sharedDays: sharedDays,
                  blockPointer: true,
                ),
                if (_calendarTransition && _morphReady)
                  _CalendarMorphOverlay(
                    animation: _controller,
                    toView: _toView,
                    selectedDay: widget.selectedDay,
                    geometry: _calendarGeometry,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLayer({
    required _ScheduleView view,
    required Widget child,
    required bool active,
    required double opacity,
    required Set<int> sharedDays,
    required bool blockPointer,
  }) {
    Widget result = ColoredBox(color: context.ninja.canvas, child: child);
    result = _CalendarMorphScope(
      animation: _controller,
      enabled: _calendarTransition && _morphReady,
      fromView: _fromView,
      toView: _toView,
      layerView: view,
      selectedDay: widget.selectedDay,
      sharedDays: sharedDays,
      child: result,
    );
    return KeyedSubtree(
      key: ValueKey('schedule-view-layer-${view.name}'),
      child: IgnorePointer(
        ignoring: blockPointer,
        child: ExcludeSemantics(
          excluding: !active,
          child: Opacity(opacity: opacity, child: result),
        ),
      ),
    );
  }
}

class _CalendarMorphScope extends InheritedWidget {
  const _CalendarMorphScope({
    required this.animation,
    required this.enabled,
    required this.fromView,
    required this.toView,
    required this.layerView,
    required this.selectedDay,
    required this.sharedDays,
    required super.child,
  });

  final Animation<double> animation;
  final bool enabled;
  final _ScheduleView fromView;
  final _ScheduleView toView;
  final _ScheduleView layerView;
  final DateTime selectedDay;
  final Set<int> sharedDays;

  static _CalendarMorphScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  double monthProgress(double progress) => toView == _ScheduleView.month
      ? Curves.easeInOutCubic.transform(progress)
      : 1 - Curves.easeInOutCubic.transform(progress);

  bool isShared(DateTime day) => sharedDays.contains(_dayKey(day));

  int get selectedMonthRow {
    final first = DateTime(selectedDay.year, selectedDay.month);
    final leading = (first.weekday - DateTime.monday) % 7;
    return (leading + selectedDay.day - 1) ~/ 7;
  }

  int monthRow(DateTime day) {
    final first = DateTime(day.year, day.month);
    final leading = (first.weekday - DateTime.monday) % 7;
    return (leading + day.day - 1) ~/ 7;
  }

  @override
  bool updateShouldNotify(_CalendarMorphScope oldWidget) =>
      enabled != oldWidget.enabled ||
      fromView != oldWidget.fromView ||
      toView != oldWidget.toView ||
      layerView != oldWidget.layerView ||
      selectedDay != oldWidget.selectedDay ||
      !const SetEquality<int>().equals(sharedDays, oldWidget.sharedDays);
}

class _CalendarMorphGeometry {
  const _CalendarMorphGeometry({
    required this.day,
    required this.agendaRect,
    required this.monthRect,
    required this.lessonColors,
    required this.activityColors,
  });

  final DateTime day;
  final Rect agendaRect;
  final Rect monthRect;
  final List<Color> lessonColors;
  final List<Color> activityColors;
}

class _CalendarMorphOverlay extends StatelessWidget {
  const _CalendarMorphOverlay({
    required this.animation,
    required this.toView,
    required this.selectedDay,
    required this.geometry,
  });

  final Animation<double> animation;
  final _ScheduleView toView;
  final DateTime selectedDay;
  final List<_CalendarMorphGeometry> geometry;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final monthProgress = toView == _ScheduleView.month
                ? Curves.easeInOutCubic.transform(animation.value)
                : 1 - Curves.easeInOutCubic.transform(animation.value);
            final agendaEndpoint = const Interval(
              0,
              0.18,
              curve: Curves.easeOutCubic,
            ).transform(monthProgress);
            final monthEndpoint = const Interval(
              0.82,
              1,
              curve: Curves.easeInCubic,
            ).transform(monthProgress);
            final overlayOpacity = math.min(
              agendaEndpoint,
              1 - monthEndpoint,
            );
            return Opacity(
              opacity: overlayOpacity,
              child: Stack(
                children: [
                  for (final item in geometry)
                    Positioned.fromRect(
                      rect: Rect.lerp(
                        item.agendaRect,
                        item.monthRect,
                        monthProgress,
                      )!,
                      child: _CalendarMorphDayFace(
                        key: ValueKey(
                          'calendar-morph-day-${_dayKey(item.day)}',
                        ),
                        day: item.day,
                        lessonColors: item.lessonColors,
                        activityColors: item.activityColors,
                        selected: isSameDate(item.day, selectedDay),
                        today: isSameDate(item.day, DateTime.now()),
                        monthProgress: monthProgress,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalendarMorphDayFace extends StatelessWidget {
  const _CalendarMorphDayFace({
    required this.day,
    required this.lessonColors,
    required this.activityColors,
    required this.selected,
    required this.today,
    required this.monthProgress,
    super.key,
  });

  final DateTime day;
  final List<Color> lessonColors;
  final List<Color> activityColors;
  final bool selected;
  final bool today;
  final double monthProgress;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final dayInfo = RussianWorkCalendar.dayInfo(day);
    final locale = Localizations.localeOf(context).toString();
    final sourceBackground = selected
        ? colors.brand
        : today
        ? colors.brandTint
        : dayInfo.isSpecial
        ? _scheduleDaySurface(colors, dayInfo)
        : colors.surfaceAlt.withValues(alpha: .62);
    final targetBackground = today
        ? colors.brand
        : selected
        ? colors.surfaceAlt
        : dayInfo.isSpecial
        ? _scheduleDaySurface(colors, dayInfo)
        : lessonColors.isNotEmpty || activityColors.isNotEmpty
        ? colors.surfaceAlt
        : Colors.transparent;
    final sourceForeground = selected
        ? colors.onBrand
        : today
        ? colors.brandInk
        : dayInfo.isSpecial
        ? _scheduleDayAccent(colors, dayInfo)
        : colors.ink;
    final targetForeground = today
        ? colors.onBrand
        : selected
        ? colors.brandInk
        : dayInfo.isSpecial
        ? _scheduleDayAccent(colors, dayInfo)
        : colors.ink;
    final weekday = DateFormat('EE', locale).format(day).toUpperCase();
    final lessonLoad = lessonColors.length;
    final level = monthCellLoadLevel(lessonLoad);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final sourceTextScale = textScale.clamp(1.0, _kWeekStripMaxTextScale);
    final largeText = textScale >= 1.5;
    final sourceWeekdaySize =
        (NinjaText.microLabel.fontSize ?? 11.5) * sourceTextScale;
    final sourceDaySize = 16 * sourceTextScale;
    final targetDaySize = largeText ? 15.0 : 13.0;

    return Padding(
      padding: EdgeInsets.lerp(
        const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        const EdgeInsets.all(2),
        monthProgress,
      )!,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.lerp(
            sourceBackground,
            targetBackground,
            monthProgress,
          ),
          border: selected && !today
              ? Border.all(
                  color: colors.brandInk.withValues(alpha: monthProgress),
                  width: 1.5 * monthProgress,
                )
              : null,
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Stack(
          alignment: .topCenter,
          children: [
            if (dayInfo.isSpecial)
              Positioned(
                key: ValueKey(
                  'calendar-morph-day-off-${_dayKey(day)}',
                ),
                top: 7,
                right: 7,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        selected
                            ? colors.onBrand
                            : today
                            ? colors.brandInk
                            : _scheduleDayAccent(colors, dayInfo),
                        today
                            ? colors.onBrand
                            : selected
                            ? colors.brandInk
                            : _scheduleDayAccent(colors, dayInfo),
                        monthProgress,
                      ),
                      borderRadius: .circular(1),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 9 + 2 * monthProgress,
              child: Opacity(
                opacity: 1 - monthProgress,
                child: Text(
                  weekday,
                  textScaler: TextScaler.noScaling,
                  style: NinjaText.microLabel.copyWith(
                    fontSize: sourceWeekdaySize,
                    color: Color.lerp(
                      sourceForeground,
                      targetForeground,
                      monthProgress,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0.08),
                Alignment.topCenter,
                monthProgress,
              )!,
              child: Padding(
                padding: EdgeInsets.only(top: 5 * monthProgress),
                child: Text(
                  '${day.day}',
                  textScaler: TextScaler.noScaling,
                  style: NinjaText.tabular(
                    NinjaText.headline.copyWith(
                      fontSize:
                          sourceDaySize +
                          (targetDaySize - sourceDaySize) * monthProgress,
                      color: Color.lerp(
                        sourceForeground,
                        targetForeground,
                        monthProgress,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (lessonLoad > 0 || activityColors.isNotEmpty) ...[
              Align(
                alignment: const Alignment(0, 0.76),
                child: Opacity(
                  opacity: 1 - monthProgress,
                  child: _ScheduleDayLoadDots(
                    lessonColors: lessonColors,
                    activityColors: activityColors,
                    selected: selected,
                  ),
                ),
              ),
              if (lessonLoad > 0)
                Positioned(
                  top: largeText ? 27 : 23,
                  left: 8,
                  right: 8,
                  child: Opacity(
                    opacity: monthProgress,
                    child: Column(
                      key: ValueKey(
                        'calendar-morph-lesson-bars-${_dayKey(day)}',
                      ),
                      crossAxisAlignment: .stretch,
                      children: [
                        for (var index = 0; index < level; index++) ...[
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: today
                                  ? colors.onBrand
                                  : (lessonColors.elementAtOrNull(
                                          index * lessonColors.length ~/ level,
                                        ) ??
                                        colors.brand),
                              borderRadius: .circular(NinjaRadius.pill),
                            ),
                          ),
                          if (index != level - 1) const SizedBox(height: 2),
                        ],
                      ],
                    ),
                  ),
                ),
              if (activityColors.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
                  child: Opacity(
                    opacity: monthProgress,
                    child: Row(
                      key: ValueKey(
                        'calendar-morph-activity-dots-${_dayKey(day)}',
                      ),
                      mainAxisAlignment: .center,
                      children: [
                        for (final color in activityColors.take(3))
                          Padding(
                            padding: const .symmetric(horizontal: 1),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: today ? colors.onBrand : color,
                                shape: .circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalendarMorphMonthCell extends StatelessWidget {
  const _CalendarMorphMonthCell({
    required this.scope,
    required this.day,
    required this.child,
  });

  final _CalendarMorphScope scope;
  final DateTime day;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (scope.isShared(day)) {
      return _CalendarMorphSharedCell(
        scope: scope,
        monthCell: true,
        child: child,
      );
    }
    final row = scope.monthRow(day);
    final rowDistance = (row - scope.selectedMonthRow).abs();
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: scope.animation,
        child: child,
        builder: (_, animatedChild) {
          final monthProgress = scope.monthProgress(scope.animation.value);
          final start = 0.08 + math.min(rowDistance, 4) * 0.055;
          final end = math.min(1, start + 0.58).toDouble();
          final reveal = Interval(
            start,
            end,
            curve: Curves.easeOutCubic,
          ).transform(monthProgress);
          final rowTravel =
              (scope.selectedMonthRow - row) *
              (constraints.maxHeight + 2) *
              (1 - reveal);
          return IgnorePointer(
            child: Opacity(
              opacity: reveal,
              child: Transform.translate(
                offset: Offset(0, rowTravel),
                child: Transform.scale(
                  scale: 0.9 + 0.1 * reveal,
                  child: animatedChild,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CalendarMorphSharedCell extends StatelessWidget {
  const _CalendarMorphSharedCell({
    required this.scope,
    required this.monthCell,
    required this.child,
  });

  final _CalendarMorphScope scope;
  final bool monthCell;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scope.animation,
      child: child,
      builder: (_, animatedChild) {
        final progress = scope.monthProgress(scope.animation.value);
        final opacity = monthCell
            ? const Interval(
                0.82,
                1,
                curve: Curves.easeInCubic,
              ).transform(progress)
            : 1 -
                  const Interval(
                    0,
                    0.18,
                    curve: Curves.easeOutCubic,
                  ).transform(progress);
        return IgnorePointer(
          child: Opacity(opacity: opacity, child: animatedChild),
        );
      },
    );
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_meta.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/month_load.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_page.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule_management/view/view.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'schedule_page/activity_row.dart';
part 'schedule_page/busy_day_density_bar.dart';
part 'schedule_page/change_callout.dart';
part 'schedule_page/empty_day_card.dart';
part 'schedule_page/empty_filter_sliver.dart';
part 'schedule_page/filter_chips.dart';
part 'schedule_page/friends_on_class.dart';
part 'schedule_page/gap_row.dart';
part 'schedule_page/inline_reactions.dart';
part 'schedule_page/lesson_extra_row.dart';
part 'schedule_page/lesson_progress_bar.dart';
part 'schedule_page/lesson_queries.dart';
part 'schedule_page/list_schedule_sliver.dart';
part 'schedule_page/month_cell.dart';
part 'schedule_page/month_legend.dart';
part 'schedule_page/month_schedule_sliver.dart';
part 'schedule_page/month_switcher.dart';
part 'schedule_page/note_row.dart';
part 'schedule_page/now_chip.dart';
part 'schedule_page/offline_banner.dart';
part 'schedule_page/past_summary.dart';
part 'schedule_page/schedule_agenda_slivers.dart';
part 'schedule_page/schedule_chrome.dart';
part 'schedule_page/schedule_clock_ticker.dart';
part 'schedule_page/schedule_day_button.dart';
part 'schedule_page/schedule_day_off_style.dart';
part 'schedule_page/schedule_day_model.dart';
part 'schedule_page/schedule_day_page.dart';
part 'schedule_page/schedule_day_pager.dart';
part 'schedule_page/schedule_empty_block.dart';
part 'schedule_page/schedule_empty_sliver.dart';
part 'schedule_page/schedule_fab.dart';
part 'schedule_page/schedule_filter.dart';
part 'schedule_page/schedule_floating_actions.dart';
part 'schedule_page/schedule_header.dart';
part 'schedule_page/schedule_month_label.dart';
part 'schedule_page/schedule_more_actions_sheet.dart';
part 'schedule_page/schedule_next_lesson_card.dart';
part 'schedule_page/schedule_now_marker.dart';
part 'schedule_page/schedule_unavailable.dart';
part 'schedule_page/schedule_view.dart';
part 'schedule_page/schedule_view_transition.dart';
part 'schedule_page/timeline_children.dart';
part 'schedule_page/timeline_lesson_card.dart';
part 'schedule_page/view_selector.dart';
part 'schedule_page/week_activity_chip.dart';
part 'schedule_page/week_day_column.dart';
part 'schedule_page/week_lesson_chip.dart';
part 'schedule_page/week_pager_strip.dart';
part 'schedule_page/week_parity_switcher.dart';
part 'schedule_page/week_schedule_sliver.dart';
part 'schedule_page/week_strip_page.dart';
part 'schedule_page/week_today_pill.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with _ScheduleClockTicker {
  _ScheduleView _view = .agenda;
  _ScheduleFilter _filter = .all;
  DateTime _selectedDay = dateOnly(DateTime.now());
  DateTime _clockNow = DateTime.now();
  bool _showPast = false;

  SelectedSchedule? _previousSelectedSchedule;
  final GlobalKey _nowMarkerKey = GlobalKey();
  final Map<int, GlobalKey> _agendaMorphDayKeys = {};
  final Map<int, GlobalKey> _monthMorphDayKeys = {};
  final ValueNotifier<double> _selectorCollapse = ValueNotifier(0);

  late final SchedulePaging _paging;
  late final ScheduleMonthPaging _monthPaging;
  late PageController _dayController;
  late PageController _weekController;
  late PageController _monthController;
  late int _monthTargetPage;
  int _pagerGuards = 0;
  int _monthPagerGuards = 0;

  @override
  bool get isClockTickNeeded =>
      _view == .agenda && isSameDate(_selectedDay, _clockNow);

  @override
  void onClockTick() => setState(() => _clockNow = DateTime.now());

  @override
  void initState() {
    super.initState();
    _previousSelectedSchedule = context
        .read<ScheduleBloc>()
        .state
        .selectedSchedule;
    _paging = SchedulePaging(today: _selectedDay);
    _monthPaging = ScheduleMonthPaging(today: _selectedDay);
    final page = _paging.dayPageOf(_selectedDay);
    _dayController = PageController(initialPage: page);
    _weekController = PageController(
      initialPage: _paging.weekPageOfDayPage(page),
    );
    _monthTargetPage = _monthPaging.pageOf(_selectedDay);
    _monthController = PageController(initialPage: _monthTargetPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUserActivities(_selectedDay);
      _loadScheduleChanges();
      _loadClassmates();
    });
  }

  @override
  void dispose() {
    _dayController.dispose();
    _weekController.dispose();
    _monthController.dispose();
    _selectorCollapse.dispose();
    super.dispose();
  }

  void _loadClassmates() {
    final selected = context.read<ScheduleBloc>().state.selectedSchedule;
    final group = selected is SelectedGroupSchedule ? selected.group.name : '';
    unawaited(context.read<ClassmatesCubit>().load(group));
  }

  void _loadUserActivities(DateTime around) {
    unawaited(
      context.read<UserActivitiesCubit>().load(
        from: DateTime(around.year, around.month - 1),
        to: DateTime(around.year, around.month + 2, 0),
      ),
    );
  }

  void _loadScheduleChanges() {
    final selected = context.read<ScheduleBloc>().state.selectedSchedule;
    final request = _changesRequestFor(selected);
    if (request == null) return;
    unawaited(
      context.read<ScheduleChangesCubit>().load(
        targetType: request.$1,
        target: request.$2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: _listenScheduleState,
      buildWhen: (previous, current) {
        return current.selectedSchedule != previous.selectedSchedule ||
            current.status != previous.status ||
            current.isOffline != previous.isOffline ||
            current.lastSyncedAt != previous.lastSyncedAt;
      },
      builder: (context, state) {
        final selectedSchedule = state.selectedSchedule;
        if (state.status == .loading && selectedSchedule == null) {
          return Scaffold(
            backgroundColor: colors.canvas,
            body: const SafeArea(bottom: false, child: ScheduleSkeleton()),
          );
        }

        if (selectedSchedule == null) {
          return Scaffold(
            backgroundColor: colors.canvas,
            body: SafeArea(
              bottom: false,
              child: _ScheduleUnavailable(
                failed: state.status == .failure,
                onRetry: () => unawaited(_refreshSchedule()),
                onConfigure: () => openGlobalSearch(context),
              ),
            ),
          );
        }

        final parts = selectedSchedule.schedule;
        final preferences = context.watch<SchedulePreferencesCubit>().state;
        final activities = context.watch<UserActivitiesCubit>().state;
        final day = _ScheduleDayModel.resolve(
          parts: parts,
          day: _selectedDay,
          preferences: preferences,
          activities: activities,
          filter: _filter,
        );
        final morphWeek = weekDaysFor(_selectedDay);
        final morphLessonColors = <int, List<Color>>{
          for (final date in morphWeek)
            _dayKey(date): [
              for (final lesson in _applyPreferences(
                _lessonsForDay(parts, date),
                preferences,
              ))
                colors.subjectColor(lesson.subject),
            ],
        };
        final morphActivityTypes = <int, List<UserActivityType>>{
          for (final date in morphWeek) _dayKey(date): activities.typesOn(date),
        };

        return Scaffold(
          backgroundColor: colors.canvas,
          body: SafeArea(
            bottom: false,
            child: _withScheduleEntrance(
              context,
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  _ScheduleChrome(
                    scheduleName: selectedSchedule.name,
                    onSearch: () => openGlobalSearch(context),
                    onMore: () => unawaited(
                      _showScheduleMoreActions(
                        context,
                        scheduleName: selectedSchedule.name,
                      ),
                    ),
                  ),
                  if (state.isOffline)
                    _OfflineBanner(lastSyncedAt: state.lastSyncedAt),
                  ValueListenableBuilder<double>(
                    valueListenable: _selectorCollapse,
                    child: AppTourAnchor(
                      target: .scheduleViews,
                      child: _ViewSelector(value: _view, onChanged: _setView),
                    ),
                    builder: (context, value, child) => _CollapsingViewSelector(
                      progress: value,
                      child: child!,
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _handleScheduleScroll,
                      child: _ScheduleViewTransition(
                        view: _view,
                        selectedDay: _selectedDay,
                        agendaDayKeys: _agendaMorphDayKeys,
                        monthDayKeys: _monthMorphDayKeys,
                        lessonColors: morphLessonColors,
                        activityTypes: morphActivityTypes,
                        child: _viewContent(
                          colors: colors,
                          parts: parts,
                          activities: activities,
                          preferences: preferences,
                          day: day,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _ScheduleFloatingActions(
            showToday: !isSameDate(_selectedDay, DateTime.now()),
            showAdd:
                _view == .agenda &&
                (day.lessons.isNotEmpty || day.activities.isNotEmpty),
            onToday: _goToToday,
            onAdd: _openAddActivity,
          ),
        );
      },
    );
  }

  Widget _viewContent({
    required NinjaColors colors,
    required List<SchedulePart> parts,
    required UserActivitiesState activities,
    required SchedulePreferencesState preferences,
    required _ScheduleDayModel day,
  }) {
    if (_view == .month) {
      return _monthView(
        colors: colors,
        parts: parts,
        preferences: preferences,
      );
    }
    if (_view == .week) {
      return _weekView(
        colors: colors,
        parts: parts,
        activities: activities,
        preferences: preferences,
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _ScheduleMonthLabel(
          day: _selectedDay,
          onTap: () => _setView(.month),
        ),
        AppTourAnchor(
          target: .scheduleWeek,
          child: _WeekPagerStrip(
            controller: _weekController,
            paging: _paging,
            selectedDay: _selectedDay,
            schedule: parts,
            activities: activities,
            preferences: preferences,
            dayLayoutKeyBuilder: _agendaMorphKeyFor,
            onDaySelected: _selectDay,
            onWeekPageChanged: _onWeekPageChanged,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              _ScheduleDayPager(
                controller: _dayController,
                paging: _paging,
                parts: parts,
                preferences: preferences,
                activities: activities,
                filter: _filter,
                showPast: _showPast,
                nowMarkerKey: _nowMarkerKey,
                onPageChanged: _onDayPageChanged,
                onRefresh: _refreshSchedule,
                onTogglePast: () => setState(() => _showPast = !_showPast),
                onAddActivity: _openAddActivity,
                onShowWeek: () => _setView(.week),
                onFilterChanged: (value) => setState(() => _filter = value),
                onLessonTap: _openLesson,
                onLessonActions: _openLessonActions,
              ),
              if (day.hasNow) _NowChip(onTap: _scrollToLive),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekView({
    required NinjaColors colors,
    required List<SchedulePart> parts,
    required UserActivitiesState activities,
    required SchedulePreferencesState preferences,
  }) {
    final content = RefreshIndicator(
      onRefresh: _refreshSchedule,
      color: colors.ink,
      backgroundColor: colors.canvas,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _WeekScheduleSliver(
            days: weekDaysFor(_selectedDay),
            schedule: parts,
            activities: activities,
            preferences: preferences,
            filter: _filter,
            onWeekShift: _shiftWeek,
            onDaySelected: (value) => _selectDay(value, view: .agenda),
          ),
        ],
      ),
    );
    return GestureDetector(
      behavior: .opaque,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < 180) return;
        _shiftWeek(velocity < 0 ? 1 : -1);
      },
      child: content,
    );
  }

  Widget _monthView({
    required NinjaColors colors,
    required List<SchedulePart> parts,
    required SchedulePreferencesState preferences,
  }) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _MonthCalendarHeader(
          month: _selectedDay,
          onPrev: () => _shiftMonth(-1),
          onNext: () => _shiftMonth(1),
        ),
        Expanded(
          child: PageView.builder(
            key: const ValueKey('schedule-month-pager'),
            controller: _monthController,
            itemCount: _monthPaging.pageCount,
            allowImplicitScrolling: true,
            onPageChanged: _onMonthPageChanged,
            itemBuilder: (context, index) {
              final month = _monthPaging.monthOfPage(index);
              return RefreshIndicator(
                onRefresh: _refreshSchedule,
                color: colors.ink,
                backgroundColor: colors.canvas,
                child: CustomScrollView(
                  key: PageStorageKey('schedule-month-$index'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _MonthScheduleSliver(
                      month: month,
                      selectedDay: _selectedDay,
                      dayLayoutKeyBuilder: _monthMorphKeyFor,
                      schedule: parts,
                      preferences: preferences,
                      onDaySelected: (value) =>
                          _selectDay(value, view: .agenda),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _shiftWeek(int delta) {
    _selectDay(_selectedDay.add(Duration(days: 7 * delta)));
  }

  void _shiftMonth(int delta) {
    if (!_monthController.hasClients) {
      _selectDay(DateTime(_selectedDay.year, _selectedDay.month + delta));
      return;
    }
    final target = (_monthTargetPage + delta).clamp(
      0,
      _monthPaging.pageCount - 1,
    );
    _applySelectedDay(_monthPaging.dayInPage(target, _selectedDay.day));
    unawaited(
      _driveMonthPager(
        target,
        animate: NinjaMotion.of(context) != Duration.zero,
      ),
    );
  }

  void _goToToday() {
    final today = dateOnly(DateTime.now());
    _selectorCollapse.value = 0;
    _selectDay(today);
  }

  bool _handleScheduleScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final next = (notification.metrics.pixels / 72).clamp(0.0, 1.0);
    if ((next - _selectorCollapse.value).abs() >= .01 ||
        next == 0 ||
        next == 1) {
      _selectorCollapse.value = next;
    }
    return false;
  }

  GlobalKey _agendaMorphKeyFor(DateTime day) => _agendaMorphDayKeys.putIfAbsent(
    _dayKey(day),
    GlobalKey.new,
  );

  GlobalKey _monthMorphKeyFor(DateTime day) => _monthMorphDayKeys.putIfAbsent(
    _dayKey(day),
    GlobalKey.new,
  );

  void _setView(_ScheduleView view) {
    if (view == _view) return;
    unawaited(HapticFeedback.selectionClick());
    _selectorCollapse.value = 0;
    setState(() {
      if (view == .agenda && _view != .agenda && !_dayController.hasClients) {
        _resetPagers();
      }
      if (view == .month && _view != .month && !_monthController.hasClients) {
        _resetMonthPager();
      }
      _view = view;
      if (view != .agenda) _filter = .all;
    });
  }

  void _resetPagers() {
    final previousDay = _dayController;
    final previousWeek = _weekController;
    final page = _paging.dayPageOf(_selectedDay);
    _dayController = PageController(initialPage: page);
    _weekController = PageController(
      initialPage: _paging.weekPageOfDayPage(page),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previousDay.dispose();
      previousWeek.dispose();
    });
  }

  void _resetMonthPager() {
    final previous = _monthController;
    _monthTargetPage = _monthPaging.pageOf(_selectedDay);
    _monthController = PageController(initialPage: _monthTargetPage);
    WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
  }

  void _selectDay(DateTime day, {_ScheduleView? view}) {
    final next = dateOnly(day);
    if (view == .agenda && _view != .agenda) {
      _applySelectedDay(next, view: view);
      if (_dayController.hasClients) {
        _syncPagers(next);
      } else {
        _resetPagers();
      }
      return;
    }
    _applySelectedDay(next, view: view);
    _syncPagers(next);
    _syncMonthPager(next);
  }

  void _applySelectedDay(DateTime day, {_ScheduleView? view}) {
    final monthChanged =
        day.year != _selectedDay.year || day.month != _selectedDay.month;
    setState(() {
      _selectedDay = day;
      _showPast = false;
      if (view != null) _view = view;
    });
    if (monthChanged) _loadUserActivities(_selectedDay);
    _pruneMorphKeys();
  }

  void _pruneMorphKeys() {
    final agendaDays = weekDaysFor(_selectedDay).map(_dayKey).toSet();
    final monthDays = <int>{};
    for (var offset = -1; offset <= 1; offset++) {
      final first = DateTime(
        _selectedDay.year,
        _selectedDay.month + offset,
      );
      final count = DateTime(first.year, first.month + 1, 0).day;
      for (var day = 1; day <= count; day++) {
        monthDays.add(_dayKey(DateTime(first.year, first.month, day)));
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _agendaMorphDayKeys.removeWhere(
        (day, key) => !agendaDays.contains(day) && key.currentContext == null,
      );
      _monthMorphDayKeys.removeWhere(
        (day, key) => !monthDays.contains(day) && key.currentContext == null,
      );
    });
  }

  int? _pageOf(PageController controller) {
    if (!controller.hasClients) return null;
    final position = controller.position;
    if (!position.hasPixels || !position.hasContentDimensions) return null;
    return controller.page?.round();
  }

  Future<void> _drivePager(
    PageController controller,
    int page, {
    required bool animate,
  }) async {
    if (!controller.hasClients) return;
    _pagerGuards++;
    try {
      if (animate) {
        await controller.animateToPage(
          page,
          duration: NinjaMotion.of(context),
          curve: NinjaMotion.enter,
        );
      } else {
        controller.jumpToPage(page);
      }
    } finally {
      _pagerGuards--;
    }
  }

  Future<void> _driveMonthPager(int page, {required bool animate}) async {
    if (!_monthController.hasClients) return;
    _monthTargetPage = page;
    _monthPagerGuards++;
    try {
      if (animate) {
        await _monthController.animateToPage(
          page,
          duration: NinjaMotion.of(context, NinjaMotion.slow),
          curve: NinjaMotion.enter,
        );
      } else {
        _monthController.jumpToPage(page);
      }
    } finally {
      _monthPagerGuards--;
    }
  }

  void _syncPagers(DateTime day) {
    final dayPage = _paging.dayPageOf(day);
    final weekPage = _paging.weekPageOfDayPage(dayPage);
    final instant = NinjaMotion.of(context) == Duration.zero;

    final currentDay = _pageOf(_dayController);
    if (currentDay != null && currentDay != dayPage) {
      unawaited(
        _drivePager(
          _dayController,
          dayPage,
          animate: !instant && !schedulePagerShouldJump(currentDay, dayPage),
        ),
      );
    }

    final currentWeek = _pageOf(_weekController);
    if (currentWeek != null && currentWeek != weekPage) {
      unawaited(
        _drivePager(
          _weekController,
          weekPage,
          animate:
              !instant &&
              !schedulePagerShouldJump(currentWeek, weekPage, threshold: 2),
        ),
      );
    }
  }

  void _syncMonthPager(DateTime day) {
    final current = _pageOf(_monthController);
    final target = _monthPaging.pageOf(day);
    if (current == null) return;
    if (_monthTargetPage == target &&
        (_monthPagerGuards > 0 || current == target)) {
      return;
    }
    unawaited(
      _driveMonthPager(
        target,
        animate:
            NinjaMotion.of(context) != Duration.zero &&
            (target - current).abs() == 1,
      ),
    );
  }

  void _onDayPageChanged(int page) {
    if (_pagerGuards > 0) return;
    _selectorCollapse.value = 0;
    unawaited(HapticFeedback.selectionClick());
    _applySelectedDay(_paging.dayOfPage(page));
    final weekPage = _paging.weekPageOfDayPage(page);
    final currentWeek = _pageOf(_weekController);
    if (currentWeek == null || currentWeek == weekPage) return;
    unawaited(
      _drivePager(
        _weekController,
        weekPage,
        animate:
            NinjaMotion.of(context) != Duration.zero &&
            !schedulePagerShouldJump(currentWeek, weekPage, threshold: 2),
      ),
    );
  }

  void _onWeekPageChanged(int page) {
    if (_pagerGuards > 0) return;
    _selectorCollapse.value = 0;
    final dayPage = _paging.dayPageInWeek(page, _selectedDay.weekday);
    unawaited(HapticFeedback.selectionClick());
    _applySelectedDay(_paging.dayOfPage(dayPage));
    unawaited(_drivePager(_dayController, dayPage, animate: false));
  }

  void _onMonthPageChanged(int page) {
    if (_monthPagerGuards > 0) return;
    _monthTargetPage = page;
    _selectorCollapse.value = 0;
    unawaited(HapticFeedback.selectionClick());
    _applySelectedDay(_monthPaging.dayInPage(page, _selectedDay.day));
  }

  Future<void> _refreshSchedule() async {
    final bloc = context.read<ScheduleBloc>();
    final completion = bloc.stream.firstWhere(
      (state) => state.status == .loaded || state.status == .failure,
    );
    bloc.add(const SelectedScheduleRefreshRequested(manual: true));
    try {
      await completion.timeout(const Duration(seconds: 15));
    } on TimeoutException catch (_) {}
  }

  void _scrollToLive() {
    final liveContext = _nowMarkerKey.currentContext;
    if (liveContext == null) return;
    unawaited(
      Scrollable.ensureVisible(
        liveContext,
        duration: NinjaMotion.of(context, NinjaMotion.slow),
        curve: Curves.easeOut,
        alignment: 0.2,
      ),
    );
  }

  void _listenScheduleState(BuildContext context, ScheduleState state) {
    if (state.status == .failure) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.errorLoadingSchedule,
      );
      return;
    }

    if (state.status != .loaded || state.selectedSchedule == null) {
      return;
    }

    final oldParts =
        _previousSelectedSchedule?.schedule ?? const <SchedulePart>[];
    final newParts = state.selectedSchedule?.schedule ?? const <SchedulePart>[];
    final diff = computeScheduleDiff(oldParts, newParts);
    final scheduleChanged = _previousSelectedSchedule != state.selectedSchedule;
    _previousSelectedSchedule = state.selectedSchedule;

    if (scheduleChanged) {
      _loadScheduleChanges();
      _loadClassmates();
    }

    if (oldParts.isNotEmpty && diff.hasChanges) {
      final count =
          diff.added.length + diff.modified.length + diff.removed.length;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.scheduleUpdatedChanges(count),
      );
    }
  }

  void _openLesson(LessonSchedulePart lesson, DateTime day) {
    context.go('/schedule/details', extra: (lesson, day));
  }

  void _openLessonActions(LessonSchedulePart lesson, DateTime day) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(showClassActionsSheet(context, lesson: lesson, day: day));
  }

  void _openAddActivity() {
    context.go('/schedule/custom');
  }
}

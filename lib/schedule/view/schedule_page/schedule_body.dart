import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/promo/promo.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_diff_engine.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_clock_ticker.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_date_pager.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_quick_actions.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_view_transition.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

export 'schedule_paging.dart' show ScheduleView;

class ScheduleBody extends StatefulWidget {
  const ScheduleBody({
    this.now,
    this.initialView = ScheduleView.day,
    super.key,
  });

  final DateTime? now;
  final ScheduleView initialView;

  @override
  State<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> with ScheduleClockTicker {
  late DateTime _day = dateOnly(widget.now ?? DateTime.now());
  late ScheduleView _view = widget.initialView;
  ScheduleState? _previous;
  var _hintChecked = false;

  @override
  bool get isClockTickNeeded =>
      widget.now == null && isSameDate(_day, DateTime.now());

  @override
  void onClockTick() => setState(() {});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _previous = context.read<ScheduleBloc>().state;
      _loadRelated(_previous!.selectedSchedule);
    });
  }

  void _loadActivities() {
    unawaited(
      context.read<UserActivitiesCubit>().load(
        from: DateTime(_day.year, _day.month, -6),
        to: DateTime(_day.year, _day.month + 1, 8),
      ),
    );
  }

  void _loadRelated(SelectedSchedule? selected) {
    final request = changesRequestFor(selected);
    if (request != null) {
      unawaited(
        context.read<ScheduleChangesCubit>().load(
          targetType: request.$1,
          target: request.$2,
        ),
      );
    } else {
      context.read<ScheduleChangesCubit>().clear();
    }
    if (selected is SelectedGroupSchedule) {
      unawaited(context.read<ClassmatesCubit>().load(selected.group.name));
    }
    _loadActivities();
  }

  void _selectDay(DateTime day) {
    final differentMonth = day.month != _day.month || day.year != _day.year;
    setState(() => _day = dateOnly(day));
    if (differentMonth) _loadActivities();
  }

  void _listen(BuildContext context, ScheduleState state) {
    final previous = _previous;
    _previous = state;
    if (state.status == ScheduleStatus.failure) {
      ToastManager.showError(context, message: context.l10n.scheduleLoadError);
    }
    if (previous?.selectedSchedule != state.selectedSchedule) {
      if (previous?.selectedSchedule?.name == state.selectedSchedule?.name &&
          previous?.selectedSchedule != null &&
          state.selectedSchedule != null) {
        final diff = computeScheduleDiff(
          previous!.selectedSchedule!.schedule,
          state.selectedSchedule!.schedule,
        );
        final total =
            diff.added.length + diff.removed.length + diff.modified.length;
        if (total > 0) {
          ToastManager.showInfo(
            context,
            message: context.l10n.scheduleUpdatedChanges(total),
          );
        }
      }
      _loadRelated(state.selectedSchedule);
    }
  }

  void _maybeShowLongPressHint() {
    if (_hintChecked || !mounted) return;
    _hintChecked = true;
    final cubit = context.read<ScheduleDisplayCubit>();
    if (cubit.state.lessonActionsHintShown) return;
    cubit.markLessonActionsHintShown();
    ToastManager.showInfo(
      context,
      message: context.l10n.scheduleLessonLongPressHint,
    );
  }

  Future<void> _refresh() async {
    final bloc = context.read<ScheduleBloc>();
    final complete = bloc.stream.firstWhere(
      (s) => s.status != ScheduleStatus.loading,
    );
    bloc.add(const SelectedScheduleRefreshRequested(manual: true));
    await complete.timeout(
      const Duration(seconds: 30),
      onTimeout: () => bloc.state,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScheduleBloc>().state;
    final preferences = context.watch<SchedulePreferencesCubit>().state;
    final display = context.watch<ScheduleDisplayCubit>().state;
    final changesCubit = context.watch<ScheduleChangesCubit>();
    final comparison = context.watch<ScheduleComparisonCubit>();
    final activities = context.watch<UserActivitiesCubit>().state.activities;
    final selected = state.selectedSchedule;
    final l10n = context.l10n;
    final request = changesRequestFor(selected);
    final changes =
        request != null && changesCubit.matchesTarget(request.$1, request.$2)
        ? changesCubit.state.changes
        : changesCubit.state.changes.take(0).toList();
    final weekChanges = changesInWeek(changes, _day);
    final schedule = selected?.schedule ?? [];
    if (!_hintChecked && widget.now == null && schedule.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybeShowLongPressHint(),
      );
    }
    final showToday = !isSameDate(_day, widget.now ?? DateTime.now());
    final topInset = MediaQuery.paddingOf(context).top;
    final view = _view;
    Widget page(BuildContext context, DateTime day) => switch (view) {
      ScheduleView.day => ScheduleDayView(
        day: day,
        now: widget.now,
        schedule: schedule,
        changes: changes,
        preferences: preferences,
        display: display,
        activities: activities,
        comparing: comparison.state.isEnabled,
        onDay: _selectDay,
        showDayStrip: false,
      ),
      ScheduleView.week => ScheduleWeekView(
        day: day,
        now: widget.now,
        schedule: schedule,
        changes: changes,
        preferences: preferences,
        display: display,
        friend: comparison.state.isEnabled ? comparison.friend : null,
        activities: activities,
        onDay: _selectDay,
      ),
      ScheduleView.month => ScheduleMonthView(
        now: widget.now,
        day: day,
        schedule: schedule,
        preferences: preferences,
        display: display,
        changes: changes,
        activities: activities,
        onDay: (value) {
          _selectDay(value);
          setState(() => _view = ScheduleView.day);
        },
        onMonth: _selectDay,
      ),
    };
    final strip = ScheduleDayStrip(
      day: _day,
      now: widget.now ?? DateTime.now(),
      schedule: schedule,
      preferences: preferences,
      display: display,
      changes: changes,
      onDay: _selectDay,
    );
    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: _listen,
      child: ColoredBox(
        color: context.colors.canvas,
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refresh,
              child: SafeArea(
                bottom: false,
                child: NestedScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: ScheduleHeader(
                        day: _day,
                        name: selected?.name,
                        topInset: topInset,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screen,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ScheduleQuickActions(
                              hasChanges: changes.isNotEmpty,
                              onSearch: () => openScheduleSearch(context),
                              onChanges: () => const ScheduleChangesRoute()
                                  .push<void>(context),
                              onExport: () =>
                                  showScheduleShareSheet(context, day: _day),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ScheduleCalendarNotice(day: _day),
                            PromoBannerSlot(
                              placement: PromoPlacement.schedule,
                              now: widget.now,
                              compact: true,
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                            ),
                            if (state.isOffline) ...[
                              AppBanner(
                                message: l10n.offlineFromCache,
                                tone: AppBannerTone.warn,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            if (weekChanges.isNotEmpty &&
                                selected is! SelectedCustomSchedule) ...[
                              AppBanner(
                                message: l10n.scheduleChangesThisWeek(
                                  weekChanges.length,
                                ),
                                tone: AppBannerTone.warn,
                                actionLabel: l10n.scheduleShow,
                                onAction: () => showScheduleChangesSheet(
                                  context,
                                  weekOf: _day,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            if (comparison.state.isEnabled &&
                                comparison.friend != null) ...[
                              AppBanner(
                                message: l10n.scheduleCompareWith(
                                  comparison.friendName,
                                ),
                                actionLabel: l10n.scheduleCompareOff,
                                onAction: comparison.stop,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            const SizedBox(height: AppSpacing.xsm),
                            AppTourAnchor(
                              target: AppTourTarget.scheduleViews,
                              child: AppSegmentedControl<ScheduleView>(
                                options: [
                                  AppSegmentedOption(
                                    value: ScheduleView.day,
                                    label: l10n.scheduleViewDay,
                                  ),
                                  AppSegmentedOption(
                                    value: ScheduleView.week,
                                    label: l10n.week,
                                  ),
                                  AppSegmentedOption(
                                    value: ScheduleView.month,
                                    label: l10n.month,
                                  ),
                                ],
                                value: _view,
                                onCanvas: true,
                                onChanged: (value) =>
                                    setState(() => _view = value),
                              ),
                            ),
                            SizedBox(
                              height:
                                  selected != null && _view == ScheduleView.day
                                  ? AppSpacing.sm
                                  : AppSpacing.lg,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (selected != null && _view == ScheduleView.day)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ScheduleDayStripHeader(
                          strip: strip,
                          height: strip.extent(context),
                          background: context.colors.canvas,
                        ),
                      ),
                  ],
                  body: selected != null
                      ? ScheduleViewTransition(
                          fill: true,
                          child: ScheduleDatePager(
                            key: ValueKey(_view),
                            day: _day,
                            anchor: widget.now ?? DateTime.now(),
                            view: _view,
                            onDay: (day) {
                              if (_view == view) _selectDay(day);
                            },
                            builder: page,
                          ),
                        )
                      : CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                AppSpacing.screen,
                                0,
                                AppSpacing.screen,
                                ninjaBottomInset(context) + AppSpacing.lg,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: state.status == ScheduleStatus.loading
                                    ? const AppSkeletonGroup(
                                        child: Column(
                                          children: [
                                            AppSkeletonRow(),
                                            SizedBox(height: AppSpacing.sm),
                                            AppSkeletonRow(),
                                            SizedBox(height: AppSpacing.sm),
                                            AppSkeletonRow(),
                                          ],
                                        ),
                                      )
                                    : state.status == ScheduleStatus.failure
                                    ? AppErrorState(
                                        title: l10n.scheduleLoadingError,
                                        message: l10n.scheduleLoadError,
                                        primaryLabel: l10n.retry,
                                        footnote: null,
                                        onPrimary: _refresh,
                                      )
                                    : AppEmptyState(
                                        title: l10n.scheduleNotSelected,
                                        subtitle: l10n.scheduleHubEmptySubtitle,
                                        actionLabel: l10n.addSchedule,
                                        onAction: () =>
                                            const ScheduleManagementRoute()
                                                .push<void>(context),
                                      ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.screen,
              bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: NinjaMotion.of(context, NinjaMotion.fast),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        alignment: Alignment.bottomRight,
                        child: child,
                      ),
                    ),
                    child: showToday
                        ? Padding(
                            key: const ValueKey('schedule-today-visible'),
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: AppFab.extended(
                              key: const ValueKey('schedule-today-button'),
                              icon: AppLineIcon.calendar,
                              label: l10n.today,
                              backgroundColor: context.colors.surface,
                              foregroundColor: context.colors.accent,
                              onPressed: () =>
                                  _selectDay(widget.now ?? DateTime.now()),
                            ),
                          )
                        : const SizedBox.shrink(),
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

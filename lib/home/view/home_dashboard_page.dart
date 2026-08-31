import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/view/dashboard/dashboard.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'package:rtu_mirea_app/home/view/dashboard/dashboard.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  List<Deadline> _deadlines = const [];
  bool _loading = true;
  bool _deadlinesError = false;
  final HomeLatestRequest _deadlineRequests = HomeLatestRequest();
  final GlobalKey _searchKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  int _selectedDayIndex = kHomeDayWindowTodayIndex;
  bool _forward = true;
  DateTime _now = DateTime.now();
  Timer? _clockTicker;
  ValueListenable<TickerModeData>? _tickerMode;
  bool _catalogLoadRequested = false;

  late final DiscourseBloc _discourseBloc;

  @override
  void initState() {
    super.initState();
    _discourseBloc = DiscourseBloc(
      context.read(),
    )..add(const DiscourseTopTopicsRequested());
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    TabReselectNotifier.instance.addListener(_onTabReselect);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_catalogLoadRequested) {
      _catalogLoadRequested = true;
      unawaited(
        context.read<ServiceCatalogCubit>().load(
          locale: Localizations.localeOf(context).languageCode,
        ),
      );
    }
    final tickerMode = TickerMode.getValuesNotifier(context);
    if (identical(tickerMode, _tickerMode)) return;
    _tickerMode?.removeListener(_syncClockTicker);
    _tickerMode = tickerMode;
    _tickerMode?.addListener(_syncClockTicker);
    _syncClockTicker();
  }

  void _syncClockTicker() {
    _clockTicker?.cancel();
    _clockTicker = null;
    if (_tickerMode?.value.enabled != true) return;
    _now = DateTime.now();
    _clockTicker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  void _onTabReselect() {
    if (TabReselectNotifier.instance.tabIndex != 0) return;
    if (_scrollController.positions.length != 1) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduceMotion) {
      _scrollController.jumpTo(0);
    } else {
      unawaited(
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  @override
  void dispose() {
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _tickerMode?.removeListener(_syncClockTicker);
    _clockTicker?.cancel();
    unawaited(_discourseBloc.close());
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final revision = _deadlineRequests.begin();
    final schedule = context.read<ScheduleRepository>();
    var deadlinesFailed = false;
    final deadlines = await schedule
        .getDeadlines()
        .timeout(const Duration(seconds: 15))
        .catchError((_) {
          deadlinesFailed = true;
          return _deadlines;
        });
    if (!mounted || !_deadlineRequests.accepts(revision)) return;
    setState(() {
      _deadlines = deadlines;
      _deadlinesError = deadlinesFailed;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    final bloc = context.read<ScheduleBloc>();
    final scheduleRefresh =
        homeWaitsForScheduleRefresh(
          bloc.state.selectedSchedule,
        )
        ? _waitForScheduleRefresh(bloc)
        : Future<void>.value();
    final discourseRefresh = _waitForDiscourseRefresh();
    bloc.add(
      const SelectedScheduleRefreshRequested(manual: true),
    );
    _discourseBloc.add(const DiscourseTopTopicsRequested());
    await Future.wait([_load(), scheduleRefresh, discourseRefresh]);
  }

  Future<void> _waitForDiscourseRefresh() async {
    await _discourseBloc.stream
        .firstWhere(
          (state) =>
              state.status == DiscourseStatus.loaded ||
              state.status == DiscourseStatus.failure,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => _discourseBloc.state,
        );
  }

  Future<void> _waitForScheduleRefresh(ScheduleBloc bloc) async {
    await bloc.stream
        .firstWhere(
          (state) => state.status == .loaded || state.status == .failure,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => bloc.state,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final universityConfig = context.read<UniversityConfig>();
    final locale = Localizations.localeOf(context).languageCode;
    final user = context.select<AppBloc, AppState>((bloc) => bloc.state).user;
    final userName = user.name ?? l10n.homeStudent;
    final firstName = (user.name ?? '')
        .trim()
        .split(' ')
        .firstWhere((part) => part.isNotEmpty, orElse: () => l10n.homeNinja);

    final scheduleState = context.select<ScheduleBloc, ScheduleState>(
      (bloc) => bloc.state,
    );
    final scheduleStatus = scheduleState.status;
    final scheduleLoading =
        scheduleStatus == .initial || scheduleStatus == .loading;
    final scheduleFailed =
        scheduleStatus == .failure && scheduleState.selectedSchedule == null;

    final now = _now;
    final days = homeDayWindow(now);
    final lessonsByDay = [
      for (final day in days) _lessonsForDay(scheduleState, day),
    ];
    final selectedDay =
        days.elementAtOrNull(_selectedDayIndex) ??
        DateTime(now.year, now.month, now.day);
    final lessons =
        lessonsByDay.elementAtOrNull(_selectedDayIndex) ??
        const <LessonSchedulePart>[];
    final dayStatus = homeDayStatus(
      day: selectedDay,
      lessons: lessons,
      now: now,
    );

    final activeDeadlines = _deadlines.where((d) => !d.isDone).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final showSearchCoach = !context
        .select<HomeCubit, HomeState>((cubit) => cubit.state)
        .searchCoachShown;

    final homePrefs = context.watch<UiPreferencesCubit>().state;
    final serviceCatalog = context.watch<ServiceCatalogCubit>().state.catalog;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final headerLoading = homeHeaderShowsLoading(
      deadlinesLoading: _loading,
      scheduleLoading: scheduleLoading,
    );

    return BlocProvider.value(
      value: _discourseBloc,
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: colors.brand,
                backgroundColor: colors.surface,
                onRefresh: _refresh,
                child: NinjaSkeletonGroup(
                  pulse: _loading || scheduleLoading,
                  excludeSemantics: false,
                  semanticsLabel: _loading || scheduleLoading
                      ? l10n.loadingContent
                      : null,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      HomeDashboardHeader(
                        day: selectedDay,
                        locale: locale,
                        userName: userName,
                        greeting: l10n.homeGreeting(firstName),
                        loading: headerLoading,
                        searchKey: _searchKey,
                      ),

                      SliverToBoxAdapter(
                        child: HomeTitleBlock(
                          day: selectedDay,
                          locale: locale,
                          status: dayStatus,
                          loading: headerLoading,
                          offline: scheduleState.isOffline,
                        ).animateSectionEntrance(),
                      ),

                      SliverPersistentHeader(
                        pinned: true,
                        delegate: HomeDayRailDelegate(
                          height: textScale >= 1.6 ? 84 : 70,
                          days: days,
                          lessonCounts: [
                            for (final dayLessons in lessonsByDay)
                              dayLessons.length,
                          ],
                          selectedIndex: _selectedDayIndex,
                          onSelected: _selectHomeDay,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: HomeDaySwipeSwitcher(
                          forward: _forward,
                          onStep: _stepHomeDay,
                          child: HomeDayBoard(
                            key: ValueKey(
                              'home-day-${selectedDay.toIso8601String()}',
                            ),
                            day: selectedDay,
                            lessons: lessons,
                            now: now,
                            loading: scheduleLoading,
                            failed: scheduleFailed,
                            showTimeline: homePrefs.isSectionEnabled(.today),
                            onRetry: () => unawaited(_refresh()),
                          ),
                        ),
                      ),

                      if (homePrefs.isSectionEnabled(.smartChips))
                        SliverToBoxAdapter(
                          child: HomeServicesSection(
                            config: universityConfig,
                            catalog: serviceCatalog,
                          ).animateSectionEntrance(index: 1),
                        ),

                      if (homePrefs.isSectionEnabled(.deadlines))
                        SliverToBoxAdapter(
                          child: HomeDeadlinesSection(
                            deadlines: activeDeadlines,
                            loading: _loading,
                            failed: _deadlinesError,
                            onReload: () => unawaited(_load()),
                          ).animateSectionEntrance(index: 2),
                        ),

                      if (homePrefs.isSectionEnabled(.trending))
                        SliverToBoxAdapter(
                          child: const HomeTrendingSection()
                              .animateSectionEntrance(index: 3),
                        ),

                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 32 + ninjaBottomInset(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showSearchCoach)
              Positioned.fill(
                child: SearchCoachOverlay(
                  anchorKey: _searchKey,
                  onDismiss: () =>
                      context.read<HomeCubit>().dismissSearchCoach(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _stepHomeDay(HomeDayStep step) {
    final target = homeDayStepTarget(
      selectedIndex: _selectedDayIndex,
      dayCount: kHomeDayWindowLength,
      step: step,
    );
    if (target == null) return;
    _selectHomeDay(target);
  }

  void _selectHomeDay(int index) {
    if (_selectedDayIndex == index) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _forward = index > _selectedDayIndex;
      _selectedDayIndex = index;
    });
  }

  List<LessonSchedulePart> _lessonsForDay(
    ScheduleState state,
    DateTime day,
  ) {
    final schedule =
        state.selectedSchedule?.schedule
            .whereType<LessonSchedulePart>()
            .toList() ??
        const <LessonSchedulePart>[];
    final lessons =
        schedule
            .where(
              (l) => l.dates.any(
                (d) =>
                    d.year == day.year &&
                    d.month == day.month &&
                    d.day == day.day,
              ),
            )
            .toList()
          ..sort(
            (a, b) => a.lessonBells.startTime
                .toDateTime(day)
                .compareTo(b.lessonBells.startTime.toDateTime(day)),
          );
    return lessons;
  }
}

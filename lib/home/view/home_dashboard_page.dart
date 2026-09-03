import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_gamification_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_identity_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_stories_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_content.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_metrics.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final GlobalKey _searchKey = GlobalKey();
  late final DeadlinesCubit _deadlines;
  late final DiscourseBloc _discourse;
  late final HomeGamificationCubit _gamification;
  late final HomeIdentityCubit _identity;
  final HomeStoriesCubit _stories = HomeStoriesCubit();
  DateTime _now = DateTime.now();
  late DateTime _selectedDay = DateUtils.dateOnly(_now);
  Timer? _clock;
  StreamSubscription<ScheduleState>? _scheduleSubscription;
  ValueListenable<TickerModeData>? _tickerMode;
  bool _catalogRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    TabReselectNotifier.instance.addListener(_onTabReselect);
    _deadlines = DeadlinesCubit(repository: context.read());
    _discourse = DiscourseBloc(context.read())
      ..add(const DiscourseTopTopicsRequested());
    _gamification = HomeGamificationCubit(context.read());
    _identity = HomeIdentityCubit(
      context.read(),
      context.read<UniversityConfig>().organizationId,
    );
    unawaited(_deadlines.load());
    unawaited(_gamification.load());
    unawaited(_identity.load());
    unawaited(context.read<ExamReadinessCubit>().load());
    unawaited(_loadChanges());
    _scheduleSubscription = context.read<ScheduleBloc>().stream.listen((_) {
      unawaited(_loadChanges());
    });
  }

  Future<void> _loadChanges({bool force = false}) async {
    final cubit = context.read<ScheduleChangesCubit>();
    final target = homeScheduleTarget(
      context.read<ScheduleBloc>().state.selectedSchedule,
    );
    if (target == null) {
      cubit.clear();
    } else if (force || !cubit.matchesTarget(target.$1, target.$2)) {
      await cubit.load(targetType: target.$1, target: target.$2);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_catalogRequested) {
      _catalogRequested = true;
      unawaited(
        context.read<ServiceCatalogCubit>().load(
          locale: Localizations.localeOf(context).languageCode,
        ),
      );
    }
    final mode = TickerMode.getValuesNotifier(context);
    if (identical(mode, _tickerMode)) return;
    _tickerMode?.removeListener(_syncClock);
    _tickerMode = mode;
    mode.addListener(_syncClock);
    _syncClock();
  }

  void _syncClock() {
    _clock?.cancel();
    _clock = null;
    if (_tickerMode?.value.enabled != true) return;
    setState(_updateClock);
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(_updateClock);
    });
  }

  void _updateClock() {
    final next = DateTime.now();
    if (DateUtils.isSameDay(_selectedDay, _now)) {
      _selectedDay = DateUtils.dateOnly(next);
    }
    _now = next;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncClock();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _clock?.cancel();
      _clock = null;
    }
  }

  void _onTabReselect() {
    if (TabReselectNotifier.instance.tabIndex != 0 ||
        _scrollController.positions.length != 1) {
      return;
    }
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context)) {
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

  Future<void> _refresh() async {
    final schedule = context.read<ScheduleBloc>();
    final waits = <Future<void>>[
      _deadlines.load().then((_) {}),
      _gamification.load(),
      _identity.load(),
      _loadChanges(force: true),
      _discourse.stream
          .firstWhere(
            (state) =>
                state.status == DiscourseStatus.loaded ||
                state.status == DiscourseStatus.failure,
          )
          .then((_) {}),
      if (homeWaitsForScheduleRefresh(schedule.state.selectedSchedule))
        schedule.stream
            .firstWhere(
              (state) =>
                  state.status == ScheduleStatus.loaded ||
                  state.status == ScheduleStatus.failure,
            )
            .then((_) {}),
    ];
    schedule.add(const SelectedScheduleRefreshRequested(manual: true));
    _discourse.add(const DiscourseTopTopicsRequested());
    await Future.wait(
      waits.map(
        (future) => future
            .timeout(const Duration(seconds: 15), onTimeout: () {})
            .catchError((Object _) {}),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _tickerMode?.removeListener(_syncClock);
    _clock?.cancel();
    _scrollController.dispose();
    unawaited(_scheduleSubscription?.cancel());
    unawaited(_deadlines.close());
    unawaited(_discourse.close());
    unawaited(_gamification.close());
    unawaited(_identity.close());
    unawaited(_stories.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _deadlines),
      BlocProvider.value(value: _discourse),
      BlocProvider.value(value: _gamification),
      BlocProvider.value(value: _identity),
      BlocProvider.value(value: _stories),
    ],
    child: Scaffold(
      backgroundColor: context.colors.canvas,
      body: RefreshIndicator(
        color: context.colors.accent,
        backgroundColor: context.colors.surface,
        onRefresh: _refresh,
        child: HomeDashboardContent(
          now: _now,
          selectedDay: _selectedDay,
          scrollController: _scrollController,
          searchKey: _searchKey,
          onRetry: () => unawaited(_refresh()),
          onSelectedDay: (day) =>
              setState(() => _selectedDay = DateUtils.dateOnly(day)),
        ),
      ),
    ),
  );
}

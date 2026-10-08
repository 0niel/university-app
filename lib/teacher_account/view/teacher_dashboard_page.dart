import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/profile/widgets/rows/settings_rows.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_persona_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({this.clock, super.key});

  final DateTime Function()? clock;

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage>
    with WidgetsBindingObserver {
  late DateTime _now;
  late DateTime _day;
  late DateTime _week;
  Teacher? _teacher;
  List<SchedulePart> _schedule = const [];
  List<ScheduleChange> _changes = const [];
  TeacherProfile? _profile;
  (String, DateTime)? _scheduleKey;
  DateTime? _scheduleFetchedAt;
  bool _hasSchedule = false;
  bool _fromCache = false;
  bool _scheduleLoading = false;
  bool _ratingLoading = false;
  bool _scheduleError = false;
  bool _ratingError = false;
  bool _changesError = false;
  bool _openingSchedule = false;
  bool _allGroups = false;
  bool _allRooms = false;
  int _revision = 0;
  int _ratingRevision = 0;
  StreamSubscription<AccountPersonaState>? _accountSubscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = (widget.clock ?? DateTime.now)();
    _day = DateUtils.dateOnly(_now);
    _week = _day.subtract(Duration(days: _day.weekday - 1));
    _teacher = _availableTeacher(context.read<AccountPersonaCubit>().state);
    final teacher = _teacher;
    if (teacher != null) {
      _scheduleLoading = true;
      _ratingLoading = true;
      _scheduleKey = (teacher.uid ?? teacher.name, _week);
      _seedScheduleCache(teacher);
    }
    _accountSubscription = context.read<AccountPersonaCubit>().stream.listen((
      account,
    ) {
      if (!mounted) return;
      final teacher = _availableTeacher(account);
      if (teacher == _teacher) return;
      _revision++;
      _ratingRevision++;
      setState(() {
        _teacher = teacher;
        _schedule = const [];
        _changes = const [];
        _profile = null;
        _scheduleKey = null;
        _scheduleFetchedAt = null;
        _hasSchedule = false;
        _fromCache = false;
        _scheduleLoading = false;
        _ratingLoading = false;
        _allGroups = false;
        _allRooms = false;
      });
      unawaited(_load());
    });
    WidgetsBinding.instance.addObserver(this);
    _startClock();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = (widget.clock ?? DateTime.now)());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _now = (widget.clock ?? DateTime.now)());
      _startClock();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _revision++;
    _ratingRevision++;
    _timer?.cancel();
    unawaited(_accountSubscription?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _isCurrent(int revision) => mounted && revision == _revision;

  Teacher? _availableTeacher(AccountPersonaState account) =>
      account.isTeacher && account.persona.teacherAvailable
      ? account.teacher
      : null;

  void _seedScheduleCache(Teacher teacher) {
    final uid = teacher.uid;
    final state = context.read<ScheduleBloc>().state;
    if (uid == null) return;
    final syncedAt = state.scheduleSyncedAt[uid];
    if (syncedAt == null) return;
    final entries = state.teachersSchedule.where(
      (entry) => entry.$1 == uid && entry.$2.uid == uid,
    );
    if (entries.isEmpty) return;
    _schedule = entries.first.$3;
    _scheduleFetchedAt = syncedAt;
    _hasSchedule = true;
    _fromCache = true;
  }

  Future<void> _load({bool refreshRating = true}) async {
    final teacher = _teacher;
    if (!mounted || teacher == null) return;
    final revision = ++_revision;
    setState(() {
      final key = (teacher.uid ?? teacher.name, _week);
      if (_scheduleKey != key) {
        _scheduleKey = key;
        _schedule = const [];
        _changes = const [];
        _scheduleFetchedAt = null;
        _hasSchedule = false;
        _fromCache = false;
        _seedScheduleCache(teacher);
      }
      _scheduleLoading = true;
      _scheduleError = false;
      _changesError = false;
    });
    await Future.wait([
      _loadSchedule(teacher, revision),
      if (refreshRating) _refreshRating(),
    ]);
  }

  Future<List<ScheduleChange>?> _loadChanges(
    Teacher teacher,
    int revision,
  ) async {
    try {
      return await context.read<ScheduleRepository>().getScheduleChanges(
        targetType: ScheduleTargetType.teacher,
        target: teacher.uid ?? teacher.name,
      );
    } on Exception {
      if (_isCurrent(revision)) setState(() => _changesError = true);
      return null;
    }
  }

  Future<void> _loadSchedule(Teacher teacher, int revision) async {
    final changesFuture = _loadChanges(teacher, revision);
    try {
      final response = await context
          .read<ScheduleRepository>()
          .getTeacherSchedule(
            teacher: teacher.uid ?? teacher.name,
            dateFrom: _week,
            dateTo: _week.add(const Duration(days: 6)),
          );
      final changes = await changesFuture;
      if (!_isCurrent(revision)) return;
      setState(() {
        _schedule = response.data;
        _changes = changes ?? _changes;
        _hasSchedule = true;
        _fromCache = false;
        _scheduleFetchedAt = (widget.clock ?? DateTime.now)();
        _scheduleLoading = false;
      });
    } on Exception {
      if (!_isCurrent(revision)) return;
      setState(() {
        _scheduleLoading = false;
        _scheduleError = true;
        _fromCache = _hasSchedule;
      });
    }
  }

  Future<void> _refreshRating() async {
    final teacher = _teacher;
    if (!mounted || teacher == null) return;
    final revision = ++_ratingRevision;
    setState(() {
      _ratingLoading = true;
      _ratingError = false;
    });
    await _loadRating(teacher, revision);
  }

  Future<void> _loadRating(Teacher teacher, int revision) async {
    try {
      final profile = await context.read<CampusRepository>().getTeacherProfile(
        teacher.name,
      );
      if (!mounted || revision != _ratingRevision) return;
      setState(() {
        _profile = profile;
        _ratingLoading = false;
      });
    } on Exception {
      if (!mounted || revision != _ratingRevision) return;
      setState(() {
        _ratingLoading = false;
        _ratingError = true;
      });
    }
  }

  Future<void> _openSchedule({
    String path = '/schedule',
    bool export = false,
  }) async {
    final teacher = _teacher;
    if (teacher == null || _openingSchedule) return;
    final revision = _revision;
    final bloc = context.read<ScheduleBloc>();
    StreamSubscription<ScheduleState>? subscription;
    bool matches(ScheduleState state) {
      final selected = state.selectedSchedule;
      return selected is SelectedTeacherSchedule &&
          selected.teacher.uid == teacher.uid;
    }

    setState(() => _openingSchedule = true);
    try {
      if (!matches(bloc.state) ||
          (export && bloc.state.status != ScheduleStatus.loaded)) {
        final selected = Completer<ScheduleState>();
        subscription = bloc.stream.listen((state) {
          if (selected.isCompleted || !matches(state)) return;
          if (!export ||
              state.status == ScheduleStatus.loaded ||
              state.status == ScheduleStatus.failure) {
            selected.complete(state);
          }
        });
        if (matches(bloc.state)) {
          bloc.add(const SelectedScheduleRefreshRequested(manual: true));
        } else {
          bloc.add(TeacherScheduleRequested(teacher: teacher));
        }
        final state = await selected.future.timeout(
          Duration(seconds: export ? 30 : 5),
        );
        if (export && state.status == ScheduleStatus.failure) {
          throw Exception('Teacher schedule unavailable');
        }
      }
      if (!mounted || !_isCurrent(revision)) return;
      if (export) {
        await showScheduleExportSheet(context);
      } else {
        context.go(path);
      }
    } on Exception {
      if (mounted && _isCurrent(revision)) {
        ToastManager.showError(
          context,
          message: context.l10n.scheduleLoadingError,
        );
      }
    } finally {
      await subscription?.cancel();
      if (mounted) setState(() => _openingSchedule = false);
    }
  }

  void _changeWeek(int delta) {
    setState(() {
      _week = _week.add(Duration(days: delta * 7));
      _day = _day.add(Duration(days: delta * 7));
      _allGroups = false;
      _allRooms = false;
    });
    unawaited(_load(refreshRating: false));
  }

  void _today() {
    final day = DateUtils.dateOnly((widget.clock ?? DateTime.now)());
    final week = day.subtract(Duration(days: day.weekday - 1));
    final changed = week != _week;
    setState(() {
      _day = day;
      _week = week;
    });
    if (changed) unawaited(_load(refreshRating: false));
  }

  void _openLesson(TeacherLessonOccurrence occurrence) => unawaited(
    ScheduleDetailsRoute(
      $extra: (occurrence.lesson, occurrence.date),
      teacherId: _teacher?.uid,
      teacherName: _teacher?.name,
    ).push<void>(context),
  );

  String _duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return [
      if (hours > 0) context.l10n.homeHoursShort(hours),
      if (minutes > 0 || hours == 0) context.l10n.minutesShort(minutes),
    ].join(' ');
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountPersonaCubit>().state;
    final l10n = context.l10n;
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.4;
    final teacher = _availableTeacher(account);
    final unavailable = account.isTeacher && account.persona.teacherId != null;
    final restoring = !account.loaded && account.loading && teacher == null;
    final content = restoring
        ? [
            AppSkeletonGroup(
              semanticsLabel: l10n.loadingContent,
              child: const AppSkeleton(height: 220, radius: AppRadius.card),
            ),
          ]
        : teacher == null
        ? [
            AppEmptyState(
              lineIcon: AppLineIcon.user,
              title: unavailable
                  ? l10n.teacherUnavailableTitle
                  : l10n.teacherChooseTitle,
              subtitle: unavailable
                  ? l10n.teacherUnavailableDescription
                  : l10n.teacherChooseDescription,
              actionLabel: l10n.teacherChooseTitle,
              onAction: () => unawaited(
                showAccountPersonaSheet(
                  context,
                  initialRole: AccountRole.teacher,
                ),
              ),
            ),
          ]
        : _content(teacher);
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: ninjaBottomInset(context) + AppSpacing.lg,
          ),
          children: [
            if (largeText)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.screenTop + MediaQuery.paddingOf(context).top,
                  AppSpacing.screen,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppIconButton(
                        icon: const AppLineIconWidget(AppLineIcon.chevronL),
                        tooltip: l10n.back,
                        onPressed: _back,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.teacherCabinetTitle,
                        style: AppText.section.copyWith(
                          color: context.colors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              AppInnerHeader(
                title: l10n.teacherCabinetTitle,
                backSemanticsLabel: l10n.back,
                onBack: _back,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (account.syncError) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppBanner(
                      message: l10n.accountPersonaSyncError,
                      tone: AppBannerTone.warn,
                      actionLabel: l10n.retry,
                      onAction: () => unawaited(
                        context.read<AccountPersonaCubit>().retry(),
                      ),
                    ),
                  ],
                  ...content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(Teacher teacher) {
    final l10n = context.l10n;
    final colors = context.colors;
    final compactIdentity =
        MediaQuery.sizeOf(context).width < 360 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.4 ||
        teacher.name.length > 45;
    final nameStyle = teacher.name.length > 45 && compactIdentity
        ? AppText.sans(17, FontWeight.w700)
        : compactIdentity
        ? AppText.title
        : AppText.serif(28, height: 1.2);
    final workload = TeacherWorkload.fromSchedule(
      schedule: _schedule,
      weekStart: _week,
      changes: _changes,
    );
    final current = workload.currentAt(_now);
    final next = current ?? workload.nextAt(_now);
    final groups = workload.groups;
    final rooms = workload.classrooms;
    final mapEnabled = context.read<UniversityConfig>().isEnabled(.campusMap);
    final dateFormat = DateFormat.MMMd(l10n.localeName);
    final savedDate = _scheduleFetchedAt;
    final savedTime = savedDate == null
        ? null
        : '${dateFormat.format(savedDate)} '
              '${DateFormat.Hm(l10n.localeName).format(savedDate)}';
    final weekEnd = _week.add(const Duration(days: 6));
    final lessonCount = workload.occurrences
        .where((entry) => !entry.isCancelled)
        .length;
    return [
      const SizedBox(height: AppSpacing.lg),
      Text(
        teacher.name.length > 45 && compactIdentity
            ? teacher.name.replaceAll('-', '-\n')
            : teacher.name,
        key: const ValueKey('teacher-dashboard-name'),
        semanticsLabel: teacher.name,
        style: nameStyle.copyWith(color: colors.ink),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        l10n.teacherCabinetSubtitle,
        style: AppText.body.copyWith(color: colors.muted),
      ),
      const SizedBox(height: AppSpacing.md),
      AppButton.text(
        label: l10n.teacherChange,
        expanded: true,
        padding: EdgeInsets.zero,
        textStyle: AppText.subtextStrong,
        onPressed: () => unawaited(showAccountPersonaSheet(context)),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppButton.primary(
        label: l10n.teacherOwnSchedule,
        expanded: true,
        loading: _openingSchedule,
        onPressed: _openingSchedule ? null : () => unawaited(_openSchedule()),
      ),
      AppOverline(l10n.teacherWeekWorkload),
      Row(
        children: [
          IconButton(
            tooltip: l10n.teacherPreviousWeek,
            onPressed: () => _changeWeek(-1),
            icon: const AppLineIconWidget(AppLineIcon.chevronL),
          ),
          Expanded(
            child: Text(
              '${dateFormat.format(_week)} – ${dateFormat.format(weekEnd)}',
              textAlign: TextAlign.center,
              style: AppText.headlineStrong.copyWith(color: colors.ink),
            ),
          ),
          IconButton(
            tooltip: l10n.teacherNextWeek,
            onPressed: () => _changeWeek(1),
            icon: const AppLineIconWidget(AppLineIcon.chevronR),
          ),
        ],
      ),
      Align(
        child: AppButton.text(label: l10n.today, onPressed: _today),
      ),
      if (_scheduleLoading && !_hasSchedule)
        AppSkeletonGroup(
          semanticsLabel: l10n.loadingContent,
          child: const AppSkeleton(height: 160, radius: AppRadius.card),
        )
      else if (_scheduleError && !_hasSchedule)
        AppErrorState(
          title: l10n.scheduleLoadingError,
          message: l10n.tryAgain,
          primaryLabel: l10n.retry,
          footnote: null,
          onPrimary: () => unawaited(_load(refreshRating: false)),
        )
      else ...[
        if (_scheduleLoading) ...[
          LinearProgressIndicator(
            color: colors.accent,
            backgroundColor: colors.line,
            minHeight: 2,
            semanticsLabel: l10n.loadingContent,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (_scheduleError) ...[
          AppBanner(
            key: const ValueKey('teacher-schedule-refresh-error'),
            message: l10n.teacherScheduleRefreshError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: () => unawaited(_load(refreshRating: false)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (savedTime != null) ...[
          Text(
            [
              if (_fromCache) l10n.teacherScheduleSaved,
              l10n.updatedAtTime(savedTime),
            ].join(' · '),
            key: const ValueKey('teacher-schedule-freshness'),
            style: AppText.caption.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (_changesError) ...[
          AppBanner(
            message: l10n.teacherChangesLoadError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: () => unawaited(_load(refreshRating: false)),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _TeacherMetrics(
          metrics: [
            (
              l10n.teacherLessonCount,
              '$lessonCount',
            ),
            (l10n.teacherTeachingTime, _duration(workload.totalDuration)),
            (
              l10n.teacherWindowTime,
              _duration(
                workload.gaps.fold(
                  Duration.zero,
                  (sum, gap) => sum + gap.duration,
                ),
              ),
            ),
            (l10n.teacherGroups, '${groups.length}'),
          ],
        ),
        if (workload.occurrences.isEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.teacherWeekNoLessons,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ],
        if (next != null && !DateUtils.isSameDay(next.date, _day)) ...[
          AppOverline(
            current != null
                ? l10n.teacherCurrentLesson
                : l10n.teacherNextLesson,
          ),
          _TeacherLessonTile(
            occurrence: next,
            showDate: true,
            onTap: () => _openLesson(next),
          ),
        ],
        AppOverline(DateFormat.MMMMEEEEd(l10n.localeName).format(_day)),
        _TeacherWeekDays(
          week: _week,
          day: _day,
          onSelect: (day) => setState(() => _day = day),
        ),
        const SizedBox(height: AppSpacing.md),
        if (workload.occurrencesForDay(_day).isEmpty)
          AppEmptyState(
            title: l10n.teacherNoLessons,
            subtitle: l10n.teacherNoLessonsDescription,
            lineIcon: AppLineIcon.calendar,
          )
        else
          AppListGroup(
            children: [
              for (final occurrence in workload.occurrencesForDay(_day))
                _TeacherLessonTile(
                  occurrence: occurrence,
                  status: occurrence == next
                      ? current != null
                            ? l10n.teacherCurrentLesson
                            : l10n.teacherNextLesson
                      : null,
                  onTap: () => _openLesson(occurrence),
                ),
            ],
          ),
        if (groups.isNotEmpty) ...[
          AppOverline(l10n.teacherGroups),
          AppListGroup(
            children: [
              for (final group in _allGroups ? groups : groups.take(8))
                ProfileLinkRow(
                  icon: AppLineIcon.people,
                  title: group.name,
                  onTap: () => unawaited(
                    GlobalSearchRoute(query: group.name).push<void>(context),
                  ),
                ),
            ],
          ),
          if (!_allGroups && groups.length > 8)
            AppButton.text(
              label: l10n.all,
              expanded: true,
              onPressed: () => setState(() => _allGroups = true),
            ),
        ],
        if (rooms.isNotEmpty) ...[
          AppOverline(l10n.teacherRooms),
          AppListGroup(
            children: [
              for (final room in _allRooms ? rooms : rooms.take(8))
                ProfileLinkRow(
                  icon: room.isOnline ? AppLineIcon.link : AppLineIcon.door,
                  title: classroomLabel(room),
                  onTap: () => unawaited(
                    GlobalSearchRoute(query: room.name).push<void>(context),
                  ),
                ),
            ],
          ),
          if (!_allRooms && rooms.length > 8)
            AppButton.text(
              label: l10n.all,
              expanded: true,
              onPressed: () => setState(() => _allRooms = true),
            ),
        ],
      ],
      AppOverline(l10n.teacherOwnRating),
      if (_ratingLoading && _profile == null)
        AppSkeletonGroup(
          semanticsLabel: l10n.loadingContent,
          child: const AppSkeleton(height: 180, radius: AppRadius.card),
        )
      else if (_ratingError && _profile == null)
        AppErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          footnote: null,
          primaryLabel: l10n.retry,
          onPrimary: () => unawaited(_refreshRating()),
        )
      else ...[
        if (_ratingLoading) ...[
          LinearProgressIndicator(
            color: colors.accent,
            backgroundColor: colors.line,
            minHeight: 2,
            semanticsLabel: l10n.loadingContent,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (_ratingError) ...[
          AppBanner(
            key: const ValueKey('teacher-rating-refresh-error'),
            message: l10n.teacherRatingRefreshError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: () => unawaited(_refreshRating()),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _TeacherRatingCard(
          profile: _profile,
          formatRating: _rating,
          onReviews: () => unawaited(
            showTeacherProfileSheet(context, teacher: teacher, readOnly: true),
          ),
        ),
      ],
      AppOverline(l10n.services),
      AppListGroup(
        children: [
          ProfileLinkRow(
            icon: AppLineIcon.bell,
            title: l10n.scheduleChanges,
            onTap: _openingSchedule
                ? null
                : () => unawaited(_openSchedule(path: '/schedule/changes')),
          ),
          ProfileLinkRow(
            icon: AppLineIcon.calendar,
            title: l10n.settingsExportCalendar,
            onTap: _openingSchedule
                ? null
                : () => unawaited(_openSchedule(export: true)),
          ),
          ProfileLinkRow(
            icon: AppLineIcon.door,
            title: l10n.freeClassrooms,
            onTap: () => unawaited(context.push<void>('/services/free-rooms')),
          ),
          if (mapEnabled)
            ProfileLinkRow(
              icon: AppLineIcon.map,
              title: l10n.campusMap,
              onTap: () => context.go('/services/map'),
            ),
          ProfileLinkRow(
            icon: AppLineIcon.pencil,
            title: l10n.servicesNotes,
            onTap: () =>
                unawaited(context.push<void>('/services/collab-notes')),
          ),
        ],
      ),
    ];
  }

  String _rating(double? value) => value == null
      ? '—'
      : NumberFormat('0.0', context.l10n.localeName).format(value);
}

class _TeacherWeekDays extends StatelessWidget {
  const _TeacherWeekDays({
    required this.week,
    required this.day,
    required this.onSelect,
  });

  final DateTime week;
  final DateTime day;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final l10n = context.l10n;
      final colors = context.colors;
      final columns =
          constraints.maxWidth >= 332 &&
              MediaQuery.textScalerOf(context).scale(1) <= 1.3
          ? 7
          : 4;
      final width =
          (constraints.maxWidth - (columns - 1) * AppSpacing.xs) / columns;
      return Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (var index = 0; index < 7; index++)
            Builder(
              builder: (context) {
                final date = week.add(Duration(days: index));
                final selected = DateUtils.isSameDay(day, date);
                final foreground = selected ? colors.onAccent : colors.ink;
                return AppPressable(
                  key: ValueKey('teacher-day-${date.toIso8601String()}'),
                  semanticsLabel: DateFormat.MMMMEEEEd(
                    l10n.localeName,
                  ).format(date),
                  semanticsSelected: selected,
                  semanticsButton: true,
                  onTap: () => onSelect(date),
                  child: Container(
                    width: width,
                    constraints: const BoxConstraints(minHeight: 52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? colors.accent : colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      border: Border.all(
                        color: selected ? colors.accent : colors.line,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.E(l10n.localeName).format(date),
                          style: AppText.caption.copyWith(color: foreground),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${date.day}',
                          style: AppText.label.copyWith(color: foreground),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      );
    },
  );
}

class _TeacherRatingCard extends StatelessWidget {
  const _TeacherRatingCard({
    required this.profile,
    required this.formatRating,
    required this.onReviews,
  });

  final TeacherProfile? profile;
  final String Function(double?) formatRating;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final criteria = [
      (l10n.teacherProfileClarity, profile?.clarity),
      (l10n.teacherProfileLoyalty, profile?.loyalty),
      (l10n.teacherProfileUsefulness, profile?.usefulness),
    ];
    return AppCard(
      key: const ValueKey('teacher-rating-summary'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatRating(profile?.overall),
                style: AppText.serif(36).copyWith(color: colors.ink),
              ),
              Text(
                '${l10n.scheduleTeacherReviews}: ${profile?.reviewsCount ?? 0}',
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final criterion in criteria) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    criterion.$1,
                    style: AppText.body.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  formatRating(criterion.$2),
                  style: AppText.bodyBold.copyWith(color: colors.ink),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            profile?.overall == null
                ? l10n.teacherNoRating
                : l10n.teacherRatingDescription,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            label: l10n.teacherOwnReviews,
            expanded: true,
            onPressed: onReviews,
          ),
        ],
      ),
    );
  }
}

class _TeacherMetrics extends StatelessWidget {
  const _TeacherMetrics({required this.metrics});

  final List<(String, String)> metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide =
          constraints.maxWidth >= 288 &&
          MediaQuery.textScalerOf(context).scale(1) <= 1.4;
      final width = wide
          ? (constraints.maxWidth - AppSpacing.sm) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final metric in metrics)
            AppCard(
              width: width,
              semanticsLabel: '${metric.$1}: ${metric.$2}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    metric.$2,
                    style: AppText.metric.copyWith(color: context.colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    metric.$1,
                    style: AppText.subtext.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    },
  );
}

class _TeacherLessonTile extends StatelessWidget {
  const _TeacherLessonTile({
    required this.occurrence,
    required this.onTap,
    this.showDate = false,
    this.status,
  });

  final TeacherLessonOccurrence occurrence;
  final VoidCallback onTap;
  final bool showDate;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final time =
        '${DateFormat.Hm().format(occurrence.start)}–'
        '${DateFormat.Hm().format(occurrence.end)}';
    final meta = [
      if (showDate) DateFormat.MMMEd(l10n.localeName).format(occurrence.date),
      time,
      lessonTypeName(l10n, occurrence.lesson.lessonType),
      if (occurrence.groups.isNotEmpty)
        occurrence.groups.map((group) => group.name).join(', '),
      if (occurrence.lesson.classrooms.isNotEmpty)
        occurrence.lesson.classrooms.map(classroomLabel).join(', '),
      if (occurrence.isCancelled) l10n.lessonMetaCancelled,
    ].join(' · ');
    return AppCard(
      key: ValueKey((occurrence.start, occurrence.lesson)),
      semanticsLabel: [
        status,
        occurrence.lesson.subject,
        meta,
      ].whereType<String>().join(', '),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (status != null)
            AppOverline(
              status!,
              topPadding: 0,
              bottomPadding: AppSpacing.sm,
              color: colors.accent,
            ),
          Text(
            occurrence.lesson.subject,
            style: AppText.headlineStrong.copyWith(
              color: occurrence.isCancelled ? colors.muted : colors.ink,
              decoration: occurrence.isCancelled
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            meta,
            style: AppText.subtext.copyWith(
              color: occurrence.isCancelled ? colors.danger : colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

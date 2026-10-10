import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_dashboard_repository.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_schedule_activator.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_dashboard_binding.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_query.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Repository extends Mock implements TeacherDashboardRepository {}

class _Activator extends Mock implements TeacherScheduleActivator {}

class _Schedule extends Mock implements ScheduleBloc {}

const _teacher = Teacher(uid: 'teacher-a', name: 'Иванов Иван Иванович');
const _otherTeacher = Teacher(uid: 'teacher-b', name: 'Петров Пётр Петрович');
final _now = DateTime(2026, 10, 8, 10);
final _monday = DateTime(2026, 10, 5);

AccountPersonaState _account(Teacher teacher) => AccountPersonaState(
  persona: AccountPersona(
    role: AccountRole.teacher,
    teacherId: teacher.uid,
    teacherName: teacher.name,
    teacherAvailable: true,
  ),
  loaded: true,
);

TeacherScheduleSnapshot _snapshot(
  String subject, {
  DateTime? week,
  TeacherScheduleSource source = TeacherScheduleSource.network,
  DateTime? fetchedAt,
}) => TeacherScheduleSnapshot(
  schedule: [
    LessonSchedulePart(
      uid: 'lesson-$subject',
      subject: subject,
      lessonType: LessonType.lecture,
      teachers: const [_teacher],
      classrooms: const [Classroom(name: 'А-101')],
      groups: const ['ГРУППА-01'],
      dates: [(week ?? _monday).add(const Duration(days: 3))],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      ),
    ),
  ],
  fetchedAt: fetchedAt ?? _now,
  source: source,
);

TeacherProfile _rating(Teacher teacher, double value) => TeacherProfile(
  teacherName: teacher.name,
  clarity: value,
  loyalty: value,
  usefulness: value,
  reviewsCount: value.toInt(),
);

Future<void> _drain() async {
  for (var index = 0; index < 4; index++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _Repository repository;
  late _Activator activator;
  late StreamController<AccountPersonaState> accounts;
  late DateTime clock;

  setUpAll(() {
    registerFallbackValue(
      TeacherScheduleQuery(teacher: _teacher, week: _monday),
    );
    registerFallbackValue(_teacher);
    registerFallbackValue(TeacherScheduleDestination.schedule);
    registerFallbackValue(const SelectedScheduleRefreshRequested());
  });

  setUp(() {
    clock = _now;
    repository = _Repository();
    activator = _Activator();
    accounts = StreamController<AccountPersonaState>.broadcast();
    when(() => repository.cachedSchedule(any())).thenReturn(null);
    when(() => repository.loadSchedule(any())).thenAnswer((call) async {
      final query = call.positionalArguments.single as TeacherScheduleQuery;
      return _snapshot('Initial', week: query.week);
    });
    when(() => repository.loadChanges(any())).thenAnswer((_) async => []);
    when(() => repository.loadRating(any())).thenAnswer((call) async {
      final teacher = call.positionalArguments.single as Teacher;
      return _rating(teacher, teacher == _teacher ? 4 : 5);
    });
    when(() => activator.activate(any(), any())).thenAnswer(
      (_) => const Stream.empty(),
    );
    addTearDown(accounts.close);
  });

  TeacherDashboardBloc create({TeacherScheduleActivator? scheduleActivator}) {
    final bloc = TeacherDashboardBloc(
      repository: repository,
      activator: scheduleActivator ?? activator,
      account: _account(_teacher),
      accountChanges: accounts.stream,
      clock: () => clock,
    );
    addTearDown(() async {
      if (!bloc.isClosed) await bloc.close();
    });
    return bloc;
  }

  test('reverse week completion retains only the selected week', () async {
    final initial = Completer<TeacherScheduleSnapshot>();
    final next = Completer<TeacherScheduleSnapshot>();
    final nextWeek = _monday.add(const Duration(days: 7));
    when(() => repository.loadSchedule(any())).thenAnswer((call) {
      final query = call.positionalArguments.single as TeacherScheduleQuery;
      return query.week == _monday ? initial.future : next.future;
    });
    final bloc = create();
    await _drain();
    bloc.add(const TeacherDashboardEvent.weekChanged(1));
    await _drain();
    next.complete(_snapshot('Selected week', week: nextWeek));
    await _drain();
    initial.complete(_snapshot('Late old week'));
    await _drain();

    expect(bloc.state.week, nextWeek);
    expect(
      bloc.state.schedule.data?.schedule
          .whereType<LessonSchedulePart>()
          .single
          .subject,
      'Selected week',
    );
    expect(bloc.state.workload.subjects, ['Selected week']);
    expect(bloc.state.schedule.hasError, isFalse);
    verify(() => repository.loadRating(_teacher)).called(1);
  });

  for (final lateFailure in [false, true]) {
    test(
      'latest refresh wins over late ${lateFailure ? 'errors' : 'responses'}',
      () async {
        final bloc = create();
        await _drain();
        final firstSchedule = Completer<TeacherScheduleSnapshot>();
        final lastSchedule = Completer<TeacherScheduleSnapshot>();
        final firstRating = Completer<TeacherProfile>();
        final lastRating = Completer<TeacherProfile>();
        final schedules = [firstSchedule, lastSchedule];
        final ratings = [firstRating, lastRating];
        when(() => repository.loadSchedule(any())).thenAnswer(
          (_) => schedules.removeAt(0).future,
        );
        when(() => repository.loadRating(any())).thenAnswer(
          (_) => ratings.removeAt(0).future,
        );
        bloc.add(const TeacherDashboardEvent.refreshRequested());
        await _drain();
        bloc.add(const TeacherDashboardEvent.refreshRequested());
        await _drain();
        lastSchedule.complete(_snapshot('Newest'));
        lastRating.complete(_rating(_teacher, 5));
        await _drain();
        if (lateFailure) {
          firstSchedule.completeError(Exception('late schedule error'));
          firstRating.completeError(Exception('late rating error'));
        } else {
          firstSchedule.complete(_snapshot('Outdated'));
          firstRating.complete(_rating(_teacher, 1));
        }
        await _drain();

        expect(
          bloc.state.schedule.data?.schedule
              .whereType<LessonSchedulePart>()
              .single
              .subject,
          'Newest',
        );
        expect(bloc.state.rating.data?.overall, 5);
        expect(bloc.state.rating.data?.reviewsCount, 5);
        expect(bloc.state.schedule.hasError, isFalse);
        expect(bloc.state.rating.hasError, isFalse);
        expect(bloc.state.schedule.isLoading, isFalse);
        expect(bloc.state.rating.isLoading, isFalse);
      },
    );
  }

  test('late changes error cannot mark a new teacher as failed', () async {
    final oldChanges = Completer<List<ScheduleChange>>();
    when(() => repository.loadChanges(any())).thenAnswer((call) {
      final query = call.positionalArguments.single as TeacherScheduleQuery;
      return query.teacher == _teacher ? oldChanges.future : Future.value([]);
    });
    final bloc = create();
    await _drain();
    accounts.add(_account(_otherTeacher));
    await _drain();
    oldChanges.completeError(Exception('late old changes'));
    await _drain();

    expect(bloc.state.teacher, _otherTeacher);
    expect(
      bloc.state.changes,
      const TeacherResource<List<ScheduleChange>>.ready([]),
    );
    expect(bloc.state.rating.data?.teacherName, _otherTeacher.name);
    expect(bloc.state.rating.data?.overall, 5);
  });

  test(
    'refresh failures retain timestamped cache and prior cancellations',
    () async {
      final savedAt = _now.subtract(const Duration(days: 1));
      final cached = _snapshot(
        'Cached',
        source: TeacherScheduleSource.cache,
        fetchedAt: savedAt,
      );
      final cancellation = ScheduleChange(
        id: 'cancel',
        kind: .cancel,
        subject: 'Cached',
        lessonDate: _now,
        createdAt: _now,
      );
      when(() => repository.cachedSchedule(any())).thenReturn(cached);
      when(
        () => repository.loadSchedule(any()),
      ).thenThrow(Exception('offline'));
      when(() => repository.loadChanges(any())).thenAnswer(
        (_) async => [cancellation],
      );
      final bloc = create();
      await _drain();
      expect(bloc.state.workload.occurrences.single.isCancelled, isTrue);
      when(() => repository.loadChanges(any())).thenThrow(Exception('offline'));
      bloc.add(
        const TeacherDashboardEvent.refreshRequested(
          scope: TeacherDashboardRefreshScope.schedule,
        ),
      );
      await _drain();

      expect(bloc.state.schedule.hasError, isTrue);
      expect(bloc.state.schedule.data, cached);
      expect(bloc.state.schedule.data?.fetchedAt, savedAt);
      expect(bloc.state.schedule.data?.source, TeacherScheduleSource.cache);
      expect(bloc.state.changes.hasError, isTrue);
      expect(bloc.state.changes.data, [cancellation]);
      expect(bloc.state.workload.occurrences.single.isCancelled, isTrue);
      expect(bloc.state.workload.totalDuration, Duration.zero);
      expect(bloc.state.preview, isNull);
      verify(() => repository.loadRating(_teacher)).called(1);
    },
  );

  test('unbinding invalidates pending schedule changes and rating', () async {
    final pendingSchedule = Completer<TeacherScheduleSnapshot>();
    final pendingChanges = Completer<List<ScheduleChange>>();
    final pendingRating = Completer<TeacherProfile>();
    when(() => repository.loadSchedule(any())).thenAnswer(
      (_) => pendingSchedule.future,
    );
    when(() => repository.loadChanges(any())).thenAnswer(
      (_) => pendingChanges.future,
    );
    when(() => repository.loadRating(any())).thenAnswer(
      (_) => pendingRating.future,
    );
    final bloc = create();
    await _drain();
    accounts.add(const AccountPersonaState(loaded: true));
    await _drain();
    pendingSchedule.complete(_snapshot('Old teacher'));
    pendingChanges.completeError(Exception('old changes'));
    pendingRating.complete(_rating(_teacher, 1));
    await _drain();

    expect(bloc.state.binding, const TeacherDashboardBinding.unselected());
    expect(bloc.state.teacher, isNull);
    expect(bloc.state.schedule.data, isNull);
    expect(bloc.state.changes.data, isNull);
    expect(bloc.state.rating.data, isNull);
    expect(bloc.state.workload.occurrences, isEmpty);
    expect(bloc.state.navigation, const TeacherScheduleNavigation.idle());
  });

  test(
    'closing detaches account changes and ignores pending completions',
    () async {
      final pendingSchedule = Completer<TeacherScheduleSnapshot>();
      final pendingChanges = Completer<List<ScheduleChange>>();
      final pendingRating = Completer<TeacherProfile>();
      when(() => repository.loadSchedule(any())).thenAnswer(
        (_) => pendingSchedule.future,
      );
      when(() => repository.loadChanges(any())).thenAnswer(
        (_) => pendingChanges.future,
      );
      when(() => repository.loadRating(any())).thenAnswer(
        (_) => pendingRating.future,
      );
      final bloc = create();
      await _drain();
      await bloc.close().timeout(const Duration(seconds: 1));
      final closedState = bloc.state;
      expect(accounts.hasListener, isFalse);
      accounts.add(_account(_otherTeacher));
      pendingSchedule.complete(_snapshot('After close'));
      pendingChanges.completeError(Exception('after close'));
      pendingRating.complete(_rating(_teacher, 1));
      await _drain();

      expect(bloc.isClosed, isTrue);
      expect(bloc.state, closedState);
    },
  );

  test(
    'rebinding the same teacher rejects old RPCs while new requests wait',
    () async {
      final oldSchedule = Completer<TeacherScheduleSnapshot>();
      final newSchedule = Completer<TeacherScheduleSnapshot>();
      final oldRating = Completer<TeacherProfile>();
      final newRating = Completer<TeacherProfile>();
      final schedules = [oldSchedule, newSchedule];
      final ratings = [oldRating, newRating];
      when(() => repository.loadSchedule(any())).thenAnswer(
        (_) => schedules.removeAt(0).future,
      );
      when(() => repository.loadRating(any())).thenAnswer(
        (_) => ratings.removeAt(0).future,
      );
      final bloc = create();
      await _drain();
      accounts.add(const AccountPersonaState(loaded: true));
      await _drain();
      accounts.add(_account(_teacher));
      await _drain();
      oldSchedule.complete(_snapshot('Old binding'));
      oldRating.complete(_rating(_teacher, 1));
      await _drain();

      expect(bloc.state.teacher, _teacher);
      expect(bloc.state.schedule.isLoading, isTrue);
      expect(bloc.state.rating.isLoading, isTrue);
      expect(bloc.state.schedule.data, isNull);
      expect(bloc.state.rating.data, isNull);
      expect(bloc.state.workload.occurrences, isEmpty);

      newSchedule.complete(_snapshot('New binding'));
      newRating.complete(_rating(_teacher, 5));
      await _drain();
      expect(bloc.state.workload.subjects, ['New binding']);
      expect(bloc.state.rating.data?.overall, 5);
    },
  );

  testWidgets('clock pauses resumes and does not change the selected day', (
    tester,
  ) async {
    final bloc = create();
    await tester.pump();
    bloc.add(TeacherDashboardEvent.daySelected(_monday));
    await tester.pump();
    bloc.add(const TeacherDashboardEvent.activityChanged(active: false));
    await tester.pump();
    clock = _now.add(const Duration(minutes: 5));
    await tester.pump(const Duration(minutes: 2));
    expect(bloc.state.now, _now);
    expect(bloc.state.day, _monday);

    bloc.add(const TeacherDashboardEvent.activityChanged(active: true));
    await tester.pump();
    expect(bloc.state.now, clock);
    clock = clock.add(const Duration(minutes: 1));
    await tester.pump(const Duration(minutes: 1));
    expect(bloc.state.now, clock);
    expect(bloc.state.day, _monday);
    expect(bloc.state.week, _monday);
    unawaited(bloc.close());
    await tester.pump(const Duration(minutes: 3));
    expect(tester.takeException(), isNull);
  });

  test('new navigation cancels the previous activation subscription', () async {
    var cancelled = false;
    final oldActivation = StreamController<ScheduleState>(
      onCancel: () => cancelled = true,
    );
    final newActivation = StreamController<ScheduleState>();
    addTearDown(oldActivation.close);
    addTearDown(newActivation.close);
    when(
      () => activator.activate(_teacher, TeacherScheduleDestination.calendar),
    ).thenAnswer((_) => oldActivation.stream);
    when(
      () => activator.activate(_teacher, TeacherScheduleDestination.changes),
    ).thenAnswer((_) => newActivation.stream);
    final bloc = create();
    await _drain();
    bloc.add(
      const TeacherDashboardEvent.openScheduleRequested(
        TeacherScheduleDestination.calendar,
      ),
    );
    await _drain();
    expect(oldActivation.hasListener, isTrue);
    bloc.add(
      const TeacherDashboardEvent.openScheduleRequested(
        TeacherScheduleDestination.changes,
      ),
    );
    await _drain();
    expect(cancelled, isTrue);
    newActivation.add(const ScheduleState(status: ScheduleStatus.loaded));
    await _drain();
    expect(
      bloc.state.navigation,
      const TeacherScheduleNavigation.ready(TeacherScheduleDestination.changes),
    );
  });

  test(
    'old activation cannot navigate after leaving and returning to a binding',
    () async {
      final activation = StreamController<ScheduleState>();
      addTearDown(activation.close);
      when(() => activator.activate(any(), any())).thenAnswer(
        (_) => activation.stream,
      );
      final bloc = create();
      await _drain();
      bloc.add(
        const TeacherDashboardEvent.openScheduleRequested(
          TeacherScheduleDestination.calendar,
        ),
      );
      await _drain();
      accounts.add(_account(_otherTeacher));
      await _drain();
      accounts.add(_account(_teacher));
      await _drain();
      activation.add(const ScheduleState(status: ScheduleStatus.loaded));
      await _drain();

      expect(bloc.state.teacher, _teacher);
      expect(bloc.state.navigation, const TeacherScheduleNavigation.idle());
    },
  );

  test(
    'week change invalidates an activation even when returning to that week',
    () async {
      final activation = StreamController<ScheduleState>();
      addTearDown(activation.close);
      when(() => activator.activate(any(), any())).thenAnswer(
        (_) => activation.stream,
      );
      final bloc = create();
      await _drain();
      bloc.add(
        const TeacherDashboardEvent.openScheduleRequested(
          TeacherScheduleDestination.schedule,
        ),
      );
      await _drain();
      bloc.add(const TeacherDashboardEvent.weekChanged(1));
      await _drain();
      bloc.add(const TeacherDashboardEvent.weekChanged(-1));
      await _drain();
      activation.add(const ScheduleState(status: ScheduleStatus.loaded));
      await _drain();

      expect(bloc.state.week, _monday);
      expect(bloc.state.navigation, const TeacherScheduleNavigation.idle());
    },
  );

  test(
    'calendar activation ignores other teachers and reports its own failure',
    () async {
      final selected = StreamController<ScheduleState>.broadcast();
      addTearDown(selected.close);
      final schedule = _Schedule();
      when(() => schedule.state).thenReturn(
        const ScheduleState(
          selectedSchedule: SelectedTeacherSchedule(
            teacher: _teacher,
            schedule: [],
          ),
          status: ScheduleStatus.loading,
        ),
      );
      when(() => schedule.stream).thenAnswer((_) => selected.stream);
      when(() => schedule.add(any())).thenAnswer((_) {});
      final bloc = create(
        scheduleActivator: TeacherScheduleActivator(schedule),
      );
      await _drain();
      bloc.add(
        const TeacherDashboardEvent.openScheduleRequested(
          TeacherScheduleDestination.calendar,
        ),
      );
      await _drain();
      selected
        ..add(
          const ScheduleState(
            selectedSchedule: SelectedTeacherSchedule(
              teacher: _otherTeacher,
              schedule: [],
            ),
            status: ScheduleStatus.failure,
          ),
        )
        ..add(
          const ScheduleState(
            selectedSchedule: SelectedTeacherSchedule(
              teacher: _teacher,
              schedule: [],
            ),
            status: ScheduleStatus.loading,
          ),
        );
      await _drain();
      expect(bloc.state.navigation.isBusy, isTrue);
      selected.add(
        const ScheduleState(
          selectedSchedule: SelectedTeacherSchedule(
            teacher: _teacher,
            schedule: [],
          ),
          status: ScheduleStatus.failure,
        ),
      );
      await _drain();

      expect(
        bloc.state.navigation,
        const TeacherScheduleNavigation.failure(
          TeacherScheduleDestination.calendar,
        ),
      );
      verify(
        () =>
            schedule.add(const SelectedScheduleRefreshRequested(manual: true)),
      ).called(1);
      expect(selected.hasListener, isFalse);
    },
  );

  testWidgets('calendar timeout closes activation and ignores late selection', (
    tester,
  ) async {
    final selected = StreamController<ScheduleState>.broadcast();
    addTearDown(selected.close);
    final schedule = _Schedule();
    when(() => schedule.state).thenReturn(const ScheduleState());
    when(() => schedule.stream).thenAnswer((_) => selected.stream);
    when(() => schedule.add(any())).thenAnswer((_) {});
    final bloc = create(scheduleActivator: TeacherScheduleActivator(schedule));
    await tester.pump();
    bloc.add(
      const TeacherDashboardEvent.openScheduleRequested(
        TeacherScheduleDestination.calendar,
      ),
    );
    await tester.pump();
    expect(bloc.state.navigation.isBusy, isTrue);
    await tester.pump(const Duration(seconds: 30));
    expect(
      bloc.state.navigation,
      const TeacherScheduleNavigation.failure(
        TeacherScheduleDestination.calendar,
      ),
    );
    expect(selected.hasListener, isFalse);
    selected.add(
      const ScheduleState(
        selectedSchedule: SelectedTeacherSchedule(
          teacher: _teacher,
          schedule: [],
        ),
        status: ScheduleStatus.loaded,
      ),
    );
    await tester.pump();
    expect(
      bloc.state.navigation,
      const TeacherScheduleNavigation.failure(
        TeacherScheduleDestination.calendar,
      ),
    );
    unawaited(bloc.close());
    await tester.pump(const Duration(minutes: 1));
    expect(tester.takeException(), isNull);
  });
}

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/view/teacher_dashboard_page.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_services_section.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../gallery/gallery_fonts.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

class _Schedules extends Mock implements ScheduleRepository {}

class _Campus extends Mock implements CampusRepository {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  final now = DateTime(2026, 10, 8, 10);
  var clockNow = now;
  final monday = DateTime(2026, 10, 5);
  const teacher = Teacher(uid: 'teacher-id', name: 'Иванов Иван Иванович');
  const accountState = AccountPersonaState(
    persona: AccountPersona(
      role: AccountRole.teacher,
      teacherId: 'teacher-id',
      teacherName: 'Иванов Иван Иванович',
      teacherAvailable: true,
    ),
    loaded: true,
  );
  late _Account account;
  late _Schedules schedules;
  late _Campus campus;
  late _Schedule schedule;
  late StreamController<AccountPersonaState> accountEvents;

  LessonSchedulePart lesson({String subject = 'Математика'}) =>
      LessonSchedulePart(
        uid: 'lesson-$subject',
        subject: subject,
        lessonType: LessonType.lecture,
        teachers: const [teacher],
        classrooms: const [Classroom(name: 'А-101')],
        groups: const ['ГРУППА-01', 'ГРУППА-02'],
        dates: [now],
        lessonBells: LessonBells(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 10, minute: 30),
        ),
      );

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(ScheduleTargetType.teacher);
    registerFallbackValue(const SelectedScheduleRefreshRequested());
  });

  setUp(() {
    clockNow = now;
    account = _Account();
    schedules = _Schedules();
    campus = _Campus();
    schedule = _Schedule();
    accountEvents = StreamController<AccountPersonaState>.broadcast();
    when(() => account.state).thenReturn(accountState);
    when(() => account.stream).thenAnswer((_) => accountEvents.stream);
    when(() => schedule.state).thenReturn(const ScheduleState());
    when(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenAnswer((_) async => ScheduleResponse(data: [lesson()]));
    when(
      () => schedules.getScheduleChanges(
        targetType: any(named: 'targetType'),
        target: any(named: 'target'),
      ),
    ).thenAnswer((_) async => []);
    when(() => campus.getTeacherProfile(any())).thenAnswer(
      (_) async => const TeacherProfile(
        teacherName: 'Иванов Иван Иванович',
        clarity: 4,
        loyalty: 5,
        usefulness: 4.5,
        reviewsCount: 12,
      ),
    );
  });

  tearDown(() async => accountEvents.close());

  Widget subject() => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ScheduleRepository>.value(value: schedules),
      RepositoryProvider<CampusRepository>.value(value: campus),
      RepositoryProvider<UniversityConfig>.value(
        value: UniversityConfig.fromEnvironment(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AccountPersonaCubit>.value(value: account),
        BlocProvider<ScheduleBloc>.value(value: schedule),
      ],
      child: TeacherDashboardPage(clock: () => clockNow),
    ),
  );

  Future<void> pumpDashboard(
    WidgetTester tester, {
    TextScaler textScaler = TextScaler.noScaling,
    bool dark = false,
    Size size = const Size(320, 844),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: NinjaToastHost(child: child!),
        ),
        home: subject(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  Future<void> pumpRouter(WidgetTester tester, GoRouter router) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
    });
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('loads bound teacher and exact week without changing selection', (
    tester,
  ) async {
    await pumpDashboard(tester);
    verify(
      () => schedules.getTeacherSchedule(
        teacher: teacher.uid!,
        dateFrom: monday,
        dateTo: monday.add(const Duration(days: 6)),
      ),
    ).called(1);
    verify(() => campus.getTeacherProfile(teacher.name)).called(1);
    verify(
      () => schedules.getScheduleChanges(
        targetType: ScheduleTargetType.teacher,
        target: teacher.uid!,
      ),
    ).called(1);
    verifyNever(() => schedule.add(any()));
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('СЕЙЧАС ИДЁТ ЗАНЯТИЕ'), findsOneWidget);
    expect(find.textContaining('Математика'), findsWidgets);
    expect(find.textContaining('ГРУППА-01'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'rating is visible immediately and opens cached read-only reviews',
    (
      tester,
    ) async {
      await loadGalleryFonts();
      await pumpDashboard(tester, size: const Size(390, 844));
      final shortcut = find.byKey(const ValueKey('teacher-rating-shortcut'));
      expect(shortcut, findsOneWidget);
      expect(
        find.descendant(of: shortcut, matching: find.text('4,5')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: shortcut, matching: find.text('отзывов: 12')),
        findsOneWidget,
      );
      expect(tester.getBottomRight(shortcut).dy, lessThan(844));
      expect(
        tester.getBottomRight(find.text('Моё расписание')).dy,
        lessThan(844),
      );
      expect(find.text('Математика'), findsOneWidget);
      expect(tester.getBottomRight(find.text('Математика')).dy, lessThan(844));
      final lessonRow = tester.widget<AppLessonRow>(find.byType(AppLessonRow));
      expect(lessonRow.time, '09:00');
      expect(lessonRow.endTime, '10:30');
      expect(tester.getBottomRight(find.text('10:30')).dy, lessThan(844));
      final lessonMeta = find.text(lessonRow.meta!);
      expect(tester.getBottomRight(lessonMeta).dy, lessThan(844));
      final meta = lessonRow.meta!;
      expect(meta.indexOf('А-101'), lessThan(meta.indexOf('ГРУППА-01')));
      expect(find.text('Занятий в этот день нет'), findsNothing);
      await tester.tap(shortcut);
      await tester.pumpAndSettle();
      final page = tester.widget<TeacherProfilePage>(
        find.byType(TeacherProfilePage),
      );
      expect(page.readOnly, isTrue);
      expect(page.initialProfile?.reviewsCount, 12);
      expect(find.text('Оставить отзыв'), findsNothing);
      expect(find.text('Написать'), findsNothing);
      verify(() => campus.getTeacherProfile(teacher.name)).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'shared lesson row updates next, current and past at boundaries',
    (
      tester,
    ) async {
      clockNow = DateTime(2026, 10, 8, 8, 45);
      await pumpDashboard(tester);
      final rowFinder = find.byType(AppLessonRow);
      final l10n = tester.element(rowFinder).l10n;
      var row = tester.widget<AppLessonRow>(rowFinder);
      expect(row.state, LessonRowState.next);
      expect(row.chipLabel, l10n.lessonTagNext);
      expect(row.progress, isNull);
      expect(row.scheduleStyle, isTrue);
      expect(row.typeLabel, l10n.lessonShortLecture);
      expect(row.meta, contains('А-101'));
      expect(row.meta, contains('ГРУППА-01, ГРУППА-02'));
      expect(row.onTap, isNotNull);
      expect(row.onLongPress, isNull);
      expect(row.annotations, isEmpty);

      clockNow = DateTime(2026, 10, 8, 9);
      await tester.pump(const Duration(minutes: 1));
      row = tester.widget<AppLessonRow>(rowFinder);
      expect(row.state, LessonRowState.current);
      expect(row.chipLabel, l10n.lessonTagLive(90));
      expect(row.progress, 0);

      clockNow = now;
      await tester.pump(const Duration(minutes: 1));
      row = tester.widget<AppLessonRow>(rowFinder);
      expect(row.state, LessonRowState.current);
      expect(row.chipLabel, l10n.lessonTagLive(30));
      expect(row.progress, closeTo(2 / 3, 0.0001));

      clockNow = DateTime(2026, 10, 8, 10, 30);
      await tester.pump(const Duration(minutes: 1));
      row = tester.widget<AppLessonRow>(rowFinder);
      expect(row.state, LessonRowState.past);
      expect(row.chipLabel, isNull);
      expect(row.progress, isNull);
      expect(row.meta, contains(l10n.lessonMetaPast));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'cancelled shared row retains groups and suppresses live progress',
    (
      tester,
    ) async {
      when(
        () => schedules.getScheduleChanges(
          targetType: any(named: 'targetType'),
          target: any(named: 'target'),
        ),
      ).thenAnswer(
        (_) async => [
          ScheduleChange(
            id: 'cancel',
            kind: .cancel,
            subject: 'Математика',
            lessonDate: now,
            createdAt: now,
          ),
        ],
      );
      await pumpDashboard(tester);
      final rowFinder = find.byType(AppLessonRow);
      final row = tester.widget<AppLessonRow>(rowFinder);
      final context = tester.element(rowFinder);
      expect(row.state, LessonRowState.cancelled);
      expect(row.chipLabel, context.l10n.lessonTagCancelled);
      expect(row.chipColor, context.colors.danger);
      expect(row.progress, isNull);
      expect(row.meta, contains(context.l10n.lessonMetaCancelled));
      expect(row.meta, contains('А-101'));
      expect(row.meta, contains('ГРУППА-01, ГРУППА-02'));
      expect(
        tester.widget<Text>(find.text('Математика')).style?.decoration,
        TextDecoration.lineThrough,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'future shared preview retains its date and separate bell times',
    (
      tester,
    ) async {
      final tomorrow = now.add(const Duration(days: 1));
      when(
        () => schedules.getTeacherSchedule(
          teacher: any(named: 'teacher'),
          dateFrom: any(named: 'dateFrom'),
          dateTo: any(named: 'dateTo'),
        ),
      ).thenAnswer(
        (_) async => ScheduleResponse(
          data: [
            lesson().copyWith(dates: [tomorrow]),
          ],
        ),
      );
      await pumpDashboard(tester);
      final rowFinder = find.byType(AppLessonRow);
      final row = tester.widget<AppLessonRow>(rowFinder);
      expect(row.state, LessonRowState.next);
      expect(row.time, '09:00');
      expect(row.endTime, '10:30');
      expect(
        row.meta,
        contains(
          DateFormat.MMMEd(
            tester.element(rowFinder).l10n.localeName,
          ).format(tomorrow),
        ),
      );
      expect(row.meta, contains('А-101'));
      expect(row.meta, contains('ГРУППА-01, ГРУППА-02'));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('day list keeps lessons other than the top preview', (
    tester,
  ) async {
    when(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenAnswer(
      (_) async => ScheduleResponse(
        data: [
          lesson(),
          lesson(subject: 'Практика'),
        ],
      ),
    );
    await pumpDashboard(tester);
    expect(find.text('Математика'), findsOneWidget);
    expect(find.text('Практика'), findsOneWidget);
    expect(find.text('Занятий в этот день нет'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rating shortcut shows an honest empty summary', (tester) async {
    when(() => campus.getTeacherProfile(any())).thenAnswer(
      (_) async => TeacherProfile.empty,
    );
    await pumpDashboard(tester);
    final shortcut = find.byKey(const ValueKey('teacher-rating-shortcut'));
    expect(
      find.descendant(of: shortcut, matching: find.text('Оценок пока нет')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shortcut, matching: find.text('отзывов: 0')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shortcut, matching: find.text('0,0')),
      findsNothing,
    );
    await tester.tap(shortcut);
    await tester.pumpAndSettle();
    expect(find.text('О вас ещё нет отзывов'), findsOneWidget);
    expect(find.text('Оставить отзыв'), findsNothing);
    verify(() => campus.getTeacherProfile(teacher.name)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rating shortcut distinguishes loading and a retryable failure', (
    tester,
  ) async {
    final pending = Completer<TeacherProfile>();
    when(() => campus.getTeacherProfile(any())).thenAnswer(
      (_) => pending.future,
    );
    await pumpDashboard(tester);
    final shortcut = find.byKey(const ValueKey('teacher-rating-shortcut'));
    final l10n = tester.element(shortcut).l10n;
    expect(
      find.descendant(of: shortcut, matching: find.text(l10n.loadingContent)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shortcut, matching: find.text('отзывов: 0')),
      findsNothing,
    );
    expect(tester.widget<AppCard>(shortcut).onTap, isNull);
    pending.completeError(Exception('offline'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: shortcut,
        matching: find.text(l10n.teacherRatingRefreshError),
      ),
      findsOneWidget,
    );
    when(() => campus.getTeacherProfile(any())).thenAnswer(
      (_) async => TeacherProfile.empty,
    );
    await tester.tap(shortcut);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: shortcut, matching: find.text(l10n.teacherNoRating)),
      findsOneWidget,
    );
    verify(() => campus.getTeacherProfile(teacher.name)).called(2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher change drops a late old rating and old schedule', (
    tester,
  ) async {
    final oldSchedule = Completer<ScheduleResponse>();
    final oldRating = Completer<TeacherProfile>();
    when(
      () => schedules.getTeacherSchedule(
        teacher: teacher.uid!,
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenAnswer((_) => oldSchedule.future);
    when(() => campus.getTeacherProfile(teacher.name)).thenAnswer(
      (_) => oldRating.future,
    );
    await pumpDashboard(tester);
    const other = AccountPersonaState(
      persona: AccountPersona(
        role: AccountRole.teacher,
        teacherId: 'other-id',
        teacherName: 'Петров Пётр Петрович',
        teacherAvailable: true,
      ),
      loaded: true,
    );
    when(() => account.state).thenReturn(other);
    accountEvents.add(other);
    await tester.pumpAndSettle();
    oldSchedule.complete(
      ScheduleResponse(data: [lesson(subject: 'Старый курс')]),
    );
    oldRating.complete(const TeacherProfile(teacherName: 'old', clarity: 1));
    await tester.pumpAndSettle();
    expect(find.text('Петров Пётр Петрович'), findsOneWidget);
    expect(find.textContaining('Старый курс'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shared week strip keeps lesson markers and selecting days needs no fetch',
    (tester) async {
      await pumpDashboard(tester, size: const Size(390, 844));
      final stripFinder = find.byType(AppWeekStrip);
      var strip = tester.widget<AppWeekStrip>(stripFinder);
      expect(strip.days, hasLength(7));
      expect(strip.selectedIndex, 3);
      expect(strip.days[3].isToday, isTrue);
      expect(strip.days[3].dots, hasLength(1));
      expect(
        strip.days[3].semanticsLabel,
        contains(
          AppLocalizations.of(
            tester.element(find.byType(TeacherDashboardPage)),
          ).scheduleDayLessons(1),
        ),
      );
      expect(strip.days[6].isWeekend, isTrue);
      expect(strip.days[6].dots, isEmpty);
      expect(find.text('Сегодня'), findsNothing);
      final sunday = find.byWidgetPredicate(
        (widget) => widget is AppDayPill && widget.day.label == '11',
      );
      await tester.ensureVisible(sunday);
      await tester.pumpAndSettle();
      await tester.tap(sunday);
      await tester.pumpAndSettle();
      strip = tester.widget<AppWeekStrip>(stripFinder);
      expect(strip.selectedIndex, 6);
      expect(find.text('Занятий в этот день нет'), findsOneWidget);
      verify(
        () => schedules.getTeacherSchedule(
          teacher: teacher.uid!,
          dateFrom: monday,
          dateTo: monday.add(const Duration(days: 6)),
        ),
      ).called(1);
      final today = find.text('Сегодня');
      await tester.ensureVisible(today);
      await tester.pumpAndSettle();
      await tester.tap(today);
      await tester.pumpAndSettle();
      expect(tester.widget<AppWeekStrip>(stripFinder).selectedIndex, 3);
      expect(find.text('Занятий в этот день нет'), findsNothing);
      verifyNever(() => schedule.add(any()));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'teacher tools keep changes and calendar without global shortcuts',
    (tester) async {
      var changes = 0;
      var exports = 0;
      Future<void> pumpTools({bool busy = false}) => tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TeacherDashboardServicesSection(
              navigationBusy: busy,
              onOpenChanges: () => changes++,
              onExport: () => exports++,
            ),
          ),
        ),
      );
      await pumpTools();
      expect(find.text('Свободные аудитории'), findsNothing);
      expect(find.text('Карта кампуса'), findsNothing);
      expect(find.text('Конспекты'), findsNothing);
      await tester.tap(find.text('Изменения в расписании'));
      await tester.tap(find.text('Экспорт в календарь'));
      expect(changes, 1);
      expect(exports, 1);
      await pumpTools(busy: true);
      await tester.tap(find.text('Изменения в расписании'));
      await tester.tap(find.text('Экспорт в календарь'));
      expect(changes, 1);
      expect(exports, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'week navigation fetches the chosen week and discards stale data',
    (
      tester,
    ) async {
      await pumpDashboard(tester);
      when(
        () => schedules.getTeacherSchedule(
          teacher: any(named: 'teacher'),
          dateFrom: any(named: 'dateFrom'),
          dateTo: any(named: 'dateTo'),
        ),
      ).thenAnswer((_) async => const ScheduleResponse(data: []));
      await tester.tap(find.byTooltip('Следующая неделя'));
      await tester.pumpAndSettle();
      verify(
        () => schedules.getTeacherSchedule(
          teacher: teacher.uid!,
          dateFrom: monday.add(const Duration(days: 7)),
          dateTo: monday.add(const Duration(days: 13)),
        ),
      ).called(1);
      expect(find.textContaining('Математика'), findsNothing);
      expect(find.text('На этой неделе занятий нет'), findsOneWidget);
      verify(() => campus.getTeacherProfile(teacher.name)).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('my schedule activates the bound teacher then opens it', (
    tester,
  ) async {
    final scheduleEvents = StreamController<ScheduleState>.broadcast();
    addTearDown(scheduleEvents.close);
    when(() => schedule.stream).thenAnswer((_) => scheduleEvents.stream);
    when(() => schedule.add(any())).thenAnswer((invocation) {
      final event = invocation.positionalArguments.single;
      if (event is TeacherScheduleRequested) {
        final state = ScheduleState(
          selectedSchedule: SelectedTeacherSchedule(
            teacher: event.teacher,
            schedule: [lesson()],
          ),
          status: ScheduleStatus.loaded,
        );
        when(() => schedule.state).thenReturn(state);
        scheduleEvents.add(state);
      }
    });
    final router = GoRouter(
      initialLocation: '/profile/teacher',
      routes: [
        GoRoute(path: '/profile/teacher', builder: (_, _) => subject()),
        GoRoute(
          path: '/schedule',
          builder: (_, _) =>
              const Scaffold(body: Text('teacher schedule opened')),
        ),
      ],
    );
    await pumpRouter(tester, router);
    await tester.tap(find.text('Моё расписание'));
    await tester.pumpAndSettle();
    verify(
      () => schedule.add(const TeacherScheduleRequested(teacher: teacher)),
    ).called(1);
    expect(find.text('teacher schedule opened'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('local persona sync failure remains visible and can retry', (
    tester,
  ) async {
    when(() => account.state).thenReturn(
      accountState.copyWith(
        operation: AccountPersonaOperation.failed,
        pendingEdit: AccountPersonaEdit.roleOnly,
      ),
    );
    when(() => account.retry()).thenAnswer((_) async {});
    await pumpDashboard(tester);
    final banner = find.byWidgetPredicate(
      (widget) =>
          widget is AppBanner &&
          widget.message.contains('Выбор сохранён на устройстве'),
    );
    expect(banner, findsOneWidget);
    await tester.tap(banner);
    await tester.pumpAndSettle();
    verify(() => account.retry()).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses only a timestamped cache for the exact teacher UID', (
    tester,
  ) async {
    final savedAt = now.subtract(const Duration(days: 1));
    when(() => schedule.state).thenReturn(
      ScheduleState(
        teachersSchedule: [
          (teacher.uid!, teacher, [lesson(subject: 'Сохранённый курс')]),
        ],
        scheduleSyncedAt: {teacher.uid!: savedAt},
      ),
    );
    when(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenThrow(Exception('offline'));
    await pumpDashboard(tester);
    expect(find.byType(AppErrorState), findsNothing);
    expect(find.textContaining('Сохранённый курс'), findsWidgets);
    expect(
      find.byKey(const ValueKey('teacher-schedule-refresh-error')),
      findsOneWidget,
    );
    final freshness = tester.widget<Text>(
      find.byKey(const ValueKey('teacher-schedule-freshness')),
    );
    expect(freshness.data, contains('сохранённая версия'));
    expect(freshness.data, contains('7 окт.'));
    verifyNever(() => schedule.add(any()));
    expect(tester.takeException(), isNull);
  });

  for (final hasTimestamp in [false, true]) {
    testWidgets(
      'rejects cache '
      '${hasTimestamp ? 'with another UID' : 'without timestamp'}',
      (tester) async {
        final cacheUid = hasTimestamp ? 'another-id' : teacher.uid!;
        when(() => schedule.state).thenReturn(
          ScheduleState(
            teachersSchedule: [
              (
                cacheUid,
                Teacher(uid: cacheUid, name: teacher.name),
                [lesson(subject: 'Чужой или устаревший курс')],
              ),
            ],
            scheduleSyncedAt: hasTimestamp ? {cacheUid: now} : {},
          ),
        );
        when(
          () => schedules.getTeacherSchedule(
            teacher: any(named: 'teacher'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
          ),
        ).thenThrow(Exception('offline'));
        await pumpDashboard(tester);
        expect(find.byType(AppErrorState), findsOneWidget);
        expect(find.textContaining('Чужой или устаревший курс'), findsNothing);
        expect(
          find.byKey(const ValueKey('teacher-schedule-freshness')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('refresh keeps loaded lessons and rating through a failure', (
    tester,
  ) async {
    await pumpDashboard(tester);
    final refreshSchedule = Completer<ScheduleResponse>();
    final refreshRating = Completer<TeacherProfile>();
    when(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenAnswer((_) => refreshSchedule.future);
    when(() => campus.getTeacherProfile(any())).thenAnswer(
      (_) => refreshRating.future,
    );
    final refresh = tester
        .widget<RefreshIndicator>(
          find.byType(RefreshIndicator),
        )
        .onRefresh();
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Математика'), findsWidgets);
    expect(
      find.byKey(const ValueKey('teacher-rating-summary')),
      findsOneWidget,
    );
    expect(find.byType(AppSkeletonGroup), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    refreshSchedule.completeError(Exception('network'));
    refreshRating.completeError(Exception('network'));
    await refresh;
    await tester.pumpAndSettle();
    expect(find.textContaining('Математика'), findsWidgets);
    expect(
      find.byKey(const ValueKey('teacher-rating-summary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('teacher-schedule-refresh-error')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('teacher-rating-refresh-error')),
      findsOneWidget,
    );
    expect(find.byType(AppErrorState), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('my schedule recognizes an existing teacher by UID', (
    tester,
  ) async {
    when(() => schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedTeacherSchedule(
          teacher: const Teacher(uid: 'teacher-id', name: 'Старое имя'),
          schedule: [lesson()],
        ),
        status: ScheduleStatus.loaded,
      ),
    );
    final router = GoRouter(
      initialLocation: '/profile/teacher',
      routes: [
        GoRoute(path: '/profile/teacher', builder: (_, _) => subject()),
        GoRoute(
          path: '/schedule',
          builder: (_, _) => const Scaffold(body: Text('teacher UID opened')),
        ),
      ],
    );
    await pumpRouter(tester, router);
    await tester.tap(find.text('Моё расписание'));
    await tester.pumpAndSettle();
    expect(find.text('teacher UID opened'), findsOneWidget);
    verifyNever(() => schedule.add(any()));
    expect(tester.takeException(), isNull);
  });

  testWidgets('lesson action keeps source teacher and ordinary selection', (
    tester,
  ) async {
    String? sourceId;
    String? sourceName;
    Object? extra;
    final router = GoRouter(
      initialLocation: '/profile/teacher',
      routes: [
        GoRoute(path: '/profile/teacher', builder: (_, _) => subject()),
        GoRoute(
          path: '/schedule/details',
          builder: (_, state) {
            sourceId = state.uri.queryParameters['teacher-id'];
            sourceName = state.uri.queryParameters['teacher-name'];
            extra = state.extra;
            return const Scaffold(body: Text('lesson opened'));
          },
        ),
      ],
    );
    await pumpRouter(tester, router);
    await tester.ensureVisible(find.text('Математика').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Математика').first);
    await tester.pumpAndSettle();
    expect(find.text('lesson opened'), findsOneWidget);
    expect(sourceId, teacher.uid);
    expect(sourceName, teacher.name);
    expect(extra, isA<(LessonSchedulePart, DateTime)>());
    verifyNever(() => schedule.add(any()));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rating stays available when schedule request fails', (
    tester,
  ) async {
    when(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    ).thenThrow(Exception('offline'));
    await pumpDashboard(tester);
    expect(find.byType(AppErrorState), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Отзывы студентов'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unavailable binding asks for selection and loads no old data', (
    tester,
  ) async {
    when(() => account.state).thenReturn(
      accountState.copyWith(
        persona: accountState.persona.copyWith(teacherAvailable: false),
      ),
    );
    await pumpDashboard(tester);
    expect(find.text('Преподаватель недоступен'), findsOneWidget);
    verifyNever(() => campus.getTeacherProfile(any()));
    verifyNever(
      () => schedules.getTeacherSchedule(
        teacher: any(named: 'teacher'),
        dateFrom: any(named: 'dateFrom'),
        dateTo: any(named: 'dateTo'),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('cabinet remains usable at 320 px and 200 percent text', (
    tester,
  ) async {
    await pumpDashboard(tester, textScaler: const TextScaler.linear(2));
    expect(tester.takeException(), isNull);
    for (var index = 0; index < 12; index++) {
      await tester.drag(find.byType(ListView), const Offset(0, -650));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Экспорт в календарь'), findsOneWidget);
    expect(find.text('Свободные аудитории'), findsNothing);
    expect(find.text('Карта кампуса'), findsNothing);
    expect(find.text('Конспекты'), findsNothing);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'long teacher name at 320 px and 160 percent ${dark ? 'dark' : 'light'}',
      (tester) async {
        await loadGalleryFonts();
        final longName = accountState.copyWith(
          persona: accountState.persona.copyWith(
            teacherName:
                'Александрова-Константинопольская '
                'Екатерина Владимировна',
          ),
        );
        when(() => account.state).thenReturn(longName);
        await pumpDashboard(
          tester,
          textScaler: const TextScaler.linear(1.6),
          dark: dark,
        );
        expect(
          tester
              .widget<Text>(
                find.byKey(const ValueKey('teacher-dashboard-name')),
              )
              .semanticsLabel,
          longName.persona.teacherName,
        );
        expect(
          tester
              .renderObject<RenderParagraph>(
                find.text(
                  AppLocalizations.of(
                    tester.element(find.byType(TeacherDashboardPage)),
                  ).teacherCabinetTitle,
                ),
              )
              .didExceedMaxLines,
          isFalse,
        );
        final changeTeacher = find.byKey(
          const ValueKey('teacher-dashboard-change-teacher'),
        );
        expect(
          tester.widget<AppIconButton>(changeTeacher).tooltip,
          'Сменить преподавателя',
        );
        expect(tester.getSize(changeTeacher).width, greaterThanOrEqualTo(44));
        expect(tester.getSize(changeTeacher).height, greaterThanOrEqualTo(44));
        final sunday = find.byWidgetPredicate(
          (widget) => widget is AppDayPill && widget.day.label == '11',
        );
        await tester.ensureVisible(sunday);
        await tester.pumpAndSettle();
        final daySize = tester.getSize(sunday);
        expect(daySize.width, greaterThanOrEqualTo(44));
        expect(daySize.height, greaterThanOrEqualTo(44));
        await tester.tap(sunday);
        await tester.pumpAndSettle();
        expect(find.text('Занятий в этот день нет'), findsOneWidget);
        for (var index = 0; index < 8; index++) {
          await tester.drag(find.byType(ListView), const Offset(0, -650));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(find.text('Экспорт в календарь'), findsOneWidget);
        expect(find.text('Свободные аудитории'), findsNothing);
      },
    );

    testWidgets(
      'teacher cabinet ${dark ? 'dark' : 'light'} gallery',
      (tester) async {
        await loadGalleryFonts();
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: subject(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/teacher_cabinet_${dark ? 'dark' : 'light'}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        when(() => account.state).thenReturn(
          accountState.copyWith(
            persona: accountState.persona.copyWith(
              teacherName:
                  'Александрова-Константинопольская '
                  'Екатерина Владимировна',
            ),
          ),
        );
        tester.view.physicalSize = const Size(320, 2200);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.6),
              ),
              child: child!,
            ),
            home: subject(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/teacher_cabinet_large_text_'
            '${dark ? 'dark' : 'light'}.png',
          ),
        );
      },
      tags: const ['gallery'],
    );
  }
}

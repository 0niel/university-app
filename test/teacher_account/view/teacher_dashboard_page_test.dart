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
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/view/teacher_dashboard_page.dart';
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
      child: TeacherDashboardPage(clock: () => now),
    ),
  );

  Future<void> pumpDashboard(
    WidgetTester tester, {
    TextScaler textScaler = TextScaler.noScaling,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(320, 844)
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
      accountState.copyWith(syncError: true, pendingSync: true),
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
    await tester.drag(find.byType(ListView), const Offset(0, -500));
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
    expect(find.text('Свободные аудитории'), findsOneWidget);
    expect(find.text('Конспекты'), findsOneWidget);
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
                find.text('Кабинет преподавателя'),
              )
              .didExceedMaxLines,
          isFalse,
        );
        expect(
          tester
              .renderObject<RenderParagraph>(
                find.text('Сменить преподавателя'),
              )
              .didExceedMaxLines,
          isFalse,
        );
        final sundayDate = monday.add(const Duration(days: 6));
        final sunday = find.byKey(
          ValueKey('teacher-day-${sundayDate.toIso8601String()}'),
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
        expect(find.text('Свободные аудитории'), findsOneWidget);
      },
    );

    testWidgets(
      'teacher cabinet ${dark ? 'dark' : 'light'} gallery',
      (tester) async {
        await loadGalleryFonts();
        tester.view
          ..physicalSize = const Size(390, 1800)
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

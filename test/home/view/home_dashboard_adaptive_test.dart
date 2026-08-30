import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';
import 'package:rtu_mirea_app/home/view/home_day_pager.dart';
import 'package:rtu_mirea_app/home/view/home_lesson_hero.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  test('lesson is current at the exact bell start', () {
    final now = DateTime(2026, 8, 18, 10);
    final lesson = LessonSchedulePart(
      subject: 'Математика',
      lessonType: .lecture,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 30),
      ),
      dates: [now],
    );

    final focus = homeFocusState(day: now, lessons: [lesson], now: now);

    expect(focus.current, lesson);
    expect(focus.focus, lesson);
    expect(focus.following, isEmpty);
  });

  test('home header stays loading until every summary source is ready', () {
    expect(
      homeHeaderShowsLoading(
        deadlinesLoading: true,
        scheduleLoading: false,
      ),
      isTrue,
    );
    expect(
      homeHeaderShowsLoading(
        deadlinesLoading: false,
        scheduleLoading: true,
      ),
      isTrue,
    );
    expect(
      homeHeaderShowsLoading(
        deadlinesLoading: false,
        scheduleLoading: false,
      ),
      isFalse,
    );
  });

  test('home only waits for remote schedule refreshes', () {
    expect(homeWaitsForScheduleRefresh(null), isFalse);
    expect(
      homeWaitsForScheduleRefresh(
        const SelectedCustomSchedule(
          id: 'custom',
          name: 'Личное',
          schedule: [],
        ),
      ),
      isFalse,
    );
    expect(
      homeWaitsForScheduleRefresh(
        const SelectedGroupSchedule(
          group: Group(name: 'ИКБО-01-24'),
          schedule: [],
        ),
      ),
      isTrue,
    );
  });

  test('older home load cannot overwrite a newer completion', () async {
    final gate = HomeLatestRequest();
    final older = Completer<String>();
    final newer = Completer<String>();
    final applied = <String>[];

    Future<void> apply(Future<String> request) async {
      final revision = gate.begin();
      final value = await request;
      if (gate.accepts(revision)) applied.add(value);
    }

    final olderRun = apply(older.future);
    final newerRun = apply(newer.future);
    newer.complete('new');
    await newerRun;
    older.complete('old');
    await olderRun;

    expect(applied, ['new']);
  });

  testWidgets('home schedule stays usable at 320px and 200 percent AMOLED', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final now = DateTime(2026, 8, 18, 10, 15);
    final days = homeDayWindow(now);
    final lesson = LessonSchedulePart(
      subject: 'Проектирование распределённых информационных систем',
      lessonType: .laboratoryWork,
      teachers: const [Teacher(name: 'Иванов Иван Иванович')],
      classrooms: const [Classroom(name: 'А-123')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 30),
      ),
      dates: [days[2]],
    );
    final amoled = AppColors.dark.copyWith(
      background01: Colors.black,
      background02: const Color(0xFF101010),
      background03: const Color(0xFF171717),
      surface: const Color(0xFF101010),
      surfaceHigh: const Color(0xFF171717),
      surfaceLow: const Color(0xFF202020),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.generateTheme(amoled, Brightness.dark),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
              disableAnimations: true,
              accessibleNavigation: true,
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeDayPager(
                      days: days,
                      lessonCounts: List.filled(days.length, 2),
                      selectedIndex: kHomeDayWindowTodayIndex,
                      onSelected: (_) {},
                    ),
                    Padding(
                      padding: const .all(NinjaMetrics.screenPadding),
                      child: HomeLessonHero(
                        lesson: lesson,
                        day: days[2],
                        now: now,
                        isCurrent: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(PageView), findsNothing);
    expect(
      tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .every((widget) => widget.duration == Duration.zero),
      isTrue,
    );
    final selectedDay = tester.getSemantics(find.text('18').first);
    expect(selectedDay.flagsCollection.isSelected, Tristate.isTrue);
    expect(find.textContaining('ещё 75 мин'), findsOneWidget);
    expect(find.textContaining('А-123'), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, isNull);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).colors.background01,
      Colors.black,
    );
  });

  testWidgets('pinned day rail matches its declared phone extent', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 665)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final days = homeDayWindow(DateTime(2026, 8, 19));

    Future<void> pumpRail(double textScale, double height) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 190)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HomeDayRailDelegate(
                    height: height,
                    days: days,
                    lessonCounts: List.filled(days.length, 1),
                    selectedIndex: 0,
                    onSelected: (_) {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 800)),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(HomeDayPager)).height, height);
    }

    await pumpRail(1, 70);
    await pumpRail(2, 84);
  });
}

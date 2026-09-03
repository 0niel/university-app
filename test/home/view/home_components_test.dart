import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_deadlines_group.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_hero.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_lessons_group.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  final day = DateTime(2026, 9, 2);
  final lesson = LessonSchedulePart(
    subject: 'Теоретические основы информатики и программирования',
    lessonType: LessonType.lecture,
    teachers: const [Teacher(name: 'Константинопольский К. К.')],
    classrooms: const [Classroom(name: 'Г-101')],
    lessonBells: LessonBells(
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    dates: [day],
  );
  HomeLessonEntry entry(HomeHeroKind kind) => HomeLessonEntry(
    lesson: lesson,
    start: day.add(const Duration(hours: 9)),
    end: day.add(const Duration(hours: 10, minutes: 30)),
    isCurrent: kind == HomeHeroKind.during,
    isNext: kind == HomeHeroKind.before || kind == HomeHeroKind.pause,
    isPast: kind == HomeHeroKind.done,
  );

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    double width = 390,
    double scale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  for (final kind in HomeHeroKind.values) {
    testWidgets('$kind supports narrow width and 200% text without overflow', (
      tester,
    ) async {
      await pump(
        tester,
        HomeHero(
          entries: kind == HomeHeroKind.free ? [] : [entry(kind)],
          kind: kind,
          tomorrow: [lesson],
          now: day.add(const Duration(hours: 9, minutes: 30)),
          onOpen: (_) {},
          onRoute: (_) {},
          onNote: (_) {},
          onFreeRooms: () {},
          onDeadlines: () {},
          onTomorrow: () {},
        ),
        width: 320,
        scale: 2,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'featured lesson is omitted once and overlapping lessons remain',
    (tester) async {
      final first = entry(HomeHeroKind.during);
      final second = HomeLessonEntry(
        lesson: lesson.copyWith(subject: 'Параллельный практикум'),
        start: first.start,
        end: first.end,
        isCurrent: true,
      );
      HomeLessonEntry? opened;
      await pump(
        tester,
        HomeLessonsGroup(
          entries: [first, second],
          featuredEntry: first,
          onOpen: (value) => opened = value,
        ),
      );
      expect(find.text(lesson.subject), findsNothing);
      expect(find.text(second.lesson.subject), findsOneWidget);
      await tester.tap(find.text(second.lesson.subject));
      expect(opened, same(second));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'cancelled lesson row remains readable at narrow width and 200%',
    (tester) async {
      await pump(
        tester,
        HomeLessonRow(
          entry: HomeLessonEntry(
            lesson: lesson,
            start: day.add(const Duration(hours: 9)),
            end: day.add(const Duration(hours: 10, minutes: 30)),
            isCancelled: true,
          ),
          onTap: () {},
        ),
        width: 320,
        scale: 2,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('hero route and note use distinct working callbacks', (
    tester,
  ) async {
    var routes = 0;
    var notes = 0;
    await pump(
      tester,
      HomeHero(
        entries: [entry(HomeHeroKind.during)],
        kind: HomeHeroKind.during,
        tomorrow: const [],
        now: day.add(const Duration(hours: 9, minutes: 30)),
        onOpen: (_) {},
        onRoute: (_) => routes++,
        onNote: (_) => notes++,
        onFreeRooms: () {},
        onDeadlines: () {},
        onTomorrow: () {},
      ),
    );
    await tester.tap(find.byType(AppButton));
    await tester.tap(find.byType(AppIconButton));
    expect(routes, 1);
    expect(notes, 1);
  });

  testWidgets('deadline completion only enabled for own non-pending records', (
    tester,
  ) async {
    Deadline deadline(String id, {bool mine = false}) => Deadline(
      id: id,
      title: id,
      dueAt: day,
      source: DeadlineSource.me,
      isMine: mine,
    );
    final own = deadline('own', mine: true);
    final pending = deadline('pending', mine: true);
    final shared = deadline('shared');
    final toggles = <String>[];
    await pump(
      tester,
      HomeDeadlinesGroup(
        state: DeadlinesState(
          status: DeadlinesStatus.ready,
          deadlines: [own, pending, shared],
          pendingDeadlineIds: {'pending'},
        ),
        now: day,
        onAdd: () {},
        onOpen: () {},
        onRetry: () {},
        onToggle: (deadline) => toggles.add(deadline.id),
      ),
    );
    final rows = tester.widgetList<AppDeadlineRow>(find.byType(AppDeadlineRow));
    expect(rows.where((row) => row.onToggle != null), hasLength(1));
    rows.firstWhere((row) => row.onToggle != null).onToggle!();
    expect(toggles, ['own']);
  });
}

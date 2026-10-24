import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final monday = DateTime(2030, 9, 2);
  const config = UniversityConfig(
    organizationId: 'test',
    appName: 'University',
    universityName: 'University',
    universityShortName: 'University',
    websiteUrl: 'https://example.test',
    supportEmail: 'support@example.test',
    deepLinkScheme: 'university',
    webAppHost: 'example.test',
    webAppPathPrefix: '/',
    lessonBellSlots: [
      LessonBellSlotConfig(startMinutes: 540, endMinutes: 630),
      LessonBellSlotConfig(startMinutes: 640, endMinutes: 730),
      LessonBellSlotConfig(startMinutes: 740, endMinutes: 830),
      LessonBellSlotConfig(startMinutes: 840, endMinutes: 930),
      LessonBellSlotConfig(startMinutes: 940, endMinutes: 1030),
      LessonBellSlotConfig(startMinutes: 1040, endMinutes: 1130),
    ],
  );
  final populated = [
    for (var day = 0; day < 6; day++)
      for (final slot in config.lessonBellSlots)
        scheduleTestLesson(
          day: monday.add(Duration(days: day)),
          start: slot.startMinutes,
          end: slot.endMinutes,
          subject: 'Lesson $day ${slot.startMinutes}',
        ),
  ];

  Widget week(List<SchedulePart> schedule) =>
      RepositoryProvider<UniversityConfig>.value(
        value: config,
        child: ScheduleWeekView(
          day: monday,
          now: monday,
          schedule: schedule,
          changes: const [],
          preferences: const SchedulePreferencesState(),
          display: const ScheduleDisplayState(),
          activities: const [],
          onDay: (_) {},
        ),
      );

  final table = find.byKey(const ValueKey('schedule-week-table'));

  for (final axis in Axis.values) {
    testWidgets('populated week reuses its table layer on $axis scroll', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [week(populated), const SizedBox(height: 1000)],
            ),
          ),
        ),
        size: const Size(390, 844),
        textScaler: TextScaler.linear(axis == Axis.horizontal ? 2 : 1),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppWeekGridCell), findsNWidgets(36));
      final boundary = tester.renderObject<RenderRepaintBoundary>(table);
      final pictures = _pictures(boundary.debugLayer!).toList();
      expect(pictures, isNotEmpty);
      final initialPosition = tester.getTopLeft(table);
      boundary.debugResetMetrics();
      final position = axis == Axis.vertical
          ? controller.position
          : tester
                .state<ScrollableState>(
                  find.descendant(
                    of: find.byKey(
                      const ValueKey('schedule-week-table-scroll'),
                    ),
                    matching: find.byType(Scrollable),
                  ),
                )
                .position;
      expect(position.maxScrollExtent, greaterThan(32));
      for (var frame = 1; frame <= 8; frame++) {
        position.jumpTo(frame * 4);
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(boundary.debugSymmetricPaintCount, 0);
      expect(
        boundary.debugAsymmetricPaintCount,
        axis == Axis.horizontal ? 8 : 0,
      );
      expect(
        tester.getTopLeft(table) - initialPosition,
        axis == Axis.horizontal ? const Offset(-32, 0) : const Offset(0, -32),
      );
      expect(_pictures(boundary.debugLayer!), orderedEquals(pictures));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('cached week refreshes subgroups and changed lesson actions', (
    tester,
  ) async {
    LessonSchedulePart lesson(String subject, LessonType type, String room) =>
        scheduleTestLesson(day: monday, subject: subject, type: type).copyWith(
          classrooms: [Classroom(name: room)],
        );
    final source = ValueNotifier<List<SchedulePart>>([
      lesson('First subgroup', .lecture, 'А-101'),
      lesson('Second subgroup', .practice, 'А-202'),
    ]);
    addTearDown(source.dispose);
    (LessonSchedulePart, DateTime)? opened;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: SingleChildScrollView(
              child: ValueListenableBuilder<List<SchedulePart>>(
                valueListenable: source,
                builder: (_, schedule, _) => week(schedule),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/schedule/details',
          builder: (_, state) {
            opened = state.extra! as (LessonSchedulePart, DateTime);
            return const Scaffold(body: Text('Lesson details'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpApp(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    final firstCell = find.byKey(
      ValueKey('week-cell-${monday.toIso8601String()}-540'),
    );
    final next = find.descendant(
      of: firstCell,
      matching: find.byKey(const ValueKey('schedule-overlap-next')),
    );
    final boundary = tester.renderObject<RenderRepaintBoundary>(table);
    final initialPictures = _pictures(boundary.debugLayer!).toList();
    expect(find.text('А-101'), findsOneWidget);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('А-101'), findsNothing);
    expect(find.text('А-202'), findsOneWidget);
    expect(
      _pictures(boundary.debugLayer!),
      isNot(orderedEquals(initialPictures)),
    );

    final subgroupPictures = _pictures(boundary.debugLayer!).toList();
    source.value = [
      lesson('Updated lesson', .laboratoryWork, 'Б-303'),
    ];
    await tester.pumpAndSettle();
    expect(tester.renderObject<RenderRepaintBoundary>(table), same(boundary));
    expect(find.text('А-202'), findsNothing);
    expect(find.text('Б-303'), findsOneWidget);
    expect(next, findsNothing);
    expect(
      _pictures(boundary.debugLayer!),
      isNot(orderedEquals(subgroupPictures)),
    );
    await tester.tap(
      find.descendant(of: firstCell, matching: find.byType(AppWeekGridCell)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lesson details'), findsOneWidget);
    expect(opened?.$1.subject, 'Updated lesson');
    expect(opened?.$1.classrooms.single.name, 'Б-303');
    expect(opened?.$2, monday);
    expect(tester.takeException(), isNull);
  });
}

Iterable<PictureLayer> _pictures(Layer layer) sync* {
  if (layer is PictureLayer) yield layer;
  if (layer is ContainerLayer) {
    var child = layer.firstChild;
    while (child != null) {
      yield* _pictures(child);
      child = child.nextSibling;
    }
  }
}

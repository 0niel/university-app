import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  setUpAll(loadGalleryFonts);

  final monday = DateTime(2026, 9, 7);
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
      LessonBellSlotConfig(startMinutes: 1080, endMinutes: 1170),
      LessonBellSlotConfig(startMinutes: 1180, endMinutes: 1270),
    ],
  );

  Finder cell(DateTime date, int start) => find.byKey(
    ValueKey('week-cell-${date.toIso8601String()}-$start'),
  );

  Finder lesson(DateTime date, int start) => find.descendant(
    of: cell(date, start),
    matching: find.byType(AppWeekGridCell),
  );

  for (final days in [6, 7]) {
    for (final width in [320.0, 390.0]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          '$days-day subgroup lessons stay aligned at $width and $scale text',
          (tester) async {
            final tuesday = monday.add(const Duration(days: 1));
            await tester.pumpApp(
              RepositoryProvider<UniversityConfig>.value(
                value: config,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ScheduleWeekView(
                        day: monday,
                        now: monday,
                        schedule: [
                          scheduleTestLesson(
                            day: monday,
                            start: 1080,
                            end: 1170,
                            type: .practice,
                            subject: 'Первая подгруппа',
                          ),
                          scheduleTestLesson(
                            day: monday,
                            start: 1080,
                            end: 1170,
                            type: .laboratoryWork,
                            subject: 'Вторая подгруппа',
                          ),
                          scheduleTestLesson(
                            day: tuesday,
                            start: 1080,
                            end: 1170,
                          ),
                          if (days == 7)
                            scheduleTestLesson(
                              day: monday.add(const Duration(days: 6)),
                              start: 1080,
                              end: 1170,
                            ),
                        ],
                        changes: const [],
                        preferences: const SchedulePreferencesState(),
                        display: const ScheduleDisplayState(),
                        activities: const [],
                        onDay: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
              size: Size(width, 900),
              textScaler: TextScaler.linear(scale),
            );
            await tester.pumpAndSettle();

            expect(find.byType(AppDayPill), findsNWidgets(days));
            final subgroup = lesson(monday, 1080);
            final neighbor = lesson(tuesday, 1080);
            final next = find.descendant(
              of: cell(monday, 1080),
              matching: find.byKey(const ValueKey('schedule-overlap-next')),
            );
            final card = find.descendant(
              of: cell(monday, 1080),
              matching: find.byKey(const ValueKey('schedule-overlap-card')),
            );
            final originalHeight = tester.getSize(card).height;
            expect(
              tester.getRect(subgroup).top,
              closeTo(tester.getRect(neighbor).top, .1),
            );
            expect(
              tester.getRect(next).top,
              greaterThanOrEqualTo(tester.getRect(subgroup).bottom),
            );
            expect(tester.getSize(next).height, greaterThanOrEqualTo(44));
            expect(
              tester.getRect(card).bottom,
              lessThan(tester.getRect(cell(monday, 1180)).top),
            );

            await tester.tap(next);
            await tester.pumpAndSettle();
            expect(find.text('2/2'), findsOneWidget);
            expect(tester.widget<AppWeekGridCell>(subgroup).topLabel, 'ЛАБ');
            expect(tester.getSize(card).height, originalHeight);
            expect(
              tester.getRect(subgroup).top,
              closeTo(tester.getRect(neighbor).top, .1),
            );
            expect(
              tester.getRect(card).bottom,
              lessThan(tester.getRect(cell(monday, 1180)).top),
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('compact switcher opens the selected subgroup lesson', (
    tester,
  ) async {
    (LessonSchedulePart, DateTime)? opened;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => RepositoryProvider<UniversityConfig>.value(
            value: config,
            child: Scaffold(
              body: SingleChildScrollView(
                child: ScheduleWeekView(
                  day: monday,
                  now: monday,
                  schedule: [
                    for (final subject in [
                      'Первая подгруппа',
                      'Вторая подгруппа',
                    ])
                      scheduleTestLesson(
                        day: monday,
                        start: 1080,
                        end: 1170,
                        subject: subject,
                      ),
                  ],
                  changes: const [],
                  preferences: const SchedulePreferencesState(),
                  display: const ScheduleDisplayState(),
                  activities: const [],
                  onDay: (_) {},
                ),
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
      size: const Size(320, 900),
    );
    await tester.pumpAndSettle();
    final next = find.descendant(
      of: cell(monday, 1080),
      matching: find.byKey(const ValueKey('schedule-overlap-next')),
    );
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('2/2'), findsOneWidget);
    expect(opened, isNull);
    await tester.tap(lesson(monday, 1080));
    await tester.pumpAndSettle();
    expect(find.text('Lesson details'), findsOneWidget);
    expect(opened?.$1.subject, 'Вторая подгруппа');
    expect(opened?.$2, monday);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    await tester.tap(lesson(monday, 1080));
    await tester.pumpAndSettle();
    expect(opened?.$1.subject, 'Первая подгруппа');
    expect(tester.takeException(), isNull);
  });
}

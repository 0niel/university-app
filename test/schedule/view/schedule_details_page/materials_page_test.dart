import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  group('LessonMaterialsPage loading skeleton', () {
    late ScheduleRepository repository;

    final lesson = LessonSchedulePart(
      subject: 'Машинное обучение',
      lessonType: LessonType.practice,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 40),
        endTime: const TimeOfDay(hour: 12, minute: 10),
      ),
      dates: [DateTime(2026, 5, 20)],
    );

    setUp(() {
      repository = MockScheduleRepository();
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<ScheduleRepository>.value(
          value: repository,
          child: LessonMaterialsPage(
            lesson: lesson,
            selectedDate: DateTime(2026, 5, 20),
            lessonNumber: 3,
          ),
        ),
      );
    }

    testWidgets('shows a shimmering skeleton and no spinner on cold load', (
      tester,
    ) async {
      // Never completes: the details load stays in flight so the page keeps
      // its cold-load `_loading == true` state and renders the skeleton.
      final completer = Completer<LessonDetailsResponse>();
      when(
        () => repository.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('empty card fills the materials list width', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      when(
        () => repository.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer(
        (_) async => const LessonDetailsResponse(
          reactions: LessonReactionResponse(counts: {}),
          materials: [],
          reviews: [],
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final empty = find.byKey(const ValueKey('materials_page_empty'));
      expect(empty, findsOneWidget);
      expect(
        tester.getSize(empty).width,
        closeTo(390 - NinjaMetrics.screenPadding * 2, .1),
      );
      expect(tester.takeException(), isNull);
    });
  });
}

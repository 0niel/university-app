import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'mock_schedule_repository.dart';

void main() {
  testWidgets(
    'all reaction types remain selectable and removable through More',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(1200, 5000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final schedule = MockScheduleRepository();
      final friends = MockFriendsRepository();
      final campus = MockCampusRepository();
      String? selected;
      final sent = <String>[];
      when(
        () => schedule.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer(
        (_) async => LessonDetailsResponse(
          reactions: LessonReactionResponse(
            counts: const {},
            userReaction: selected,
          ),
          materials: const [],
          reviews: const [],
        ),
      );
      when(
        () => schedule.postLessonReaction(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
          reactionType: any(named: 'reactionType'),
        ),
      ).thenAnswer((invocation) async {
        selected = invocation.namedArguments[#reactionType]! as String;
        sent.add(selected!);
      });
      when(
        () => schedule.deleteLessonReaction(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer((_) async => selected = null);
      when(friends.getGroupMembers).thenAnswer((_) async => GroupRoster.empty);
      final day = DateTime(2026, 9, 2);
      final lesson = LessonSchedulePart(
        subject: 'Матан',
        lessonType: .lecture,
        teachers: const [],
        classrooms: const [],
        lessonBells: LessonBells(
          number: 1,
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 10, minute: 30),
        ),
        dates: [day],
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<ScheduleRepository>.value(value: schedule),
              RepositoryProvider<FriendsRepository>.value(value: friends),
              RepositoryProvider<CampusRepository>.value(value: campus),
            ],
            child: ScheduleDetailsPage(lesson: lesson, selectedDate: day),
          ),
        ),
      );
      await tester.pumpAndSettle();
      const mainReactions = {'brain', 'thinking', 'sleepy', 'fire'};
      for (final reaction in ReactionType.values) {
        expect(
          find.byKey(ValueKey('lesson-reaction-${reaction.name}')),
          mainReactions.contains(reaction.name) ? findsOneWidget : findsNothing,
        );
      }
      for (final reaction in ReactionType.values) {
        final more = find.byKey(const ValueKey('lesson-reactions-more'));
        await tester.ensureVisible(more);
        await tester.tap(more);
        await tester.pumpAndSettle();
        for (final option in ReactionType.values) {
          final optionFinder = find.byKey(
            ValueKey('lesson-reaction-option-${option.name}'),
          );
          expect(
            optionFinder,
            findsOneWidget,
          );
          expect(
            tester.widget<AppChip>(optionFinder).label,
            startsWith('${option.emoji} '),
          );
        }
        await tester.tap(
          find.byKey(ValueKey('lesson-reaction-option-${reaction.name}')),
        );
        await tester.pumpAndSettle();
        expect(selected, reaction.name);
        final selectedChip = find.byKey(
          ValueKey('lesson-reaction-${reaction.name}'),
        );
        expect(tester.widget<AppChip>(selectedChip).selected, isTrue);
        expect(
          tester.widget<AppChip>(selectedChip).label,
          startsWith('${reaction.emoji} '),
        );
        await tester.ensureVisible(selectedChip);
        await tester.tap(selectedChip);
        await tester.pumpAndSettle();
        expect(selected, isNull);
      }
      expect(
        sent,
        ReactionType.values.map((reaction) => reaction.name).toList(),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

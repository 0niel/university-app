import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'mock_schedule_repository.dart';

void main() {
  testWidgets('serializes rapid taps even when an intermediate reload fails', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 5000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scheduleRepository = MockScheduleRepository();
    final friendsRepository = MockFriendsRepository();
    final campusRepository = MockCampusRepository();
    final events = <String>[];
    var detailsCall = 0;

    when(
      () => scheduleRepository.getLessonDetails(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
      ),
    ).thenAnswer((_) async {
      final call = detailsCall++;
      if (call == 1) {
        events.add('details:error');
        throw Exception('reload failed');
      }
      final userReaction = call < 3 ? null : 'brain';
      events.add('details:${userReaction ?? 'none'}');
      return LessonDetailsResponse(
        reactions: LessonReactionResponse(
          counts: const {'love': 1, 'brain': 1},
          userReaction: userReaction,
        ),
        materials: const [],
        reviews: const [],
      );
    });
    when(
      () => scheduleRepository.postLessonReaction(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
        reactionType: any(named: 'reactionType'),
      ),
    ).thenAnswer((invocation) async {
      final reaction = invocation.namedArguments[#reactionType]! as String;
      events.add('start:$reaction');
      if (reaction == 'love') {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      events.add('end:$reaction');
    });
    when(
      () => scheduleRepository.deleteLessonReaction(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
      ),
    ).thenAnswer((_) async {
      events.add('delete');
    });
    when(
      friendsRepository.getGroupMembers,
    ).thenAnswer((_) async => GroupRoster.empty);

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
      dates: [DateTime(2026, 6, 12)],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ScheduleRepository>.value(
              value: scheduleRepository,
            ),
            RepositoryProvider<FriendsRepository>.value(
              value: friendsRepository,
            ),
            RepositoryProvider<CampusRepository>.value(
              value: campusRepository,
            ),
          ],
          child: ScheduleDetailsPage(
            lesson: lesson,
            selectedDate: DateTime(2026, 6, 12),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Finder reaction(String type) =>
        find.byKey(ValueKey('lesson-reaction-$type'));
    expect(reaction('love'), findsOneWidget);
    expect(reaction('brain'), findsOneWidget);
    tester.widget<AppChip>(reaction('love')).onTap?.call();
    tester.widget<AppChip>(reaction('love')).onTap?.call();
    tester.widget<AppChip>(reaction('brain')).onTap?.call();
    await tester.pumpAndSettle();

    expect(events, [
      'details:none',
      'start:love',
      'end:love',
      'details:error',
      'delete',
      'details:none',
      'start:brain',
      'end:brain',
      'details:brain',
    ]);
  });
}

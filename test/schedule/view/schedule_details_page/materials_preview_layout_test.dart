import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'mock_schedule_repository.dart';

void main() {
  testWidgets('materials empty card fills the section width', (tester) async {
    final scheduleRepository = MockScheduleRepository();
    final friendsRepository = MockFriendsRepository();
    final campusRepository = MockCampusRepository();
    when(
      () => scheduleRepository.getLessonDetails(
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
    when(
      friendsRepository.getGroupMembers,
    ).thenAnswer((_) async => GroupRoster.empty);
    final lesson = LessonSchedulePart(
      subject: 'Логика',
      lessonType: .lecture,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        number: 1,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      ),
      dates: [DateTime(2026, 8, 30)],
    );

    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ScheduleRepository>.value(
            value: scheduleRepository,
          ),
          RepositoryProvider<FriendsRepository>.value(
            value: friendsRepository,
          ),
          RepositoryProvider<CampusRepository>.value(value: campusRepository),
        ],
        child: ScheduleDetailsPage(
          lesson: lesson,
          selectedDate: DateTime(2026, 8, 30),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Материалов пока нет'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(
      tester.getSize(find.byType(AppEmptyState)).width,
      closeTo(390 - NinjaMetrics.screenPadding * 2, .1),
    );
    expect(tester.takeException(), isNull);
  });
}

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_activity_builder.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

class _Comments extends MockCubit<LessonCommentsState>
    implements LessonCommentsCubit {}

class _Reactions extends MockCubit<LessonReactionsState>
    implements LessonReactionsCubit {}

class _Campus extends Mock implements CampusRepository {}

class _Schedule extends Mock implements ScheduleRepository {}

void main() {
  final day = DateTime(2026, 9, 2);
  final lesson = scheduleTestLesson();
  late _Comments comments;
  late _Reactions reactions;
  LessonComment note({DateTime? date, String text = 'Bring the workbook'}) =>
      LessonComment(
        subjectName: lesson.subject,
        lessonDate: date ?? day,
        lessonBells: lesson.lessonBells,
        text: text,
      );
  LessonReactionSummary summary({DateTime? date}) => LessonReactionSummary(
    subjectName: lesson.subject,
    lessonDate: date ?? day,
    lessonBells: lesson.lessonBells,
    reactionCounts: const ReactionCounts(fire: 10, brain: 2, love: 3),
    userReaction: ReactionType.brain,
  );

  setUp(() {
    comments = _Comments();
    reactions = _Reactions();
    when(() => comments.state).thenReturn(const LessonCommentsState());
    when(() => reactions.state).thenReturn(const LessonReactionsState());
    when(() => comments.isClosed).thenReturn(false);
    when(
      () => reactions.ensureSummary(
        subjectName: lesson.subject,
        lessonDate: day,
        lessonBells: lesson.lessonBells,
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester, {
    double scale = 1,
    DateTime? selectedDay,
  }) => tester.pumpApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CampusRepository>.value(value: _Campus()),
        RepositoryProvider<ScheduleRepository>.value(value: _Schedule()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LessonCommentsCubit>.value(value: comments),
          BlocProvider<LessonReactionsCubit>.value(value: reactions),
        ],
        child: Scaffold(
          body: SingleChildScrollView(
            child: LessonActivityBuilder(
              lesson: lesson,
              day: selectedDay ?? day,
              builder: (context, annotations) => AppLessonRow(
                title: lesson.subject,
                time: '09:00',
                typeLabel: 'ЛЕК',
                scheduleStyle: true,
                annotations: annotations,
                onTap: () => fail('The note marker must not open the lesson'),
              ),
            ),
          ),
        ),
      ),
    ),
    size: const Size(320, 844),
    textScaler: TextScaler.linear(scale),
  );

  testWidgets('empty activity adds no markers or card space', (tester) async {
    await pump(tester);
    final row = tester.widget<AppLessonRow>(find.byType(AppLessonRow));
    expect(row.annotations, isEmpty);
    verify(
      () => reactions.ensureSummary(
        subjectName: lesson.subject,
        lessonDate: day,
        lessonBells: lesson.lessonBells,
      ),
    ).called(1);
  });

  testWidgets('other dates and blank notes do not leak into the card', (
    tester,
  ) async {
    when(() => comments.state).thenReturn(
      LessonCommentsState(
        comments: [
          note(date: day.add(const Duration(days: 7))),
          note(text: '  '),
        ],
      ),
    );
    when(() => reactions.state).thenReturn(
      LessonReactionsState(
        summaries: [
          summary(date: day.add(const Duration(days: 7))),
        ],
      ),
    );
    await pump(tester);
    expect(
      tester.widget<AppLessonRow>(find.byType(AppLessonRow)).annotations,
      isEmpty,
    );
  });

  testWidgets(
    'recycled card selects the new slot without waiting for a stream event',
    (tester) async {
      when(
        () => comments.state,
      ).thenReturn(LessonCommentsState(comments: [note()]));
      when(
        () => reactions.state,
      ).thenReturn(LessonReactionsState(summaries: [summary()]));
      final next = day.add(const Duration(days: 7));
      when(
        () => reactions.ensureSummary(
          subjectName: lesson.subject,
          lessonDate: next,
          lessonBells: lesson.lessonBells,
        ),
      ).thenAnswer((_) async {});
      await pump(tester);
      expect(find.text('🧠🔥 15'), findsOneWidget);
      await pump(tester, selectedDay: next);
      expect(
        tester.widget<AppLessonRow>(find.byType(AppLessonRow)).annotations,
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets('compact activity fits 320px at scale $scale', (tester) async {
      when(
        () => comments.state,
      ).thenReturn(LessonCommentsState(comments: [note()]));
      when(
        () => reactions.state,
      ).thenReturn(LessonReactionsState(summaries: [summary()]));
      await pump(tester, scale: scale);
      expect(find.text('🧠🔥 15'), findsOneWidget);
      final marker = find.byKey(const ValueKey('lesson-note-marker'));
      expect(tester.getSize(marker).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(marker).height, greaterThanOrEqualTo(44));
      expect(tester.takeException(), isNull);
      await tester.tap(marker);
      await tester.pumpAndSettle();
      expect(find.text('Bring the workbook'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('removing a note and reactions updates the same card', (
    tester,
  ) async {
    final noteStream = StreamController<LessonCommentsState>();
    final reactionStream = StreamController<LessonReactionsState>();
    addTearDown(noteStream.close);
    addTearDown(reactionStream.close);
    whenListen(
      comments,
      noteStream.stream,
      initialState: LessonCommentsState(comments: [note()]),
    );
    whenListen(
      reactions,
      reactionStream.stream,
      initialState: LessonReactionsState(summaries: [summary()]),
    );
    await pump(tester);
    expect(find.text('🧠🔥 15'), findsOneWidget);
    noteStream.add(const LessonCommentsState());
    reactionStream.add(const LessonReactionsState());
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppLessonRow>(find.byType(AppLessonRow)).annotations,
      isEmpty,
    );
  });
}

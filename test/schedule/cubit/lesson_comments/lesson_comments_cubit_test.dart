import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/lesson_comments/lesson_comments_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'mock_storage.dart';

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(
      () => storage.write(any(), any<Object?>()),
    ).thenAnswer((_) => Future<void>.value());
    when(
      () => storage.delete(any()),
    ).thenAnswer((_) => Future<void>.value());
    HydratedBloc.storage = storage;
  });

  group('LessonCommentsCubit', () {
    final bells = LessonBells(
      number: 1,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    );
    final lessonDate = DateTime(2026, 6, 12);

    LessonComment commentWith(String text, {String subject = 'Матан'}) => .new(
      subjectName: subject,
      lessonDate: lessonDate,
      lessonBells: bells,
      text: text,
    );

    test('initial state is LessonCommentsState()', () {
      expect(
        LessonCommentsCubit().state,
        equals(const LessonCommentsState()),
      );
    });

    group('setLessonComment', () {
      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'adds a new comment for an empty slot',
        build: LessonCommentsCubit.new,
        act: (cubit) => cubit.setLessonComment(commentWith('Контрольная')),
        expect: () => [
          LessonCommentsState(comments: [commentWith('Контрольная')]),
        ],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'replaces the existing comment for the same slot',
        build: LessonCommentsCubit.new,
        seed: () => LessonCommentsState(comments: [commentWith('Старый')]),
        act: (cubit) => cubit.setLessonComment(commentWith('Новый')),
        expect: () => [
          LessonCommentsState(comments: [commentWith('Новый')]),
        ],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'removes the comment when the new text is empty',
        build: LessonCommentsCubit.new,
        seed: () => LessonCommentsState(comments: [commentWith('Старый')]),
        act: (cubit) => cubit.setLessonComment(commentWith('')),
        expect: () => const [LessonCommentsState()],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'emits nothing for an empty comment on an empty slot',
        build: LessonCommentsCubit.new,
        act: (cubit) => cubit.setLessonComment(commentWith('')),
        expect: () => const <LessonCommentsState>[],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'keeps comments for different subjects in the same time slot',
        build: LessonCommentsCubit.new,
        seed: () => LessonCommentsState(
          comments: [commentWith('Формулы')],
        ),
        act: (cubit) => cubit.setLessonComment(
          commentWith('Лабораторная', subject: 'Физика'),
        ),
        expect: () => [
          LessonCommentsState(
            comments: [
              commentWith('Формулы'),
              commentWith('Лабораторная', subject: 'Физика'),
            ],
          ),
        ],
      );
    });

    group('setScheduleComment', () {
      const comment = ScheduleComment(scheduleName: 'ИКБО-01', text: 'Заметка');

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'adds a comment for a new schedule',
        build: LessonCommentsCubit.new,
        act: (cubit) => cubit.setScheduleComment(comment),
        expect: () => const [
          LessonCommentsState(scheduleComments: [comment]),
        ],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'replaces the comment for an existing schedule',
        build: LessonCommentsCubit.new,
        seed: () => const LessonCommentsState(
          scheduleComments: [
            ScheduleComment(scheduleName: 'ИКБО-01', text: 'Старая'),
          ],
        ),
        act: (cubit) => cubit.setScheduleComment(comment),
        expect: () => const [
          LessonCommentsState(scheduleComments: [comment]),
        ],
      );
    });

    group('removeScheduleComment', () {
      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'removes the comment for the given schedule',
        build: LessonCommentsCubit.new,
        seed: () => const LessonCommentsState(
          scheduleComments: [
            ScheduleComment(scheduleName: 'ИКБО-01', text: 'Заметка'),
            ScheduleComment(scheduleName: 'ИКБО-02', text: 'Другая'),
          ],
        ),
        act: (cubit) => cubit.removeScheduleComment('ИКБО-01'),
        expect: () => const [
          LessonCommentsState(
            scheduleComments: [
              ScheduleComment(scheduleName: 'ИКБО-02', text: 'Другая'),
            ],
          ),
        ],
      );

      blocTest<LessonCommentsCubit, LessonCommentsState>(
        'emits nothing when the schedule has no comment',
        build: LessonCommentsCubit.new,
        seed: () => const LessonCommentsState(
          scheduleComments: [
            ScheduleComment(scheduleName: 'ИКБО-02', text: 'Другая'),
          ],
        ),
        act: (cubit) => cubit.removeScheduleComment('ИКБО-01'),
        expect: () => const <LessonCommentsState>[],
      );
    });

    test('toJson/fromJson round-trips comments and schedule comments', () {
      final cubit = LessonCommentsCubit()
        ..setLessonComment(commentWith('Контрольная'))
        ..setScheduleComment(
          const ScheduleComment(scheduleName: 'ИКБО-01', text: 'Заметка'),
        );
      final json = cubit.toJson(cubit.state);
      expect(cubit.fromJson(json), equals(cubit.state));
    });
  });
}

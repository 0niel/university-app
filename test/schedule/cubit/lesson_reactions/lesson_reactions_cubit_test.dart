import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/lesson_reactions/lesson_reactions_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'mock_schedule_repository.dart';

void main() {
  late Storage storage;
  late ScheduleRepository scheduleRepository;

  final bells = LessonBells(
    number: 1,
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 30),
  );
  final lessonDate = DateTime(2026, 6, 12);
  final mutationEvents = <String>[];

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
  });

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

    scheduleRepository = MockScheduleRepository();
    when(
      () => scheduleRepository.postLessonReaction(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
        reactionType: any(named: 'reactionType'),
      ),
    ).thenAnswer((_) => Future<void>.value());
    when(
      () => scheduleRepository.deleteLessonReaction(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
      ),
    ).thenAnswer((_) => Future<void>.value());
    when(
      () => scheduleRepository.getLessonReactionSummary(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
      ),
    ).thenAnswer(
      (_) async => const LessonReactionResponse(counts: {}),
    );
  });

  LessonReactionsCubit buildCubit() =>
      .new(scheduleRepository: scheduleRepository);

  LessonReactionSummary summaryWith({
    required ReactionCounts counts,
    ReactionType? userReaction,
  }) => .new(
    subjectName: 'Матан',
    lessonDate: lessonDate,
    lessonBells: bells,
    reactionCounts: counts,
    userReaction: userReaction,
  );

  group('LessonReactionsCubit', () {
    test('initial state is LessonReactionsState()', () {
      expect(buildCubit().state, equals(const LessonReactionsState()));
    });

    group('loadSummary', () {
      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'loads real aggregate counts and the current user reaction',
        setUp: () =>
            when(
              () => scheduleRepository.getLessonReactionSummary(
                subjectName: any(named: 'subjectName'),
                lessonDate: any(named: 'lessonDate'),
                lessonBellsNumber: any(named: 'lessonBellsNumber'),
              ),
            ).thenAnswer(
              (_) async => const LessonReactionResponse(
                counts: {'love': 4, 'brain': 2},
                userReaction: 'love',
              ),
            ),
        build: buildCubit,
        act: (cubit) => cubit.loadSummary(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        expect: () => [
          LessonReactionsState(
            summaries: [
              summaryWith(
                counts: const ReactionCounts(love: 4, brain: 2),
                userReaction: .love,
              ),
            ],
          ),
        ],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'reports repository failures without replacing cached data',
        setUp: () => when(
          () => scheduleRepository.getLessonReactionSummary(
            subjectName: any(named: 'subjectName'),
            lessonDate: any(named: 'lessonDate'),
            lessonBellsNumber: any(named: 'lessonBellsNumber'),
          ),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        seed: () => LessonReactionsState(
          summaries: [
            summaryWith(counts: const ReactionCounts(love: 1)),
          ],
        ),
        act: (cubit) => cubit.loadSummary(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        expect: () => const <LessonReactionsState>[],
        errors: () => [isA<Exception>()],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'does not let an older load overwrite a newer reaction',
        setUp: () {
          final completer = Completer<LessonReactionResponse>();
          when(
            () => scheduleRepository.getLessonReactionSummary(
              subjectName: any(named: 'subjectName'),
              lessonDate: any(named: 'lessonDate'),
              lessonBellsNumber: any(named: 'lessonBellsNumber'),
            ),
          ).thenAnswer((_) => completer.future);
          when(
            () => scheduleRepository.postLessonReaction(
              subjectName: any(named: 'subjectName'),
              lessonDate: any(named: 'lessonDate'),
              lessonBellsNumber: any(named: 'lessonBellsNumber'),
              reactionType: any(named: 'reactionType'),
            ),
          ).thenAnswer((_) async {
            completer.complete(
              const LessonReactionResponse(counts: {'brain': 8}),
            );
          });
        },
        build: buildCubit,
        act: (cubit) async {
          final load = cubit.loadSummary(
            subjectName: 'Матан',
            lessonDate: lessonDate,
            lessonBells: bells,
          );
          await cubit.addReaction(
            subjectName: 'Матан',
            lessonDate: lessonDate,
            lessonBells: bells,
            reactionType: .love,
          );
          await load;
        },
        expect: () => [
          LessonReactionsState(
            summaries: [
              summaryWith(
                counts: const ReactionCounts(love: 1),
                userReaction: .love,
              ),
            ],
          ),
        ],
      );
    });

    blocTest<LessonReactionsCubit, LessonReactionsState>(
      'serializes mutations so the server and local state keep tap order',
      setUp: () {
        mutationEvents.clear();
        when(
          () => scheduleRepository.postLessonReaction(
            subjectName: any(named: 'subjectName'),
            lessonDate: any(named: 'lessonDate'),
            lessonBellsNumber: any(named: 'lessonBellsNumber'),
            reactionType: any(named: 'reactionType'),
          ),
        ).thenAnswer((invocation) async {
          final reaction = invocation.namedArguments[#reactionType]! as String;
          mutationEvents.add('start:$reaction');
          if (reaction == 'love') {
            await Future<void>.delayed(const Duration(milliseconds: 20));
          }
          mutationEvents.add('end:$reaction');
        });
      },
      build: buildCubit,
      act: (cubit) async {
        final first = cubit.addReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
          reactionType: .love,
        );
        final second = cubit.addReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
          reactionType: .brain,
        );
        await Future.wait([first, second]);
      },
      expect: () => [
        LessonReactionsState(
          summaries: [
            summaryWith(
              counts: const ReactionCounts(brain: 1),
              userReaction: .brain,
            ),
          ],
        ),
      ],
      verify: (_) {
        expect(mutationEvents, [
          'start:love',
          'end:love',
          'start:brain',
          'end:brain',
        ]);
        verifyInOrder([
          () => scheduleRepository.postLessonReaction(
            subjectName: 'Матан',
            lessonDate: lessonDate,
            lessonBellsNumber: 1,
            reactionType: 'love',
          ),
          () => scheduleRepository.postLessonReaction(
            subjectName: 'Матан',
            lessonDate: lessonDate,
            lessonBellsNumber: 1,
            reactionType: 'brain',
          ),
        ]);
      },
    );

    group('addReaction', () {
      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'inserts a new summary when none exists for the slot',
        build: buildCubit,
        act: (cubit) => cubit.addReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
          reactionType: .love,
        ),
        verify: (_) {
          verify(
            () => scheduleRepository.postLessonReaction(
              subjectName: 'Матан',
              lessonDate: lessonDate,
              lessonBellsNumber: 1,
              reactionType: ReactionType.love.name,
            ),
          ).called(1);
        },
        expect: () => [
          LessonReactionsState(
            summaries: [
              summaryWith(
                counts: const ReactionCounts(love: 1),
                userReaction: .love,
              ),
            ],
          ),
        ],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'switches the user reaction on an existing summary',
        build: buildCubit,
        seed: () => LessonReactionsState(
          summaries: [
            summaryWith(
              counts: const ReactionCounts(love: 1),
              userReaction: .love,
            ),
          ],
        ),
        act: (cubit) => cubit.addReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
          reactionType: .brain,
        ),
        expect: () => [
          LessonReactionsState(
            summaries: [
              summaryWith(
                counts: const ReactionCounts(brain: 1),
                userReaction: .brain,
              ),
            ],
          ),
        ],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'reports the error and emits nothing when the repository throws',
        setUp: () => when(
          () => scheduleRepository.postLessonReaction(
            subjectName: any(named: 'subjectName'),
            lessonDate: any(named: 'lessonDate'),
            lessonBellsNumber: any(named: 'lessonBellsNumber'),
            reactionType: any(named: 'reactionType'),
          ),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        act: (cubit) => cubit.addReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
          reactionType: .love,
        ),
        expect: () => const <LessonReactionsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('removeReaction', () {
      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'drops the summary when its last reaction is removed',
        build: buildCubit,
        seed: () => LessonReactionsState(
          summaries: [
            summaryWith(
              counts: const ReactionCounts(love: 1),
              userReaction: .love,
            ),
          ],
        ),
        act: (cubit) => cubit.removeReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        verify: (_) {
          verify(
            () => scheduleRepository.deleteLessonReaction(
              subjectName: 'Матан',
              lessonDate: lessonDate,
              lessonBellsNumber: 1,
            ),
          ).called(1);
        },
        expect: () => const [LessonReactionsState()],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'clears the user reaction while keeping others',
        build: buildCubit,
        seed: () => LessonReactionsState(
          summaries: [
            summaryWith(
              counts: const ReactionCounts(love: 1, brain: 2),
              userReaction: .love,
            ),
          ],
        ),
        act: (cubit) => cubit.removeReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        expect: () => [
          LessonReactionsState(
            summaries: [
              summaryWith(counts: const ReactionCounts(brain: 2)),
            ],
          ),
        ],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'emits nothing when no summary exists for the slot',
        build: buildCubit,
        act: (cubit) => cubit.removeReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        expect: () => const <LessonReactionsState>[],
      );

      blocTest<LessonReactionsCubit, LessonReactionsState>(
        'reports the error and emits nothing when the repository throws',
        setUp: () => when(
          () => scheduleRepository.deleteLessonReaction(
            subjectName: any(named: 'subjectName'),
            lessonDate: any(named: 'lessonDate'),
            lessonBellsNumber: any(named: 'lessonBellsNumber'),
          ),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        seed: () => LessonReactionsState(
          summaries: [
            summaryWith(
              counts: const ReactionCounts(love: 1),
              userReaction: .love,
            ),
          ],
        ),
        act: (cubit) => cubit.removeReaction(
          subjectName: 'Матан',
          lessonDate: lessonDate,
          lessonBells: bells,
        ),
        expect: () => const <LessonReactionsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    test('stores the added reaction in state', () async {
      final cubit = buildCubit();
      await cubit.addReaction(
        subjectName: 'Матан',
        lessonDate: lessonDate,
        lessonBells: bells,
        reactionType: .love,
      );

      expect(
        cubit.state.summaries,
        [
          summaryWith(
            counts: const ReactionCounts(love: 1),
            userReaction: .love,
          ),
        ],
      );
    });

    test('toJson/fromJson round-trips the summaries', () async {
      final cubit = buildCubit();
      await cubit.addReaction(
        subjectName: 'Матан',
        lessonDate: lessonDate,
        lessonBells: bells,
        reactionType: .love,
      );
      final json = cubit.toJson(cubit.state);
      expect(cubit.fromJson(json), equals(cubit.state));
    });
  });
}

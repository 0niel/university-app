import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(PollType.single);
  });

  group('PollsCubit', () {
    late CampusRepository campusRepository;

    const option1 = PollOption(id: 'o-1', text: 'Go', votes: 3);
    const option2 = PollOption(id: 'o-2', text: 'Rust', votes: 1);
    const poll = Poll(
      id: 'p-1',
      question: 'Какой стек учить летом?',
      pollType: PollType.single,
      options: [option1, option2],
      totalVotes: 4,
    );
    const otherPoll = Poll(
      id: 'p-2',
      question: 'Сложность экзамена?',
      pollType: PollType.multi,
      options: [option1, option2],
      isMine: true,
    );
    late List<Poll> polls;

    setUp(() {
      campusRepository = MockCampusRepository();
      polls = const [poll, otherPoll];
      when(() => campusRepository.getPolls()).thenAnswer((_) async => polls);
      when(
        () => campusRepository.votePoll(
          pollId: any(named: 'pollId'),
          optionIds: any(named: 'optionIds'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => campusRepository.createPoll(
          question: any(named: 'question'),
          options: any(named: 'options'),
          type: any(named: 'type'),
          isAnonymous: any(named: 'isAnonymous'),
          showResults: any(named: 'showResults'),
          expiresAt: any(named: 'expiresAt'),
          correctIndex: any(named: 'correctIndex'),
        ),
      ).thenAnswer((_) async {});
      when(() => campusRepository.deletePoll(any())).thenAnswer((_) async {});
    });

    PollsCubit buildCubit() => PollsCubit(campusRepository: campusRepository);

    test('initial state is PollsState with initial status', () {
      expect(buildCubit().state, equals(const PollsState()));
    });

    group('load', () {
      blocTest<PollsCubit, PollsState>(
        'emits [loading, populated] when getPolls succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <PollsState>[
          PollsState(status: PollsStatus.loading),
          PollsState(
            status: PollsStatus.populated,
            polls: [poll, otherPoll],
          ),
        ],
        verify: (_) {
          verify(() => campusRepository.getPolls()).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'emits [loading, failure] and keeps cached polls when getPolls throws',
        setUp: () => when(
          () => campusRepository.getPolls(),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        seed: () => const PollsState(polls: [poll]),
        act: (cubit) => cubit.load(),
        expect: () => const <PollsState>[
          PollsState(status: PollsStatus.loading, polls: [poll]),
          PollsState(status: PollsStatus.failure, polls: [poll]),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('vote', () {
      blocTest<PollsCubit, PollsState>(
        'marks the poll pending, calls votePoll, reloads, then clears '
        'pending',
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.submitVote(poll, [option1.id]),
          isTrue,
        ),
        verify: (_) {
          verify(
            () => campusRepository.votePoll(
              pollId: 'p-1',
              optionIds: ['o-1'],
            ),
          ).called(1);
          verify(() => campusRepository.getPolls()).called(1);
        },
        expect: () => const <PollsState>[
          PollsState(pendingPollIds: {'p-1'}),
          PollsState(status: PollsStatus.loading, pendingPollIds: {'p-1'}),
          PollsState(
            status: PollsStatus.populated,
            polls: [poll, otherPoll],
            pendingPollIds: {'p-1'},
          ),
          PollsState(status: PollsStatus.populated, polls: [poll, otherPoll]),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'submits multiple option ids for multi-choice polls, then reloads',
        build: buildCubit,
        act: (cubit) => cubit.submitVote(otherPoll, ['o-1', 'o-2']),
        verify: (_) {
          verify(
            () => campusRepository.votePoll(
              pollId: 'p-2',
              optionIds: ['o-1', 'o-2'],
            ),
          ).called(1);
          verify(() => campusRepository.getPolls()).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'does nothing when the selection is empty',
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.submitVote(poll, const []),
          isFalse,
        ),
        expect: () => <PollsState>[],
        verify: (_) {
          verifyNever(
            () => campusRepository.votePoll(
              pollId: any(named: 'pollId'),
              optionIds: any(named: 'optionIds'),
            ),
          );
        },
      );

      blocTest<PollsCubit, PollsState>(
        'ignores a second vote for the same poll while the first is still '
        'pending',
        build: buildCubit,
        act: (cubit) async {
          final first = cubit.submitVote(poll, [option1.id]);
          expect(await cubit.submitVote(poll, [option2.id]), isFalse);
          await first;
        },
        verify: (_) {
          verify(
            () => campusRepository.votePoll(
              pollId: 'p-1',
              optionIds: ['o-1'],
            ),
          ).called(1);
          verifyNever(
            () => campusRepository.votePoll(
              pollId: 'p-1',
              optionIds: ['o-2'],
            ),
          );
        },
      );

      blocTest<PollsCubit, PollsState>(
        'reports the error, clears pending and does not reload when '
        'votePoll throws',
        setUp: () => when(
          () => campusRepository.votePoll(
            pollId: any(named: 'pollId'),
            optionIds: any(named: 'optionIds'),
          ),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.submitVote(poll, [option1.id]),
          isFalse,
        ),
        expect: () => const <PollsState>[
          PollsState(pendingPollIds: {'p-1'}),
          PollsState(),
        ],
        errors: () => [isA<Exception>()],
        verify: (_) {
          verifyNever(() => campusRepository.getPolls());
        },
      );
    });

    group('createPoll', () {
      blocTest<PollsCubit, PollsState>(
        'returns true and reloads when createPoll succeeds',
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.createPoll(
            question: 'Любимый язык?',
            options: const ['Dart', 'Kotlin'],
            type: PollType.quiz,
            correctIndex: 0,
          ),
          isTrue,
        ),
        expect: () => const <PollsState>[
          PollsState(status: PollsStatus.loading),
          PollsState(
            status: PollsStatus.populated,
            polls: [poll, otherPoll],
          ),
        ],
        verify: (_) {
          verify(
            () => campusRepository.createPoll(
              question: 'Любимый язык?',
              options: const ['Dart', 'Kotlin'],
              type: PollType.quiz,
              correctIndex: 0,
            ),
          ).called(1);
          verify(() => campusRepository.getPolls()).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'returns false and reports the error when createPoll throws',
        setUp: () => when(
          () => campusRepository.createPoll(
            question: any(named: 'question'),
            options: any(named: 'options'),
            type: any(named: 'type'),
            isAnonymous: any(named: 'isAnonymous'),
            showResults: any(named: 'showResults'),
            expiresAt: any(named: 'expiresAt'),
            correctIndex: any(named: 'correctIndex'),
          ),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.createPoll(
            question: 'Любимый язык?',
            options: const ['Dart', 'Kotlin'],
          ),
          isFalse,
        ),
        expect: () => <PollsState>[],
        errors: () => [isA<Exception>()],
        verify: (_) {
          verifyNever(() => campusRepository.getPolls());
        },
      );
    });

    group('deletePoll', () {
      blocTest<PollsCubit, PollsState>(
        'marks the poll deleting, deletes it, reloads, then clears '
        'deleting',
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.deletePoll(otherPoll),
          isTrue,
        ),
        verify: (_) {
          verify(() => campusRepository.deletePoll('p-2')).called(1);
          verify(() => campusRepository.getPolls()).called(1);
        },
        expect: () => const <PollsState>[
          PollsState(deletingPollIds: {'p-2'}),
          PollsState(status: PollsStatus.loading, deletingPollIds: {'p-2'}),
          PollsState(
            status: PollsStatus.populated,
            polls: [poll, otherPoll],
            deletingPollIds: {'p-2'},
          ),
          PollsState(status: PollsStatus.populated, polls: [poll, otherPoll]),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'ignores a second delete for the same poll while the first is '
        'still in flight',
        build: buildCubit,
        act: (cubit) async {
          final first = cubit.deletePoll(otherPoll);
          expect(await cubit.deletePoll(otherPoll), isFalse);
          await first;
        },
        verify: (_) {
          verify(() => campusRepository.deletePoll('p-2')).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'reports the error, clears deleting and does not reload when '
        'deletePoll throws',
        setUp: () => when(
          () => campusRepository.deletePoll(any()),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        act: (cubit) async => expect(
          await cubit.deletePoll(otherPoll),
          isFalse,
        ),
        expect: () => const <PollsState>[
          PollsState(deletingPollIds: {'p-2'}),
          PollsState(),
        ],
        errors: () => [isA<Exception>()],
        verify: (_) {
          verifyNever(() => campusRepository.getPolls());
        },
      );
    });
  });
}

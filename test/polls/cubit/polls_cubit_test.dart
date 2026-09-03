import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(PollFilter.all);
    registerFallbackValue(PollCategory.academic);
    registerFallbackValue(PollResultsVisibility.always);
    registerFallbackValue(const <PollAnswer>[]);
    registerFallbackValue(const <PollQuestionDraft>[]);
  });

  group('PollsCubit', () {
    late CampusRepository campusRepository;

    const option1 = PollOption(id: 'o-1', text: 'Go', votes: 3);
    const option2 = PollOption(id: 'o-2', text: 'Rust', votes: 1);
    const question = PollQuestion(
      id: 'q-1',
      text: 'Какой стек учить летом?',
      kind: PollQuestionKind.single,
      options: [option1, option2],
    );
    const poll = Poll(
      id: 'p-1',
      title: 'Стек',
      isMine: true,
      questions: [question],
      participantsCount: 4,
    );
    const otherPoll = Poll(
      id: 'p-2',
      title: 'Сложность экзамена?',
      isMine: true,
      questions: [question],
    );
    late List<Poll> polls;

    setUp(() {
      campusRepository = MockCampusRepository();
      polls = const [poll, otherPoll];
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => polls);
      when(
        () => campusRepository.closePoll(any()),
      ).thenAnswer((_) async => poll.copyWith(isClosed: true));
      when(
        () => campusRepository.deletePoll(any()),
      ).thenAnswer((_) async {});
      when(
        () => campusRepository.submitPollAnswers(
          pollId: any(named: 'pollId'),
          answers: any(named: 'answers'),
        ),
      ).thenAnswer((_) async => poll.copyWith(iParticipated: true));
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
          PollsState(status: PollsStatus.populated, polls: [poll, otherPoll]),
        ],
        verify: (_) {
          verify(() => campusRepository.getPolls()).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'emits [loading, failure] and keeps cached polls when getPolls '
        'throws',
        setUp: () => when(
          () => campusRepository.getPolls(
            filter: any(named: 'filter'),
            category: any(named: 'category'),
            query: any(named: 'query'),
          ),
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

    group('filters', () {
      blocTest<PollsCubit, PollsState>(
        'setFilter updates the filter and reloads with it',
        build: buildCubit,
        act: (cubit) => cubit.setFilter(PollFilter.mine),
        verify: (_) {
          verify(
            () => campusRepository.getPolls(filter: PollFilter.mine),
          ).called(1);
        },
        expect: () => const <PollsState>[
          PollsState(filter: PollFilter.mine),
          PollsState(filter: PollFilter.mine, status: PollsStatus.loading),
          PollsState(
            filter: PollFilter.mine,
            status: PollsStatus.populated,
            polls: [poll, otherPoll],
          ),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'setFilter is a no-op when the filter is unchanged',
        build: buildCubit,
        act: (cubit) => cubit.setFilter(PollFilter.all),
        expect: () => const <PollsState>[],
      );

      blocTest<PollsCubit, PollsState>(
        'setCategory updates the category and reloads with it',
        build: buildCubit,
        act: (cubit) => cubit.setCategory(PollCategory.academic),
        verify: (_) {
          verify(
            () => campusRepository.getPolls(category: PollCategory.academic),
          ).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'setQuery debounces before reloading with the trimmed query',
        build: buildCubit,
        act: (cubit) async {
          cubit
            ..setQuery('s')
            ..setQuery('st')
            ..setQuery(' stack ');
          await Future<void>.delayed(const Duration(milliseconds: 500));
        },
        verify: (_) {
          verify(
            () => campusRepository.getPolls(query: 'stack'),
          ).called(1);
        },
      );
    });

    group('createPoll', () {
      blocTest<PollsCubit, PollsState>(
        'prepends the created poll on success',
        setUp: () => when(
          () => campusRepository.createPoll(
            title: any(named: 'title'),
            questions: any(named: 'questions'),
            description: any(named: 'description'),
            category: any(named: 'category'),
            isAnonymous: any(named: 'isAnonymous'),
            resultsVisibility: any(named: 'resultsVisibility'),
            expiresAt: any(named: 'expiresAt'),
            allowChange: any(named: 'allowChange'),
          ),
        ).thenAnswer((_) async => poll),
        build: buildCubit,
        act: (cubit) async {
          final created = await cubit.createPoll(
            title: 'Стек',
            questions: const [
              PollQuestionDraft(
                text: 'Какой стек?',
                kind: PollQuestionKind.single,
                options: ['Go', 'Rust'],
              ),
            ],
          );
          expect(created, isNotNull);
        },
        expect: () => const <PollsState>[
          PollsState(status: PollsStatus.populated, polls: [poll]),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'returns null and reports the error when createPoll throws',
        setUp: () => when(
          () => campusRepository.createPoll(
            title: any(named: 'title'),
            questions: any(named: 'questions'),
            description: any(named: 'description'),
            category: any(named: 'category'),
            isAnonymous: any(named: 'isAnonymous'),
            resultsVisibility: any(named: 'resultsVisibility'),
            expiresAt: any(named: 'expiresAt'),
            allowChange: any(named: 'allowChange'),
          ),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        act: (cubit) async {
          final created = await cubit.createPoll(
            title: 'Стек',
            questions: const [
              PollQuestionDraft(text: 'Стек?', kind: PollQuestionKind.text),
            ],
          );
          expect(created, isNull);
        },
        expect: () => <PollsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('submitAnswers', () {
      blocTest<PollsCubit, PollsState>(
        'applies confirmed participation',
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) => cubit.submitAnswers(
          poll: poll,
          answers: const [
            PollAnswer(questionId: 'q-1', optionIds: ['o-1']),
          ],
        ),
        expect: () => <PollsState>[
          PollsState(
            status: PollsStatus.populated,
            polls: [poll.copyWith(iParticipated: true), otherPoll],
          ),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'keeps the current list when submitPollAnswers throws',
        setUp: () => when(
          () => campusRepository.submitPollAnswers(
            pollId: any(named: 'pollId'),
            answers: any(named: 'answers'),
          ),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) => cubit.submitAnswers(
          poll: poll,
          answers: const [
            PollAnswer(questionId: 'q-1', optionIds: ['o-1']),
          ],
        ),
        expect: () => <PollsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('closePoll', () {
      blocTest<PollsCubit, PollsState>(
        'closes the poll after server confirmation',
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) async => expect(await cubit.closePoll(poll), isTrue),
        expect: () => <PollsState>[
          PollsState(
            status: PollsStatus.populated,
            polls: [poll.copyWith(isClosed: true), otherPoll],
          ),
        ],
      );

      blocTest<PollsCubit, PollsState>(
        'keeps the current list when closePoll throws',
        setUp: () => when(
          () => campusRepository.closePoll(any()),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) async => expect(await cubit.closePoll(poll), isFalse),
        expect: () => <PollsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('deletePoll', () {
      blocTest<PollsCubit, PollsState>(
        'removes the poll after server confirmation',
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) async => expect(await cubit.deletePoll(otherPoll), isTrue),
        expect: () => const <PollsState>[
          PollsState(status: PollsStatus.populated, polls: [poll]),
        ],
        verify: (_) {
          verify(() => campusRepository.deletePoll('p-2')).called(1);
        },
      );

      blocTest<PollsCubit, PollsState>(
        'keeps the current list when deletePoll throws',
        setUp: () => when(
          () => campusRepository.deletePoll(any()),
        ).thenThrow(Exception('rls')),
        build: buildCubit,
        seed: () => const PollsState(
          status: PollsStatus.populated,
          polls: [poll, otherPoll],
        ),
        act: (cubit) async =>
            expect(await cubit.deletePoll(otherPoll), isFalse),
        expect: () => const <PollsState>[],
        errors: () => [isA<Exception>()],
      );
    });
  });
}

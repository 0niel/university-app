import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class _Repository extends Mock implements CampusRepository {}

const question = PollQuestion(
  id: 'q',
  text: 'Choose',
  kind: PollQuestionKind.single,
  options: [
    PollOption(id: 'a', text: 'A'),
    PollOption(id: 'b', text: 'B'),
  ],
);
const poll = Poll(id: 'p', title: 'Poll', isMine: true, questions: [question]);
const answers = [
  PollAnswer(questionId: 'q', optionIds: ['a']),
];

void main() {
  late _Repository repository;
  late PollsCubit cubit;
  setUpAll(() {
    registerFallbackValue(PollFilter.all);
    registerFallbackValue(const <PollAnswer>[]);
    registerFallbackValue(PollCategory.general);
    registerFallbackValue(PollResultsVisibility.always);
  });
  setUp(() {
    repository = _Repository();
    when(
      () => repository.getPolls(
        filter: any(named: 'filter'),
        category: any(named: 'category'),
        query: any(named: 'query'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => [poll]);
    cubit = PollsCubit(campusRepository: repository);
  });
  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });

  test('loads and retains cached polls when refresh fails', () async {
    expect(cubit.state, const PollsState());
    await cubit.load();
    expect(cubit.state.polls, [poll]);
    when(() => repository.getPolls()).thenThrow(Exception('offline'));
    await cubit.load();
    expect(cubit.state.status, PollsStatus.failure);
    expect(cubit.state.polls, [poll]);
  });

  test('latest filters win over an older response', () async {
    final old = Completer<List<Poll>>();
    when(() => repository.getPolls()).thenAnswer((_) => old.future);
    final first = cubit.load();
    cubit
      ..setFilter(PollFilter.mine)
      ..setCategory(PollCategory.academic)
      ..setQuery('  topic  ');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    old.complete([poll.copyWith(id: 'stale')]);
    await first;
    expect(cubit.state.polls, [poll]);
    verify(
      () => repository.getPolls(
        filter: PollFilter.mine,
        category: PollCategory.academic,
        query: 'topic',
      ),
    ).called(1);
  });

  test('paginates and deduplicates ids', () async {
    final page = List.generate(20, (index) => poll.copyWith(id: '$index'));
    when(() => repository.getPolls()).thenAnswer((_) async => page);
    when(
      () => repository.getPolls(offset: 20),
    ).thenAnswer((_) async => [page.last, poll]);
    await cubit.load();
    expect(cubit.hasMore, isTrue);
    await cubit.load(more: true);
    expect(cubit.state.polls.length, 21);
    expect(cubit.hasMore, isFalse);
  });

  test('create after refresh does not count the same poll twice', () async {
    const draft = [
      PollQuestionDraft(text: 'Question', kind: PollQuestionKind.text),
    ];
    final pending = Completer<Poll>();
    when(
      () => repository.createPoll(title: 'Title', questions: draft),
    ).thenAnswer((_) => pending.future);
    when(() => repository.getPolls()).thenAnswer(
      (_) async => [
        poll,
        ...List.generate(19, (index) => poll.copyWith(id: '$index')),
      ],
    );
    final creating = cubit.createPoll(title: 'Title', questions: draft);
    await cubit.load();
    pending.complete(poll);
    expect(await creating, poll);
    expect(cubit.state.polls.length, 20);
    when(() => repository.getPolls(offset: 20)).thenAnswer((_) async => []);
    await cubit.load(more: true);
    verify(() => repository.getPolls(offset: 20)).called(1);
    verifyNever(() => repository.getPolls(offset: 21));
  });

  test('submits all answers once and uses server result', () async {
    final pending = Completer<Poll>();
    when(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).thenAnswer((_) => pending.future);
    await cubit.load();
    final first = cubit.submitAnswers(poll: poll, answers: answers);
    expect(cubit.isPending('p'), isTrue);
    expect(await cubit.submitAnswers(poll: poll, answers: answers), isNull);
    pending.complete(poll.copyWith(iParticipated: true, canSeeResults: true));
    expect(await first, isNotNull);
    expect(cubit.state.polls.single.iParticipated, isTrue);
    expect(cubit.isPending('p'), isFalse);
    verify(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).called(1);
  });

  test('failed vote clears pending and preserves data', () async {
    when(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).thenThrow(Exception('offline'));
    await cubit.load();
    expect(await cubit.submitAnswers(poll: poll, answers: answers), isNull);
    expect(cubit.state.polls, [poll]);
    expect(cubit.isPending('p'), isFalse);
  });

  test('does not submit closed, expired or immutable answered polls', () async {
    expect(
      await cubit.submitAnswers(
        poll: poll.copyWith(isClosed: true),
        answers: answers,
      ),
      isNull,
    );
    expect(
      await cubit.submitAnswers(
        poll: poll.copyWith(expiresAt: DateTime(2000)),
        answers: answers,
      ),
      isNull,
    );
    expect(
      await cubit.submitAnswers(
        poll: poll.copyWith(iParticipated: true),
        answers: answers,
      ),
      isNull,
    );
    verifyNever(
      () => repository.submitPollAnswers(
        pollId: any(named: 'pollId'),
        answers: any(named: 'answers'),
      ),
    );
  });

  test('allows answer changes when enabled', () async {
    final editable = poll.copyWith(iParticipated: true, allowChange: true);
    when(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).thenAnswer((_) async => editable);
    expect(
      await cubit.submitAnswers(poll: editable, answers: answers),
      isNotNull,
    );
  });

  test('completing an operation after disposal does not emit', () async {
    final pending = Completer<Poll>();
    when(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).thenAnswer((_) => pending.future);
    final operation = cubit.submitAnswers(poll: poll, answers: answers);
    await cubit.close();
    pending.complete(poll);
    expect(await operation, isNotNull);
  });

  test(
    'creates quiz and multiple questions without dropping settings',
    () async {
      const drafts = [
        PollQuestionDraft(
          text: 'Quiz',
          kind: PollQuestionKind.quiz,
          options: ['A', 'B'],
          correctIndex: 1,
        ),
        PollQuestionDraft(
          text: 'Why?',
          kind: PollQuestionKind.text,
          isRequired: false,
        ),
      ];
      when(
        () => repository.createPoll(
          title: 'Title',
          description: 'Description',
          category: PollCategory.feedback,
          questions: drafts,
          isAnonymous: true,
          resultsVisibility: PollResultsVisibility.afterClose,
          allowChange: true,
        ),
      ).thenAnswer((_) async => poll);
      expect(
        await cubit.createPoll(
          title: 'Title',
          description: 'Description',
          category: PollCategory.feedback,
          questions: drafts,
          isAnonymous: true,
          resultsVisibility: PollResultsVisibility.afterClose,
          allowChange: true,
        ),
        isNotNull,
      );
      verify(
        () => repository.createPoll(
          title: 'Title',
          description: 'Description',
          category: PollCategory.feedback,
          questions: drafts,
          isAnonymous: true,
          resultsVisibility: PollResultsVisibility.afterClose,
          allowChange: true,
        ),
      ).called(1);
    },
  );

  test(
    'close is owner-only and removes ended poll from active filter',
    () async {
      when(
        () => repository.closePoll('p'),
      ).thenAnswer((_) async => poll.copyWith(isClosed: true));
      expect(await cubit.closePoll(poll.copyWith(isMine: false)), isFalse);
      cubit.setFilter(PollFilter.active);
      await Future<void>.delayed(Duration.zero);
      expect(await cubit.closePoll(poll), isTrue);
      expect(cubit.state.polls, isEmpty);
      expect(cubit.isPending('p'), isFalse);
    },
  );

  test('delete is owner-only and clears progress after failure', () async {
    when(() => repository.deletePoll('p')).thenThrow(Exception('offline'));
    expect(await cubit.deletePoll(poll.copyWith(isMine: false)), isFalse);
    expect(await cubit.deletePoll(poll), isFalse);
    expect(cubit.isPending('p'), isFalse);
    verify(() => repository.deletePoll('p')).called(1);
  });

  test(
    'validates every question and prevents duplicate or foreign answers',
    () {
      final form = poll.copyWith(
        questions: [
          question,
          question.copyWith(id: 'multi', kind: PollQuestionKind.multiple),
          const PollQuestion(
            id: 'text',
            text: 'Why?',
            kind: PollQuestionKind.text,
          ),
          const PollQuestion(
            id: 'rating',
            text: 'Rate',
            kind: PollQuestionKind.rating,
          ),
        ],
      );
      const complete = [
        ...answers,
        PollAnswer(questionId: 'multi', optionIds: ['a', 'b']),
        PollAnswer(questionId: 'text', text: 'Useful'),
        PollAnswer(questionId: 'rating', rating: 5),
      ];
      expect(validPollAnswers(form, complete), isTrue);
      expect(validPollAnswers(form, answers), isFalse);
      expect(validPollAnswers(poll, [...answers, ...answers]), isFalse);
      expect(
        validPollAnswers(poll, const [
          PollAnswer(questionId: 'q', optionIds: ['unknown']),
        ]),
        isFalse,
      );
      expect(
        validPollAnswers(poll, const [
          PollAnswer(questionId: 'q', optionIds: ['a', 'b']),
        ]),
        isFalse,
      );
      expect(
        validPollAnswers(form, [
          ...complete.take(3),
          const PollAnswer(questionId: 'rating', rating: 6),
        ]),
        isFalse,
      );
    },
  );

  test('optional answers may be blank but cannot submit an empty survey', () {
    final optional = poll.copyWith(
      questions: [question.copyWith(isRequired: false)],
    );
    expect(
      validPollAnswers(optional, const [PollAnswer(questionId: 'q')]),
      isFalse,
    );
    expect(validPollAnswers(optional, answers), isTrue);
  });

  test('state copy preserves fields and can clear nullable category', () {
    const original = PollsState(
      status: PollsStatus.populated,
      polls: [poll],
      filter: PollFilter.mine,
      category: PollCategory.academic,
      query: 'topic',
    );
    expect(original.copyWith(), original);
    expect(original.copyWith().hashCode, original.hashCode);
    expect(original.copyWith(category: null).category, isNull);
    expect(original.copyWith(query: '').query, isEmpty);
    expect(original.copyWith(polls: [poll.copyWith()]), original);
    expect(original.copyWith(filter: PollFilter.all), isNot(original));
    expect(() => original.polls.add(poll), throwsUnsupportedError);
  });

  test('failed parallel vote preserves another confirmed vote', () async {
    final second = poll.copyWith(id: 'second');
    final pending = Completer<Poll>();
    when(() => repository.getPolls()).thenAnswer((_) async => [poll, second]);
    when(
      () => repository.submitPollAnswers(pollId: 'p', answers: answers),
    ).thenAnswer((_) => pending.future);
    when(
      () => repository.submitPollAnswers(pollId: 'second', answers: answers),
    ).thenAnswer((_) async => second.copyWith(iParticipated: true));
    await cubit.load();
    final failed = cubit.submitAnswers(poll: poll, answers: answers);
    await cubit.submitAnswers(poll: second, answers: answers);
    pending.completeError(Exception('offline'));
    expect(await failed, isNull);
    expect(cubit.state.polls.last.iParticipated, isTrue);
    expect(cubit.state.polls.first.iParticipated, isFalse);
  });

  test('loading after disposal cannot replace the current state', () async {
    final pending = Completer<List<Poll>>();
    when(() => repository.getPolls()).thenAnswer((_) => pending.future);
    final loading = cubit.load();
    await cubit.close();
    pending.complete([poll]);
    await loading;
    expect(cubit.state.status, PollsStatus.loading);
    expect(cubit.state.polls, isEmpty);
  });

  test('rejects duplicate options and missing quiz answer before RPC', () {
    expect(
      validPollDraft('Title', const [
        PollQuestionDraft(
          text: 'Quiz',
          kind: PollQuestionKind.quiz,
          options: ['A', 'B'],
        ),
      ]),
      isFalse,
    );
    expect(
      validPollDraft('Title', const [
        PollQuestionDraft(
          text: 'Choice',
          kind: PollQuestionKind.single,
          options: [' A ', 'A'],
        ),
      ]),
      isFalse,
    );
  });
}

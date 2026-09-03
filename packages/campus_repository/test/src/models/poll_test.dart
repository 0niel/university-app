import 'package:campus_repository/campus_repository.dart';
import 'package:test/test.dart';

void main() {
  final payload = <String, Object?>{
    'id': 'poll',
    'title': 'Campus survey',
    'description': 'Help improve campus',
    'category': 'feedback',
    'isMine': true,
    'isAnonymous': true,
    'resultsVisibility': 'after_vote',
    'allowChange': true,
    'participantsCount': 3,
    'iParticipated': true,
    'canSeeResults': true,
    'createdAt': '2026-09-03T12:00:00Z',
    'questions': [
      {
        'id': 'quiz',
        'text': 'Quiz',
        'kind': 'quiz',
        'myOptionIds': ['a'],
        'options': [
          {
            'id': 'a',
            'text': 'Dart',
            'isCorrect': true,
            'votes': 2,
            'votedByMe': true,
          },
          {'id': 'b', 'text': 'Rust', 'votes': 1},
        ],
      },
      {
        'id': 'text',
        'text': 'Why?',
        'kind': 'text',
        'isRequired': false,
        'myTextAnswer': 'Great',
        'textAnswers': ['Great'],
      },
      {
        'id': 'rating',
        'text': 'Rate',
        'kind': 'rating',
        'myRating': 4,
        'ratingAverage': 4.5,
        'ratingCount': 2,
      },
    ],
  };
  test('parses complete multi-question RPC response including quiz', () {
    final poll = Poll.fromJson(payload);
    expect(poll.title, 'Campus survey');
    expect(poll.questions, hasLength(3));
    expect(poll.questions.first.kind, PollQuestionKind.quiz);
    expect(poll.questions.first.totalVotes, 3);
    expect(poll.questions.first.options.first.share(3), closeTo(2 / 3, .001));
    expect(poll.questions.first.options.first.isCorrect, isTrue);
    expect(poll.questions.last.ratingAverage, 4.5);
    expect(poll.isFullyAnswered, isTrue);
    expect(poll.requiredQuestionCount, 2);
    expect(poll.resultsVisibility, PollResultsVisibility.afterVote);
    expect(poll.isEnded, isFalse);
  });
  test('round trips nested questions and all result types', () {
    final poll = Poll.fromJson(payload);
    expect(Poll.fromJson(poll.toJson()), poll);
    expect(poll.toJson()['questions'], isA<List<Map<String, Object?>>>());
  });

  test('parses and round trips the ordered camelCase server payload', () {
    final poll = Poll.fromJson({
      ...payload,
      'authorId': 'author-1',
      'authorName': 'Мария',
      'createdAt': '2026-06-12T21:34:56.79872+00:00',
      'questions': [
        {
          'id': 'single',
          'text': 'Язык',
          'kind': 'single',
          'position': 2,
          'myOptionIds': ['a'],
          'options': [
            {
              'id': 'a',
              'text': 'Dart',
              'position': 1,
              'votes': 2,
              'votedByMe': true,
            },
            {'id': 'b', 'text': 'Rust', 'position': 0, 'votes': 1},
          ],
        },
        {
          'id': 'text',
          'text': 'Почему?',
          'kind': 'text',
          'position': 3,
          'isRequired': false,
          'options': <Object?>[],
          'textAnswers': ['Нравится синтаксис'],
        },
      ],
    });
    expect(poll.authorId, 'author-1');
    expect(poll.authorName, 'Мария');
    expect(poll.category, 'feedback');
    expect(
      poll.createdAt?.toUtc(),
      DateTime.parse('2026-06-12T21:34:56.79872Z'),
    );
    expect(poll.participantsCount, 3);
    expect(poll.iParticipated, isTrue);
    expect(poll.isMine, isTrue);
    expect(poll.questions.first.position, 2);
    expect(poll.questions.first.options.first.position, 1);
    expect(poll.questions.first.options.first.votedByMe, isTrue);
    expect(poll.questions.first.hasMyAnswer, isTrue);
    expect(poll.questions.last.hasMyAnswer, isFalse);
    expect(poll.questions.last.textAnswers, ['Нравится синтаксис']);
    expect(poll.requiredQuestionCount, 1);
    expect(poll.isFullyAnswered, isTrue);
    final encoded = poll.toJson();
    expect(encoded, containsPair('resultsVisibility', 'after_vote'));
    expect(
      (encoded['questions']! as List).first,
      containsPair('kind', 'single'),
    );
    expect(Poll.fromJson(encoded), poll);
  });

  test('wire enums preserve supported values and fallback safely', () {
    expect(PollQuestionKind.fromWire('multiple'), PollQuestionKind.multiple);
    expect(
      PollResultsVisibility.fromWire('after_close'),
      PollResultsVisibility.afterClose,
    );
    expect(PollResultsVisibility.fromWire('x'), PollResultsVisibility.always);
    expect(PollCategory.fromWire('events'), PollCategory.events);
    expect(PollCategory.fromWire('nope'), isNull);
    const draft = PollQuestionDraft(
      text: 'Язык',
      kind: PollQuestionKind.multiple,
      options: ['Dart', 'Rust'],
    );
    expect(draft.toJson(), {
      'text': 'Язык',
      'kind': 'multiple',
      'isRequired': true,
      'options': ['Dart', 'Rust'],
    });
  });
  test('defaults tolerate missing optional data', () {
    final poll = Poll.fromJson(const {});
    expect(poll.id, '');
    expect(poll.questions, isEmpty);
    expect(poll.canSeeResults, isFalse);
    expect(PollQuestionKind.fromWire('quiz'), PollQuestionKind.quiz);
    expect(PollQuestionKind.fromWire(null), PollQuestionKind.single);
    expect(const PollOption(id: 'x', text: 'X').share(0), 0);
  });
  test('quiz draft preserves correct option index through copyWith', () {
    const draft = PollQuestionDraft(
      text: 'Quiz',
      kind: PollQuestionKind.quiz,
      options: ['A', 'B'],
      correctIndex: 1,
    );
    expect(draft.toJson()['correctIndex'], 1);
    expect(draft.copyWith(correctIndex: 0).toJson()['correctIndex'], 0);
    expect(
      const PollQuestionDraft(
        text: 'Text',
        kind: PollQuestionKind.text,
      ).toJson().containsKey('correctIndex'),
      isFalse,
    );
  });
  test('answers encode distinct option, text and rating payloads', () {
    expect(const PollAnswer(questionId: 'q', optionIds: ['a']).toJson(), {
      'questionId': 'q',
      'optionIds': ['a'],
    });
    expect(
      const PollAnswer(questionId: 'q', text: 'Answer').toJson()['text'],
      'Answer',
    );
    expect(const PollAnswer(questionId: 'q', rating: 5).toJson()['rating'], 5);
  });
  test(
    'closed and expired polls are ended without conflating participation',
    () {
      final poll = Poll.fromJson(payload);
      expect(poll.copyWith(isClosed: true).isEnded, isTrue);
      expect(poll.copyWith(expiresAt: DateTime(2000)).isEnded, isTrue);
      expect(
        poll
            .copyWith(
              questions: [poll.questions.first.copyWith(myOptionIds: [])],
            )
            .isFullyAnswered,
        isFalse,
      );
    },
  );
}

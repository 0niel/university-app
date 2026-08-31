import 'package:campus_repository/campus_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Poll.fromJson (real get_polls shape)', () {
    final json = {
      'id': 'd66be351',
      'authorId': '4f9d5159',
      'question': 'Какой язык учить?',
      'pollType': 'single',
      'isAnonymous': false,
      'showResults': true,
      'expiresAt': null,
      'createdAt': '2026-06-12T21:34:56.79872+00:00',
      'isMine': true,
      'totalVotes': 3,
      'options': [
        {
          'id': 'a',
          'text': 'Dart',
          'position': 0,
          'isCorrect': false,
          'votes': 2,
          'votedByMe': true,
        },
        {
          'id': 'b',
          'text': 'Rust',
          'position': 1,
          'isCorrect': false,
          'votes': 1,
          'votedByMe': false,
        },
      ],
    };

    test('parses the backend payload', () {
      final poll = Poll.fromJson(json);
      expect(poll.id, 'd66be351');
      expect(poll.question, 'Какой язык учить?');
      expect(poll.pollType, PollType.single);
      expect(poll.totalVotes, 3);
      expect(poll.isMine, isTrue);
      expect(poll.hasVoted, isTrue);
      expect(poll.hasEnded, isFalse);
      expect(poll.options, hasLength(2));
      expect(
        poll.options.map((option) => option.text),
        containsAllInOrder(['Dart']),
      );
      expect(
        poll.options.map((option) => option.votes),
        containsAllInOrder([2]),
      );
      expect(
        poll.options.map((option) => option.share(3)),
        contains(closeTo(0.6667, 0.001)),
      );
      expect(
        poll.options.map((option) => option.votedByMe),
        contains(isTrue),
      );
    });

    test('PollType.fromWire + defaults', () {
      expect(PollType.fromWire('quiz'), PollType.quiz);
      expect(PollType.fromWire('multi'), PollType.multi);
      expect(PollType.fromWire(null), PollType.single);
      expect(Poll.fromJson(const {}).options, isEmpty);
      expect(const PollOption(id: 'x', text: 'y').share(0), 0);
    });

    test('round-trips the camelCase backend payload', () {
      final poll = Poll.fromJson(json);
      final decoded = Poll.fromJson(poll.toJson());

      expect(decoded, poll);
      expect(poll.toJson(), containsPair('pollType', 'single'));
      expect(poll.toJson(), contains('totalVotes'));
    });
  });
}

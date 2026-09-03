import 'dart:convert';

import 'package:campus_repository/campus_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  test('forwards poll filters and pagination to the v2 endpoint', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/rest/v1/rpc/get_polls_v2');
      expect(jsonDecode(request.body), {
        'p_organization_id': 'university',
        'p_filter': 'participated',
        'p_category': 'academic',
        'p_query': 'Exam',
        'p_limit': 10,
        'p_offset': 20,
      });
      return _response(request, [
        {'id': 'poll', 'title': 'Exam', 'iParticipated': true},
      ]);
    });
    final polls = await repository.getPolls(
      filter: PollFilter.participated,
      category: PollCategory.academic,
      query: 'Exam',
      limit: 10,
      offset: 20,
    );
    expect(polls.single.iParticipated, isTrue);
  });

  for (final payload in <Object?>[
    null,
    {},
    [false],
  ]) {
    test('rejects malformed poll list $payload', () async {
      final repository = _repository(
        (request) async => _response(request, payload),
      );
      await expectLater(repository.getPolls(), throwsFormatException);
    });
  }

  test(
    'serializes every question kind and quiz answer into one create',
    () async {
      var calls = 0;
      final repository = _repository((request) async {
        calls++;
        expect(request.url.path, '/rest/v1/rpc/create_poll_v2');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['p_organization_id'], 'university');
        expect(body['p_title'], 'Feedback');
        expect(body['p_is_anonymous'], isTrue);
        expect(body['p_allow_change'], isTrue);
        expect(body['p_results_visibility'], 'after_close');
        expect(body['p_questions'], [
          for (final kind in PollQuestionKind.values)
            {
              'text': kind.wire,
              'kind': kind.wire,
              'isRequired': true,
              'options': ['One', 'Two'],
              if (kind == PollQuestionKind.quiz) 'correctIndex': 1,
            },
        ]);
        return _response(request, {'id': 'poll', 'title': 'Feedback'});
      });
      final poll = await repository.createPoll(
        title: 'Feedback',
        isAnonymous: true,
        allowChange: true,
        resultsVisibility: PollResultsVisibility.afterClose,
        questions: [
          for (final kind in PollQuestionKind.values)
            PollQuestionDraft(
              text: kind.wire,
              kind: kind,
              options: const ['One', 'Two'],
              correctIndex: kind == PollQuestionKind.quiz ? 1 : null,
            ),
        ],
      );
      expect(poll.id, 'poll');
      expect(calls, 1);
    },
  );

  test('submits option text and rating answers atomically', () async {
    final repository = _repository((request) async {
      expect(request.url.path, '/rest/v1/rpc/submit_poll_answers');
      expect(jsonDecode(request.body), {
        'p_poll_id': 'poll',
        'p_answers': [
          {
            'questionId': 'choice',
            'optionIds': ['a', 'b'],
          },
          {'questionId': 'text', 'optionIds': <String>[], 'text': 'Answer'},
          {'questionId': 'rating', 'optionIds': <String>[], 'rating': 5},
        ],
      });
      return _response(request, {
        'id': 'poll',
        'title': 'Feedback',
        'iParticipated': true,
      });
    });
    final poll = await repository.submitPollAnswers(
      pollId: 'poll',
      answers: const [
        PollAnswer(questionId: 'choice', optionIds: ['a', 'b']),
        PollAnswer(questionId: 'text', text: 'Answer'),
        PollAnswer(questionId: 'rating', rating: 5),
      ],
    );
    expect(poll.iParticipated, isTrue);
  });

  test('does not retry a rejected submission', () async {
    var calls = 0;
    final repository = _repository((request) async {
      calls++;
      return http.Response(
        '{"code":"22023","message":"Poll is closed"}',
        400,
        request: request,
      );
    });
    await expectLater(
      repository.submitPollAnswers(pollId: 'poll', answers: const []),
      throwsA(isA<PostgrestException>()),
    );
    expect(calls, 1);
  });

  test('close and delete retain their exact RPC contracts', () async {
    final calls = <String>[];
    final repository = _repository((request) async {
      calls.add(request.url.pathSegments.last);
      expect(jsonDecode(request.body), {'p_poll_id': 'poll'});
      return _response(request, {
        'id': 'poll',
        'title': 'Feedback',
        'isClosed': true,
      });
    });
    expect((await repository.closePoll('poll')).isClosed, isTrue);
    await repository.deletePoll('poll');
    expect(calls, ['close_poll', 'delete_poll']);
  });
}

http.Response _response(http.Request request, Object? value) => http.Response(
  jsonEncode(value),
  200,
  request: request,
  headers: {'content-type': 'application/json'},
);

CampusRepository _repository(MockClientHandler handler) {
  final supabase = SupabaseClient(
    'https://project.supabase.co',
    'key',
    httpClient: MockClient(handler),
  );
  addTearDown(supabase.dispose);
  return CampusRepository(supabase: supabase, organizationId: 'university');
}

import 'dart:convert';
import 'dart:io';

import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  Matcher hasPath(String path) => predicate<Uri>((uri) => uri.path == path);

  group('GithubClient', () {
    late GithubClient githubClient;
    late MockHttpClient httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      githubClient = GithubClient(httpClient: httpClient);
    });

    group('getContributors', () {
      test('returns list of contributors', () async {
        const path = '/repos/Oniel/university-app/contributors';

        final response = http.Response(
          jsonEncode([
            {
              'login': 'user1',
              'contributions': 10,
              'avatar_url': 'http://avatar.com',
              'html_url': 'http://html.com',
            },
            {
              'login': 'user2',
              'contributions': 5,
              'avatar_url': 'http://avatar.com',
              'html_url': 'http://html.com',
            },
          ]),
          HttpStatus.ok,
        );

        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        await githubClient.getContributors();

        verify(
          () => httpClient.get(
            any(that: hasPath(path)),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });

      test(
        'throws request failure before decoding an error response',
        () async {
          when(
            () => httpClient.get(any(), headers: any(named: 'headers')),
          ).thenAnswer(
            (_) async => http.Response('not JSON', HttpStatus.notFound),
          );

          await expectLater(
            githubClient.getContributors(),
            throwsA(
              isA<GithubApiRequestFailure>().having(
                (failure) => failure.statusCode,
                'statusCode',
                404,
              ),
            ),
          );
        },
      );

      test(
        'throws malformed response for a successful non-array response',
        () async {
          when(
            () => httpClient.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => http.Response('{}', HttpStatus.ok));

          await expectLater(
            githubClient.getContributors(),
            throwsA(isA<GithubApiMalformedResponse>()),
          );
        },
      );
    });
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  Matcher isAUriHaving({String? authority, String? path, String? query}) {
    return predicate<Uri>((uri) {
      authority ??= uri.authority;
      path ??= uri.path;
      query ??= uri.query;

      return uri.authority == authority && uri.path == path && uri.query == query;
    });
  }

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

        when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => response,
        );

        await githubClient.getContributors();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path)),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });
  });
}

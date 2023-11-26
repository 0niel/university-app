import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:schedule_api_client/api_client.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  /// Матчер, проверяющий, что [Uri] имеет определенный [authority], [path] и
  /// [query].
  Matcher isAUriHaving({String? authority, String? path, String? query}) {
    return predicate<Uri>((uri) {
      authority ??= uri.authority;
      path ??= uri.path;
      query ??= uri.query;

      return uri.authority == authority &&
          uri.path == path &&
          uri.query == query;
    });
  }

  /// Матчер, проверяющий, что заголовки запроса имеют определенные
  /// [HttpHeaders.contentTypeHeader] и [HttpHeaders.acceptHeader] для
  /// [ContentType.json].
  Matcher areJsonHeaders({String? authorizationToken}) {
    return predicate<Map<String, String>?>((headers) {
      if (headers?[HttpHeaders.contentTypeHeader] != ContentType.json.value ||
          headers?[HttpHeaders.acceptHeader] != ContentType.json.value) {
        return false;
      }
      if (authorizationToken != null &&
          headers?[HttpHeaders.authorizationHeader] !=
              'Bearer $authorizationToken') {
        return false;
      }
      return true;
    });
  }

  group('ScheduleApiClient', () {
    late http.Client httpClient;
    late ScheduleApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = ScheduleApiClient(
        httpClient: httpClient,
      );
    });

    group('localhost constructor', () {
      test('can be instantiated (no params).', () {
        expect(
          ScheduleApiClient.localhost,
          returnsNormally,
        );
      });

      test('has correct baseUrl', () async {
        const path = '/api/schedule/groups';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            jsonEncode(const GroupsResponse(groups: [], count: 0)),
            HttpStatus.ok,
          ),
        );
        final apiClient = ScheduleApiClient.localhost(
          httpClient: httpClient,
        );

        await apiClient.getGroups();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(authority: 'localhost:8080', path: path)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });
    });

    group('getGroups', () {
      const groupsResponse = GroupsResponse(count: 0, groups: []);

      test('makes correct http request.', () async {
        const path = '/api/schedule/groups';

        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(groupsResponse), HttpStatus.ok),
        );

        await apiClient.getGroups();

        verify(
          () => httpClient.get(
            any(that: isAUriHaving(path: path)),
            headers: any(named: 'headers', that: areJsonHeaders()),
          ),
        ).called(1);
      });

      test(
          'throws ScheduleApiMalformedResponse '
          'when response body is malformed.', () {
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('', HttpStatus.ok),
        );

        expect(
          () => apiClient.getGroups(),
          throwsA(isA<ScheduleApiMalformedResponse>()),
        );
      });

      test(
          'throws ScheduleApiRequestFailure '
          'when response has a non-200 status code.', () {
        const statusCode = HttpStatus.internalServerError;
        final body = <String, dynamic>{};
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(json.encode(body), statusCode),
        );

        expect(
          () => apiClient.getGroups(),
          throwsA(
            isA<ScheduleApiRequestFailure>()
                .having((f) => f.statusCode, 'statusCode', statusCode)
                .having((f) => f.body, 'body', body),
          ),
        );
      });

      test('returns a GroupsResponse on a 200 response.', () {
        const expectedResponse = GroupsResponse(
          count: 0,
          groups: [],
        );
        when(() => httpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(expectedResponse.toJson()),
            HttpStatus.ok,
          ),
        );

        expect(
          apiClient.getGroups(),
          completion(equals(expectedResponse)),
        );
      });
    });
  });
}

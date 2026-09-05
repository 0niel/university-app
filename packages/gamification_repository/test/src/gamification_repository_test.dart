import 'dart:convert';

import 'package:gamification_repository/gamification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  test('signed-in activity still sends the RPC with its session', () async {
    final requests = <http.Request>[];
    final expiresAt = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
    String encode(Object value) =>
        base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
    final token =
        '${encode({'alg': 'HS256', 'typ': 'JWT'})}.'
        '${encode({'exp': expiresAt, 'sub': 'test-user'})}.test';
    final client = SupabaseClient(
      'https://project.supabase.co',
      'key',
      httpClient: MockClient((request) async {
        if (request.url.path == '/auth/v1/token') {
          return http.Response(
            jsonEncode({
              'access_token': token,
              'token_type': 'bearer',
              'refresh_token': 'test-refresh',
              'expires_in': 3600,
              'user': {
                'id': 'test-user',
                'aud': 'authenticated',
                'app_metadata': <String, Object?>{},
                'user_metadata': <String, Object?>{},
                'created_at': '2026-01-01T00:00:00Z',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        requests.add(request);
        return http.Response('', 204, request: request);
      }),
    );
    addTearDown(client.dispose);
    await client.auth.signInWithPassword(
      email: 'student@example.test',
      password: 'test-password',
    );
    await GamificationRepository(supabase: client).recordActiveDay();
    expect(requests.single.url.path, '/rest/v1/rpc/record_active_day');
    expect(requests.single.headers['Authorization'], 'Bearer $token');
  });

  test('guest activity does not send an unauthenticated RPC', () async {
    final requests = <http.Request>[];
    final client = SupabaseClient(
      'https://project.supabase.co',
      'key',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response('', 204, request: request);
      }),
    );
    addTearDown(client.dispose);
    final repository = GamificationRepository(supabase: client);
    await repository.recordActiveDay();
    await repository.recordActiveDay();
    expect(requests, isEmpty);
  });

  for (final group in <String?>[null, 'GROUP-01']) {
    test(
      'academic bootstrap sends only organization and optional group $group',
      () async {
        final requests = <http.Request>[];
        final repository = GamificationRepository(
          supabase: SupabaseClient(
            'https://project.supabase.co',
            'key',
            httpClient: MockClient((request) async {
              requests.add(request);
              return http.Response('', 204, request: request);
            }),
          ),
        );
        await repository.ensureAcademicProfile(
          'university',
          academicGroup: group,
        );
        expect(
          requests.single.url.path,
          '/rest/v1/rpc/ensure_academic_profile',
        );
        expect(jsonDecode(requests.single.body), {
          'p_organization_id': 'university',
          'p_group': ?group,
        });
      },
    );
  }

  GamificationRepository repositoryReturning(Object body, {int status = 200}) {
    return GamificationRepository(
      supabase: SupabaseClient(
        'https://project.supabase.co',
        'key',
        httpClient: MockClient(
          (request) async => http.Response(
            jsonEncode(body),
            status,
            headers: {'content-type': 'application/json'},
            request: request,
          ),
        ),
      ),
    );
  }

  test('getProfile rejects a non-object RPC response', () {
    final repository = repositoryReturning(const <Object?>[]);

    expect(
      repository.getProfile,
      throwsA(isA<GamificationResponseException>()),
    );
  });

  test('academic bootstrap exposes authorization failure for recovery', () {
    final repository = repositoryReturning(
      {'code': '42501', 'message': 'Organization access denied'},
      status: 403,
    );
    expect(
      () => repository.ensureAcademicProfile('other'),
      throwsA(isA<PostgrestException>()),
    );
  });

  test('getBadges rejects malformed rows', () {
    final repository = repositoryReturning(const [null]);

    expect(
      repository.getBadges,
      throwsA(isA<GamificationResponseException>()),
    );
  });

  test('setUserIdentity maps a handle conflict to its domain exception', () {
    final repository = repositoryReturning(
      const {
        'code': 'P0001',
        'message': 'handle_taken',
        'details': null,
        'hint': null,
      },
      status: 400,
    );

    expect(
      () => repository.setUserIdentity(
        organizationId: 'university',
        fullName: 'Student',
        handle: 'student',
      ),
      throwsA(isA<HandleTakenException>()),
    );
  });

  ({GamificationRepository repository, Map<String, Object?>? Function() body})
  settingsRepository(UserSettings response) {
    Map<String, Object?>? requestBody;
    final repository = GamificationRepository(
      supabase: SupabaseClient(
        'https://project.supabase.co',
        'key',
        httpClient: MockClient((request) async {
          requestBody = (jsonDecode(request.body) as Map).cast();
          return http.Response(
            jsonEncode(response.toJson()),
            200,
            headers: {'content-type': 'application/json'},
            request: request,
          );
        }),
      ),
    );
    return (repository: repository, body: () => requestBody);
  }

  test('updateSettings sends every parameter without a baseline', () async {
    const settings = UserSettings(
      profileVisibility: .group,
      anonymousReactions: false,
    );
    final subject = settingsRepository(settings);

    expect(await subject.repository.updateSettings(settings), settings);
    expect(subject.body()?['p_profile_visibility'], 'group');
    expect(subject.body()?['p_anonymous_reactions'], isFalse);
    expect(subject.body(), hasLength(11));
  });

  test('updateSettings only sends the fields that changed', () async {
    const previous = UserSettings();
    const settings = UserSettings(
      leaderboardUpdates: true,
      profileVisibility: .nobody,
    );
    final subject = settingsRepository(settings);

    expect(
      await subject.repository.updateSettings(settings, previous: previous),
      settings,
    );
    expect(subject.body(), {
      'p_leaderboard_updates': true,
      'p_profile_visibility': 'nobody',
    });
  });

  test('updateSettings sends no parameters when nothing changed', () async {
    const settings = UserSettings(themeMode: 'dark');
    final subject = settingsRepository(settings);

    await subject.repository.updateSettings(settings, previous: settings);

    expect(subject.body(), isEmpty);
  });
}

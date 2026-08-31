import 'dart:convert';

import 'package:gamification_repository/gamification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
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

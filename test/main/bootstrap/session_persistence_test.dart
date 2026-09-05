import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rtu_mirea_app/main/bootstrap/supabase_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storageKey = 'sb-session-test-auth-token';
  const email = 'student@example.com';

  Map<String, dynamic> sessionData() {
    final expiresAt = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'exp': expiresAt})))
        .replaceAll('=', '');
    return {
      'access_token': 'header.$payload.signature',
      'refresh_token': 'test-refresh-token',
      'token_type': 'bearer',
      'expires_in': 3600,
      'expires_at': expiresAt,
      'user': {
        'id': 'saved-user',
        'aud': 'authenticated',
        'email': email,
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
        'created_at': '2026-09-01T10:00:00Z',
        'last_sign_in_at': '2026-09-05T10:00:00Z',
      },
    };
  }

  Future<SupabaseClient> initialize(http.Client client) async {
    await Supabase.initialize(
      url: 'https://session-test.supabase.co',
      publishableKey: 'test-publishable-key',
      httpClient: client,
      authOptions: SupabaseInitializer.authOptions,
      debug: false,
    );
    return Supabase.instance.client;
  }

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('email code login survives disposal and an offline restart', () async {
    final client = await initialize(
      MockClient((request) async {
        expect(request.url.path, '/auth/v1/verify');
        return http.Response(
          jsonEncode(sessionData()),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await client.auth.verifyOTP(
      email: email,
      token: '123456',
      type: OtpType.email,
    );
    await Future<void>.delayed(Duration.zero);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(storageKey), isNotNull);
    await Supabase.instance.dispose();

    var requests = 0;
    final restored = await initialize(
      MockClient((request) async {
        requests++;
        throw http.ClientException('Offline');
      }),
    );
    addTearDown(() => Supabase.instance.dispose());
    final user = await SupabaseAuthenticationClient(
      supabaseAuth: restored.auth,
    ).user.first;

    expect(user.id, 'saved-user');
    expect(user.email, email);
    expect(user.isNewUser, isFalse);
    expect(requests, 0);
  });

  test('expired stored session remains available while offline', () async {
    final saved = sessionData();
    final expiresAt = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 3600;
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'exp': expiresAt})))
        .replaceAll('=', '');
    saved
      ..['expires_at'] = expiresAt
      ..['access_token'] = 'header.$payload.signature';
    SharedPreferences.setMockInitialValues({storageKey: jsonEncode(saved)});
    final requested = Completer<void>();
    final client = await initialize(
      MockClient((request) async {
        if (!requested.isCompleted) requested.complete();
        throw http.ClientException('Offline');
      }),
    );
    addTearDown(() => Supabase.instance.dispose());
    await requested.future.timeout(const Duration(seconds: 5));
    final user = await SupabaseAuthenticationClient(
      supabaseAuth: client.auth,
    ).user.first;

    expect(user.id, 'saved-user');
    expect(client.auth.currentSession, isNotNull);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(storageKey), isNotNull);
  });

  test('explicit logout removes the session before the next launch', () async {
    SharedPreferences.setMockInitialValues({
      storageKey: jsonEncode(sessionData()),
    });
    final client = await initialize(
      MockClient((request) async => http.Response('', 204)),
    );
    await Future<void>.delayed(Duration.zero);
    await client.auth.signOut();
    await Future<void>.delayed(Duration.zero);
    await Supabase.instance.dispose();
    final restored = await initialize(
      MockClient((request) async => http.Response('', 204)),
    );
    addTearDown(() => Supabase.instance.dispose());

    expect(restored.auth.currentSession, isNull);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.containsKey(storageKey), isFalse);
  });
}

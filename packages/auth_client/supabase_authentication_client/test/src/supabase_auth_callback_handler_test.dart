import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Auth extends Mock implements GoTrueClient {}

class _Session extends Mock implements Session {}

class _Response extends Mock implements AuthSessionUrlResponse {}

class _AuthResponse extends Mock implements AuthResponse {}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  User user({required bool guest}) {
    return User(
      id: guest ? 'guest-id' : 'permanent-id',
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: '2026-09-02T10:00:00Z',
      isAnonymous: guest,
    );
  }

  for (final link in [
    'app://login-callback?code=pkce-code',
    'app://login-callback#access_token=callback-token&refresh_token=callback-refresh',
    'app://login-callback#error_description=failed',
  ]) {
    test(
      'guest session survives ${Uri.parse(link).hasQuery
          ? 'PKCE'
          : link.contains('access_token')
          ? 'implicit'
          : 'error'} callback',
      () async {
        final auth = _Auth();
        final guest = user(guest: true);
        final session = _Session();
        when(() => auth.currentUser).thenReturn(guest);
        when(() => auth.currentSession).thenReturn(session);
        final result = await SupabaseAuthCallbackHandler.forClient(
          auth,
        ).handle(Uri.parse(link));
        expect(result, SupabaseAuthCallbackResult.guestPreserved);
        expect(auth.currentUser?.id, 'guest-id');
        expect(auth.currentSession, same(session));
        verifyNever(() => auth.getSessionFromUrl(any()));
        verifyNever(auth.signOut);
      },
    );
  }

  test('ordinary application links do not start authentication', () async {
    final auth = _Auth();
    final result = await SupabaseAuthCallbackHandler.forClient(
      auth,
    ).handle(Uri.parse('app://services/people?add=friend-id'));
    expect(result, SupabaseAuthCallbackResult.ignored);
    verifyNever(() => auth.getSessionFromUrl(any()));
  });

  for (final guest in [false, null]) {
    test(
      '${guest == null ? 'signed out' : 'permanent'} account imports callbacks',
      () async {
        final auth = _Auth();
        final uri = Uri.parse('app://login-callback?code=valid-code');
        when(() => auth.currentUser).thenReturn(
          guest == null ? null : user(guest: guest),
        );
        when(
          () => auth.getSessionFromUrl(uri),
        ).thenAnswer((_) async => _Response());
        final result = await SupabaseAuthCallbackHandler.forClient(
          auth,
        ).handle(uri);
        expect(result, SupabaseAuthCallbackResult.authenticated);
        verify(() => auth.getSessionFromUrl(uri)).called(1);
      },
    );
  }

  test('successful initial and stream duplicates import only once', () async {
    final auth = _Auth();
    final uri = Uri.parse('app://login-callback?code=valid-code');
    when(
      () => auth.getSessionFromUrl(uri),
    ).thenAnswer((_) async => _Response());
    final handler = SupabaseAuthCallbackHandler.forClient(auth);
    final results = await Future.wait([
      handler.handle(uri),
      handler.handle(uri),
    ]);
    expect(results, [
      SupabaseAuthCallbackResult.authenticated,
      SupabaseAuthCallbackResult.ignored,
    ]);
    verify(() => auth.getSessionFromUrl(uri)).called(1);
  });

  test('callback failure is observable and retryable', () async {
    final auth = _Auth();
    final uri = Uri.parse('app://login-callback?code=valid-code');
    var attempts = 0;
    when(() => auth.getSessionFromUrl(uri)).thenAnswer((_) async {
      if (++attempts == 1) throw const AuthException('offline');
      return _Response();
    });
    final handler = SupabaseAuthCallbackHandler.forClient(auth);
    await expectLater(handler.handle(uri), throwsA(isA<AuthException>()));
    expect(await handler.handle(uri), SupabaseAuthCallbackResult.authenticated);
    expect(attempts, 2);
  });

  test(
    'a callback waits for guest creation and cannot replace that identity',
    () async {
      final auth = _Auth();
      final completion = Completer<AuthResponse>();
      User? currentUser;
      Session? currentSession;
      when(() => auth.currentUser).thenAnswer((_) => currentUser);
      when(() => auth.currentSession).thenAnswer((_) => currentSession);
      when(auth.signInAnonymously).thenAnswer((_) => completion.future);
      final client = SupabaseAuthenticationClient(supabaseAuth: auth);
      final creation = client.signInAnonymously();
      final callback = SupabaseAuthCallbackHandler.forClient(
        auth,
      ).handle(Uri.parse('app://login-callback?code=other-account'));
      await Future<void>.delayed(Duration.zero);
      verifyNever(() => auth.getSessionFromUrl(any()));
      currentUser = user(guest: true);
      currentSession = _Session();
      completion.complete(_AuthResponse());
      await creation;
      expect(await callback, SupabaseAuthCallbackResult.guestPreserved);
      expect(auth.currentUser?.id, 'guest-id');
      verifyNever(() => auth.getSessionFromUrl(any()));
    },
  );

  test(
    'guest creation waits for an earlier callback and keeps its session',
    () async {
      final auth = _Auth();
      final completion = Completer<AuthSessionUrlResponse>();
      final uri = Uri.parse('app://login-callback?code=permanent-account');
      User? currentUser;
      Session? currentSession;
      when(() => auth.currentUser).thenAnswer((_) => currentUser);
      when(() => auth.currentSession).thenAnswer((_) => currentSession);
      when(
        () => auth.getSessionFromUrl(uri),
      ).thenAnswer((_) => completion.future);
      final callback = SupabaseAuthCallbackHandler.forClient(auth).handle(uri);
      final creation =
          SupabaseAuthenticationClient(supabaseAuth: auth).signInAnonymously();
      await Future<void>.delayed(Duration.zero);
      verifyNever(auth.signInAnonymously);
      currentUser = user(guest: false);
      currentSession = _Session();
      completion.complete(_Response());
      await callback;
      await creation;
      expect(auth.currentUser?.id, 'permanent-id');
      verifyNever(auth.signInAnonymously);
    },
  );
}

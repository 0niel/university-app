import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockSession extends Mock implements Session {}

class _MockAuthResponse extends Mock implements AuthResponse {}

class _MockUserResponse extends Mock implements UserResponse {}

void main() {
  setUpAll(() => registerFallbackValue(UserAttributes()));

  User user({bool guest = true, String id = 'guest', String? email}) {
    return User(
      id: id,
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: '2026-09-02T10:00:00Z',
      isAnonymous: guest,
      email: email,
      emailConfirmedAt: guest ? null : '2026-09-02T10:00:00Z',
    );
  }

  group('SupabaseAuthenticationClient', () {
    test('guest login preserves an existing session', () async {
      final auth = _MockGoTrueClient();
      when(() => auth.currentSession).thenReturn(_MockSession());
      await SupabaseAuthenticationClient(
        supabaseAuth: auth,
      ).signInAnonymously();
      verifyNever(auth.signInAnonymously);
    });

    test(
      'guest login creates a real anonymous session when signed out',
      () async {
        final auth = _MockGoTrueClient();
        when(
          auth.signInAnonymously,
        ).thenAnswer((_) async => _MockAuthResponse());
        await SupabaseAuthenticationClient(
          supabaseAuth: auth,
        ).signInAnonymously();
        verify(auth.signInAnonymously).called(1);
      },
    );

    test('guest registration cannot silently replace its identity', () async {
      final auth = _MockGoTrueClient();
      when(() => auth.currentUser).thenReturn(user());
      final client = SupabaseAuthenticationClient(supabaseAuth: auth);
      await expectLater(
        client.signUp(email: 'student@gmail.com', password: 'password123'),
        throwsA(isA<SignUpFailure>()),
      );
      await expectLater(
        client.logInWithPassword(
          email: 'student@gmail.com',
          password: 'password123',
        ),
        throwsA(isA<LogInWithPasswordFailure>()),
      );
      verifyNever(
        () => auth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
      verifyNever(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    test(
      'guest upgrade links the email without changing the account',
      () async {
        final auth = _MockGoTrueClient();
        when(() => auth.currentUser).thenReturn(user());
        when(
          () => auth.updateUser(any()),
        ).thenAnswer((_) async => _MockUserResponse());
        final client = SupabaseAuthenticationClient(supabaseAuth: auth);
        await client.linkGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
        );
        final attributes =
            verify(() => auth.updateUser(captureAny())).captured.single
                as UserAttributes;
        expect(attributes.email, 'student@gmail.com');
        expect(attributes.password, isNull);
      },
    );

    test('email verification requires a matching confirmed identity', () async {
      final auth = _MockGoTrueClient();
      when(() => auth.currentUser).thenReturn(user());
      final response = _MockAuthResponse();
      when(
        () => response.user,
      ).thenReturn(user(guest: false, email: 'student@gmail.com'));
      when(
        () => auth.verifyOTP(
          email: any(named: 'email'),
          token: any(named: 'token'),
          type: OtpType.emailChange,
        ),
      ).thenAnswer((_) async => response);
      await SupabaseAuthenticationClient(supabaseAuth: auth).verifyGuestEmail(
        userId: 'guest',
        email: 'student@gmail.com',
        code: '123456',
      );
      verify(
        () => auth.verifyOTP(
          email: 'student@gmail.com',
          token: '123456',
          type: OtpType.emailChange,
        ),
      ).called(1);
    });

    test(
      'email verification can recover after a completed response is lost',
      () async {
        final auth = _MockGoTrueClient();
        when(
          () => auth.currentUser,
        ).thenReturn(user(guest: false, email: 'student@gmail.com'));
        await SupabaseAuthenticationClient(supabaseAuth: auth).verifyGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
          code: '123456',
        );
        verifyNever(
          () => auth.verifyOTP(
            email: any(named: 'email'),
            token: any(named: 'token'),
            type: OtpType.emailChange,
          ),
        );
      },
    );

    test(
      'account switching or unverified email prevents setting a password',
      () async {
        final auth = _MockGoTrueClient();
        final client = SupabaseAuthenticationClient(supabaseAuth: auth);
        when(() => auth.currentUser).thenReturn(user());
        await expectLater(
          client.setAccountPassword(userId: 'guest', password: 'password123'),
          throwsA(isA<SignUpFailure>()),
        );
        when(() => auth.currentUser).thenReturn(
          user(guest: false, id: 'other', email: 'student@gmail.com'),
        );
        await expectLater(
          client.setAccountPassword(userId: 'guest', password: 'password123'),
          throwsA(isA<SignUpFailure>()),
        );
        verifyNever(() => auth.updateUser(any()));
      },
    );

    test(
      'password is attached to the verified guest identity in place',
      () async {
        final auth = _MockGoTrueClient();
        when(
          () => auth.currentUser,
        ).thenReturn(user(guest: false, email: 'student@gmail.com'));
        when(
          () => auth.updateUser(any()),
        ).thenAnswer((_) async => _MockUserResponse());
        await SupabaseAuthenticationClient(
          supabaseAuth: auth,
        ).setAccountPassword(userId: 'guest', password: 'password123');
        final attributes =
            verify(() => auth.updateUser(captureAny())).captured.single
                as UserAttributes;
        expect(attributes.password, 'password123');
        expect(attributes.email, isNull);
      },
    );

    test('rejects an email callback without an OTP', () async {
      const email = 'student@example.edu';
      const emailLink = 'app://login-callback';
      final client = SupabaseAuthenticationClient(
        supabaseAuth: _MockGoTrueClient(),
      );

      await expectLater(
        client.logInWithEmailLink(email: email, emailLink: emailLink),
        throwsA(
          isA<LogInWithEmailLinkFailure>().having(
            (failure) => failure.error,
            'error',
            isA<FormatException>(),
          ),
        ),
      );
    });
  });
}

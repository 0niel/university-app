import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  group('SupabaseAuthenticationClient', () {
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

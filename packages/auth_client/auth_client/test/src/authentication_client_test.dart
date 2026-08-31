// This package is just an abstraction.

import 'package:auth_client/auth_client.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

// AuthenticationClient is exported and can be implemented
class FakeAuthenticationClient extends Fake implements AuthenticationClient {
  @override
  Stream<AuthenticationUser> get user => .value(.anonymous);

  @override
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  }) async {}

  @override
  bool isLogInWithEmailLink({required String emailLink}) => false;

  @override
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  test('AuthenticationClient can be implemented', () {
    expect(FakeAuthenticationClient.new, returnsNormally);
  });

  test('exports SendLoginEmailLinkFailure', () {
    expect(() => const SendLoginEmailLinkFailure('oops'), returnsNormally);
  });

  test('exports IsLogInWithEmailLinkFailure', () {
    expect(() => const IsLogInWithEmailLinkFailure('oops'), returnsNormally);
  });

  test('exports LogInWithEmailLinkFailure', () {
    expect(() => const LogInWithEmailLinkFailure('oops'), returnsNormally);
  });

  test('exports LogOutFailure', () {
    expect(() => const LogOutFailure('oops'), returnsNormally);
  });

  test('exports DeleteAccountFailure', () {
    expect(() => const DeleteAccountFailure('oops'), returnsNormally);
  });

  group('AuthenticationException', () {
    test('stores the error message', () {
      const errorMessage = 'Something went wrong';
      const exception = SendLoginEmailLinkFailure(errorMessage);
      expect(exception.error, equals(errorMessage));
    });
  });

  group('AuthenticationClient interface', () {
    test('defines user stream', () {
      final client = FakeAuthenticationClient();
      expect(client.user, isA<Stream<AuthenticationUser>>());
    });

    test('defines sendLoginEmailLink method', () {
      final client = FakeAuthenticationClient();
      expect(
        () => client.sendLoginEmailLink(
          email: 'test@example.com',
          appPackageName: 'com.example.app',
        ),
        returnsNormally,
      );
    });

    test('defines isLogInWithEmailLink method', () {
      final client = FakeAuthenticationClient();
      expect(
        () => client.isLogInWithEmailLink(emailLink: 'https://example.com'),
        returnsNormally,
      );
    });

    test('defines logInWithEmailLink method', () {
      final client = FakeAuthenticationClient();
      expect(
        () => client.logInWithEmailLink(
          email: 'test@example.com',
          emailLink: 'https://example.com',
        ),
        returnsNormally,
      );
    });

    test('defines logOut method', () {
      final client = FakeAuthenticationClient();
      expect(client.logOut, returnsNormally);
    });

    test('defines deleteAccount method', () {
      final client = FakeAuthenticationClient();
      expect(client.deleteAccount, returnsNormally);
    });
  });
}

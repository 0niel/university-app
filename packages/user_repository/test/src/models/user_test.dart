// ignore_for_file: prefer_const_constructors

import 'package:auth_client/auth_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('User', () {
    group('fromAuthenticationUser', () {
      test('initializes correctly', () {
        final authenticationUser = AuthenticationUser(id: 'id');

        expect(
          User.fromAuthenticationUser(
            authenticationUser: authenticationUser,
          ),
          equals(
            User(
              id: 'id',
            ),
          ),
        );
      });
    });

    group('isAnonymous', () {
      test('sets isAnonymous correctly', () {
        const anonymousUser = User.anonymous;
        expect(anonymousUser.isAnonymous, isTrue);
      });
    });
  });
}

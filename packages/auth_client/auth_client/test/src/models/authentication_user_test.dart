// ignore_for_file: prefer_const_constructors

import 'package:auth_client/auth_client.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticationUser', () {
    test('supports value equality', () {
      final userA = AuthenticationUser(id: 'A');
      final secondUserA = AuthenticationUser(id: 'A');
      final userB = AuthenticationUser(id: 'B');

      expect(userA, equals(secondUserA));
      expect(userA, isNot(equals(userB)));
    });

    test('isAnonymous returns true for anonymous user', () {
      expect(AuthenticationUser.anonymous.isAnonymous, isTrue);
    });

    test('isAnonymous returns false for non-anonymous user', () {
      final user = AuthenticationUser(id: 'test-id');
      expect(user.isAnonymous, isFalse);
    });

    test('props contains all properties', () {
      final user = AuthenticationUser(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        photo: 'https://example.com/photo.jpg',
        isNewUser: false,
      );

      expect(user.props, equals(['test@example.com', 'test-id', 'Test User', 'https://example.com/photo.jpg', false]));
    });
  });
}

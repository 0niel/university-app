import 'package:auth_client/auth_client.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticationUser', () {
    test('supports value equality', () {
      const userA = AuthenticationUser(id: 'A');
      const secondUserA = AuthenticationUser(id: 'A');
      const userB = AuthenticationUser(id: 'B');

      expect(userA, equals(secondUserA));
      expect(userA, isNot(equals(userB)));
    });

    test('isAnonymous returns true for anonymous user', () {
      expect(AuthenticationUser.anonymous.isAnonymous, isTrue);
    });

    test('isAnonymous returns false for non-anonymous user', () {
      const user = AuthenticationUser(id: 'test-id');
      expect(user.isAnonymous, isFalse);
    });

    test('preserves every declared property in value equality', () {
      const user = AuthenticationUser(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        photo: 'https://example.com/photo.jpg',
        isNewUser: false,
      );

      expect(
        user,
        const AuthenticationUser(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          photo: 'https://example.com/photo.jpg',
          isNewUser: false,
        ),
      );
    });
  });
}

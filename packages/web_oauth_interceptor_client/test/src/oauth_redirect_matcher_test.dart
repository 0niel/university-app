import 'package:flutter_test/flutter_test.dart';
import 'package:web_oauth_interceptor_client/src/oauth_redirect_matcher.dart';

void main() {
  group('OAuthRedirectMatcher', () {
    test('matches a redirect with OAuth query parameters', () {
      expect(
        OAuthRedirectMatcher.matches(
          'https://auth.example.edu/callback?code=abc&state=xyz',
          const ['https://auth.example.edu/callback'],
        ),
        isTrue,
      );
    });

    test('rejects a URL that only has the redirect as a prefix', () {
      expect(
        OAuthRedirectMatcher.matches(
          'https://auth.example.edu/callback.evil.example?code=abc',
          const ['https://auth.example.edu/callback'],
        ),
        isFalse,
      );
    });

    test('requires configured query parameters to match', () {
      expect(
        OAuthRedirectMatcher.matches(
          'https://auth.example.edu/callback?state=other&code=abc',
          const ['https://auth.example.edu/callback?state=expected'],
        ),
        isFalse,
      );
    });
  });
}

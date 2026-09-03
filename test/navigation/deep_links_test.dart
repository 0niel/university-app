import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';

void main() {
  const config = UniversityConfig(
    organizationId: 'example-university',
    appName: 'Example App',
    universityName: 'Example University',
    universityShortName: 'EU',
    websiteUrl: 'https://university.example',
    supportEmail: 'support@university.example',
    deepLinkScheme: 'exampleapp',
    webAppHost: 'app.university.example',
    webAppPathPrefix: '/student',
  );

  test('normalizes tenant-specific custom and web links', () {
    expect(
      DeepLinks.normalize(
        Uri.parse('exampleapp://services/marketplace'),
        config: config,
      ),
      '/services/marketplace',
    );
    expect(
      DeepLinks.normalize(
        Uri.parse('https://app.university.example/student/schedule'),
        config: config,
      ),
      '/schedule',
    );
  });

  test('builds a tenant-specific share link', () {
    expect(
      DeepLinks.shareLink('/feed/article/42', config: config),
      Uri.parse('https://app.university.example/student/feed/article/42'),
    );
  });

  test('preserves query parameters in share and app links', () {
    expect(
      DeepLinks.shareLink('/services/people?add=user-42', config: config),
      Uri.parse(
        'https://app.university.example/student/services/people?add=user-42',
      ),
    );
    expect(
      DeepLinks.appLink('/services/people?add=user-42', config: config),
      Uri.parse('exampleapp://services/people?add=user-42'),
    );
  });

  test('root route queries do not fall back to the feed', () {
    expect(
      DeepLinks.normalizeLocation('/schedule?group=group-42'),
      '/schedule?group=group-42',
    );
    expect(
      DeepLinks.appLink('/profile?tab=activity', config: config),
      Uri.parse('exampleapp://profile?tab=activity'),
    );
    expect(
      DeepLinks.shareLink('/schedule?group=group-42', config: config),
      Uri.parse(
        'https://app.university.example/student/schedule?group=group-42',
      ),
    );
    expect(
      DeepLinks.normalize(
        Uri.parse('exampleapp://schedule?group=group-42'),
        config: config,
      ),
      '/schedule?group=group-42',
    );
  });

  test('only the path is trimmed and legacy aliases keep their query', () {
    expect(
      DeepLinks.normalizeLocation('/schedule/?group=group-42'),
      '/schedule?group=group-42',
    );
    expect(
      DeepLinks.normalizeLocation('/info?source=push'),
      '/feed?source=push',
    );
    expect(
      DeepLinks.normalizeLocation('/services/people?filter=path/'),
      '/services/people?filter=path/',
    );
  });

  test('query values retain repeated keys and encoded characters', () {
    const location = '/search?tag=one&tag=two&q=%D0%BC%D0%B8%D1%80';
    expect(
      DeepLinks.appLink(location, config: config).query,
      'tag=one&tag=two&q=%D0%BC%D0%B8%D1%80',
    );
    expect(
      DeepLinks.shareLink(location, config: config).query,
      'tag=one&tag=two&q=%D0%BC%D0%B8%D1%80',
    );
  });

  test('normalization cannot escape the allowed route roots', () {
    expect(DeepLinks.normalizeLocation('//other.example/schedule'), isNull);
    expect(DeepLinks.normalizeLocation('/services/../login'), isNull);
    expect(
      DeepLinks.normalizeLocation('https://other.example/schedule'),
      isNull,
    );
    expect(DeepLinks.normalizeLocation('/schedule/../profile'), '/profile');
  });
}

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
}

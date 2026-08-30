import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/models/deadline_quick_date.dart';
import 'package:rtu_mirea_app/config/config.dart';

void main() {
  const config = UniversityConfig(
    organizationId: 'example',
    appName: 'Example',
    universityName: 'Example University',
    universityShortName: 'EU',
    websiteUrl: 'https://university.example',
    supportEmail: 'support@university.example',
    deepLinkScheme: 'example',
    webAppHost: 'app.university.example',
    webAppPathPrefix: '/app',
  );

  group('resolveDeadlineQuickDate', () {
    test('selects the summer session after the winter boundary', () {
      final result = resolveDeadlineQuickDate(
        .session,
        now: DateTime(2026, 1, 10),
        universityConfig: config,
      );

      expect(result, DateTime(2026, 6, 9, 23, 59));
    });

    test('selects next winter session after the summer boundary', () {
      final result = resolveDeadlineQuickDate(
        .session,
        now: DateTime(2026, 6, 10),
        universityConfig: config,
      );

      expect(result, DateTime(2027, 1, 9, 23, 59));
    });

    test('honors white-label session dates', () {
      const customConfig = UniversityConfig(
        organizationId: 'example',
        appName: 'Example',
        universityName: 'Example University',
        universityShortName: 'EU',
        websiteUrl: 'https://university.example',
        supportEmail: 'support@university.example',
        deepLinkScheme: 'example',
        webAppHost: 'app.university.example',
        webAppPathPrefix: '/app',
        winterSessionStartMonth: 2,
        winterSessionStartDay: 1,
        summerSessionStartMonth: 7,
        summerSessionStartDay: 15,
      );

      final result = resolveDeadlineQuickDate(
        .session,
        now: DateTime(2026, 2, 2),
        universityConfig: customConfig,
      );

      expect(result, DateTime(2026, 7, 15, 23, 59));
    });
  });
}

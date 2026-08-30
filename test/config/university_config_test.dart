import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';

void main() {
  test('keeps deployment identity in one immutable value', () {
    const config = UniversityConfig(
      organizationId: 'example-university',
      appName: 'Example App',
      universityName: 'Example University',
      universityShortName: 'EU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'exampleapp',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
    );

    expect(config.organizationId, 'example-university');
    expect(config.appName, 'Example App');
    expect(config.universityShortName, 'EU');
    expect(config.isEnabled(.nfcPass), isFalse);
    expect(config.mentorTopicKeys, contains('python'));
    expect(config.mentorWhenSlotKeys, ['tonight', 'tomorrow', 'week']);
    expect(config.teamKindKeys, ['hackathon', 'project', 'study']);
    expect(config.teamRoleKeys, containsAll(['frontend', 'backend', 'design']));
    expect(config.marketplaceCategoryKeys, containsAll(['books', 'other']));
    expect(config.marketplaceCurrencyCode, 'RUB');
    expect(config.lostFoundCategoryKeys, containsAll(['tech', 'other']));
    expect(config.lessonBellSlots.firstOrNull?.label, '09:00');
    expect(config.lessonColorValues, isNotEmpty);
    expect(config.lessonReminderLeadMinutes, contains(15));
  });

  test('provides a usable default deployment', () {
    final config = UniversityConfig.fromEnvironment();

    expect(config.organizationId, isNotEmpty);
    expect(config.appName, isNotEmpty);
    expect(config.universityName, isNotEmpty);
    expect(config.isEnabled(.nfcPass), isTrue);
    expect(
      Uri.parse(config.nfcPass.oauthUrl).queryParameters['redirectUri'],
      'https://pulse.mirea.ru/services',
    );
    expect(
      config.nfcPass.redirectUrls,
      const ['https://pulse.mirea.ru/services'],
    );
  });

  test('parses explicit tenant capabilities', () {
    final capabilities = UniversityCapability.parseCsv('campus_map,nfc_pass');

    expect(
      capabilities,
      {UniversityCapability.campusMap, UniversityCapability.nfcPass},
    );
    expect(
      () => UniversityCapability.parseCsv('campus_map,campus_map'),
      throwsArgumentError,
    );
    expect(
      () => UniversityCapability.parseCsv('not_a_capability'),
      throwsArgumentError,
    );
  });

  test('rejects invalid runtime deployment values', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'http://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts an optional secure community chat URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      communityChatUrl: 'https://t.me/example_university',
    );

    expect(
      (config..validate()).communityChatUrl,
      'https://t.me/example_university',
    );
  });

  test('accepts an optional calendar event URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      calendarEventUrl: 'university://open',
    );

    expect((config..validate()).calendarEventUrl, 'university://open');
  });

  test('rejects an insecure calendar event URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      calendarEventUrl: 'http://university.example/open',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('rejects an insecure NFC-pass provider endpoint', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      nfcPass: NfcPassConfig(
        oauthUrl: 'http://auth.university.example/nfc/login',
        redirectUrls: ['https://app.university.example/nfc/complete'],
        accessTokenUrl: 'https://api.university.example/nfc/access-token',
        sendVerificationCodeUrl: 'https://api.university.example/nfc/send-code',
        getDigitalPassUrl: 'https://api.university.example/nfc/get-pass',
      ),
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts a secure community forum URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      communityForumUrl: 'https://forum.university.example',
    );

    expect(
      (config..validate()).communityForumUrl,
      'https://forum.university.example',
    );
  });

  test('rejects an insecure community forum URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      communityForumUrl: 'http://forum.university.example',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts university-specific email domains', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      allowedEmailDomains: [
        'university.example',
        'students.university.example',
      ],
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
    );

    final validated = config..validate();
    expect(validated.emailPlaceholder, 'student@university.example');
    expect(
      validated.emailDomainHint,
      '@university.example, @students.university.example',
    );
  });

  test('rejects invalid university email domains', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      allowedEmailDomains: ['University.example'],
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('rejects an insecure community chat URL', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      communityChatUrl: 'http://t.me/example_university',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts deployment-specific mentorship taxonomies', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      mentorTopicKeys: ['math', 'physics'],
      mentorLevelKeys: ['bachelor'],
      mentorFormatKeys: ['campus'],
      mentorWhenSlotKeys: ['tomorrow'],
    );

    expect((config..validate()).mentorTopicKeys, ['math', 'physics']);
  });

  test('rejects unsupported mentorship slots', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      mentorWhenSlotKeys: ['next-month'],
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts deployment-specific team taxonomies', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      teamKindKeys: ['research', 'startup'],
      teamRoleKeys: ['science', 'product'],
    );

    final validated = config..validate();
    expect(validated.teamKindKeys, ['research', 'startup']);
    expect(validated.teamRoleKeys, ['science', 'product']);
  });

  test('rejects duplicate team taxonomy keys', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      teamKindKeys: ['project', 'project'],
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts marketplace taxonomy and ISO currency configuration', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      marketplaceCategoryKeys: ['books', 'lab_equipment', 'free'],
      marketplaceCurrencyCode: 'EUR',
    );

    final validated = config..validate();
    expect(validated.marketplaceCategoryKeys, contains('lab_equipment'));
    expect(validated.marketplaceCurrencyCode, 'EUR');
  });

  test('rejects invalid marketplace category and currency values', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      marketplaceCategoryKeys: ['Not Valid'],
      marketplaceCurrencyCode: 'rubles',
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts deployment-specific lost and found categories', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      lostFoundCategoryKeys: ['lab_equipment', 'documents'],
    );

    expect(
      (config..validate()).lostFoundCategoryKeys,
      ['lab_equipment', 'documents'],
    );
  });

  test('rejects invalid lost and found category values', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      lostFoundCategoryKeys: ['Not Valid'],
    );

    expect(config.validate, throwsArgumentError);
  });

  test('accepts deployment-specific lesson editor options', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      lessonBellSlots: [
        LessonBellSlotConfig(startMinutes: 480, endMinutes: 560),
      ],
      lessonColorValues: [0xFF112233],
      lessonReminderLeadMinutes: [7, 20],
    );

    final validated = config..validate();
    expect(validated.lessonBellSlots.singleOrNull?.label, '08:00');
    expect(validated.lessonReminderLeadMinutes, [7, 20]);
  });

  test('rejects overlapping lesson bell slots', () {
    const config = UniversityConfig(
      organizationId: 'other',
      appName: 'University',
      universityName: 'Other University',
      universityShortName: 'OU',
      websiteUrl: 'https://university.example',
      supportEmail: 'support@university.example',
      deepLinkScheme: 'university',
      webAppHost: 'app.university.example',
      webAppPathPrefix: '/app',
      lessonBellSlots: [
        LessonBellSlotConfig(startMinutes: 480, endMinutes: 560),
        LessonBellSlotConfig(startMinutes: 550, endMinutes: 630),
      ],
    );

    expect(config.validate, throwsArgumentError);
  });
}

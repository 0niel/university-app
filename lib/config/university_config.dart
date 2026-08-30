import 'package:collection/collection.dart';
import 'package:rtu_mirea_app/config/lesson_bell_slot_config.dart';
import 'package:rtu_mirea_app/config/nfc_pass_config.dart';
import 'package:rtu_mirea_app/config/university_capability.dart';

final class UniversityConfig {
  const UniversityConfig({
    required this.organizationId,
    required this.appName,
    required this.universityName,
    required this.universityShortName,
    required this.websiteUrl,
    required this.supportEmail,
    required this.deepLinkScheme,
    required this.webAppHost,
    required this.webAppPathPrefix,
    this.communityForumUrl = 'https://mirea.ninja',
    this.enabledCapabilities = const {
      UniversityCapability.campusMap,
      UniversityCapability.virtualTour,
    },
    this.allowedEmailDomains = const [
      'mirea.ru',
      'edu.mirea.ru',
      'yandex.ru',
    ],
    this.communityChatUrl,
    this.calendarEventUrl,
    this.nfcPass = const NfcPassConfig(
      oauthUrl:
          'https://attendance.mirea.ru/api/auth/login?redirectUri=https%3A%2F%2Fpulse.mirea.ru%2Fservices&rememberMe=True',
      redirectUrls: ['https://pulse.mirea.ru/services'],
      accessTokenUrl:
          'https://attendance.mirea.ru/rtu.pulse_app.LongTimeTokenService/GetAccessTokenForDigitalPass',
      sendVerificationCodeUrl:
          'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/SendVerificationCode',
      getDigitalPassUrl:
          'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/GetDigitalPass',
    ),
    this.winterSessionStartMonth = 1,
    this.winterSessionStartDay = 9,
    this.summerSessionStartMonth = 6,
    this.summerSessionStartDay = 9,
    this.mentorTopicKeys = const [
      'ml',
      'python',
      'career',
      'design',
      'frontend',
      'cybersec',
    ],
    this.mentorLevelKeys = const ['course3', 'course4', 'master'],
    this.mentorFormatKeys = const ['online', 'campus', 'chat'],
    this.mentorWhenSlotKeys = const ['tonight', 'tomorrow', 'week'],
    this.teamKindKeys = const ['hackathon', 'project', 'study'],
    this.teamRoleKeys = const [
      'frontend',
      'ml',
      'design',
      'backend',
      'marketing',
    ],
    this.marketplaceCategoryKeys = const [
      'books',
      'tech',
      'cloth',
      'free',
      'other',
    ],
    this.marketplaceCurrencyCode = 'RUB',
    this.lostFoundCategoryKeys = const [
      'tech',
      'docs',
      'keys',
      'cloth',
      'other',
    ],
    this.lessonBellSlots = defaultLessonBellSlots,
    this.lessonColorValues = defaultLessonColorValues,
    this.lessonReminderLeadMinutes = defaultLessonReminderLeadMinutes,
  }) : assert(organizationId != '', 'organizationId must not be empty'),
       assert(appName != '', 'appName must not be empty'),
       assert(universityName != '', 'universityName must not be empty'),
       assert(
         universityShortName != '',
         'universityShortName must not be empty',
       );

  factory UniversityConfig.fromEnvironment() {
    const winterStartMonth = int.fromEnvironment(
      'WINTER_SESSION_START_MONTH',
      defaultValue: 1,
    );
    const winterStartDay = int.fromEnvironment(
      'WINTER_SESSION_START_DAY',
      defaultValue: 9,
    );
    const summerStartMonth = int.fromEnvironment(
      'SUMMER_SESSION_START_MONTH',
      defaultValue: 6,
    );
    const summerStartDay = int.fromEnvironment(
      'SUMMER_SESSION_START_DAY',
      defaultValue: 9,
    );
    final config = UniversityConfig(
      organizationId: const String.fromEnvironment(
        'APP_ORGANIZATION_ID',
        defaultValue: 'mirea',
      ),
      appName: const String.fromEnvironment(
        'APP_DISPLAY_NAME',
        defaultValue: 'Mirea Ninja',
      ),
      universityName: const String.fromEnvironment(
        'UNIVERSITY_NAME',
        defaultValue: 'Российский технологический университет МИРЭА',
      ),
      universityShortName: const String.fromEnvironment(
        'UNIVERSITY_SHORT_NAME',
        defaultValue: 'РТУ МИРЭА',
      ),
      websiteUrl: const String.fromEnvironment(
        'UNIVERSITY_WEBSITE_URL',
        defaultValue: 'https://www.mirea.ru',
      ),
      supportEmail: const String.fromEnvironment(
        'APP_SUPPORT_EMAIL',
        defaultValue: 'support@mirea.ninja',
      ),
      allowedEmailDomains: _csv(
        const String.fromEnvironment(
          'APP_ALLOWED_EMAIL_DOMAINS',
          defaultValue: 'mirea.ru,edu.mirea.ru,yandex.ru',
        ),
      ),
      deepLinkScheme: const String.fromEnvironment(
        'APP_DEEP_LINK_SCHEME',
        defaultValue: 'mireaninja',
      ),
      webAppHost: const String.fromEnvironment(
        'APP_WEB_HOST',
        defaultValue: 'mirea.ninja',
      ),
      webAppPathPrefix: const String.fromEnvironment(
        'APP_WEB_PATH_PREFIX',
        defaultValue: '/app',
      ),
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      communityForumUrl: const String.fromEnvironment(
        'APP_COMMUNITY_FORUM_URL',
        defaultValue: 'https://mirea.ninja',
      ),
      communityChatUrl: _optionalString(
        const String.fromEnvironment('APP_COMMUNITY_CHAT_URL'),
      ),
      calendarEventUrl: _optionalString(
        const String.fromEnvironment(
          'APP_CALENDAR_EVENT_URL',
          defaultValue: 'ninja.mirea.mireaapp://open',
        ),
      ),
      nfcPass: NfcPassConfig(
        oauthUrl: const String.fromEnvironment(
          'APP_NFC_PASS_OAUTH_URL',
          defaultValue:
              'https://attendance.mirea.ru/api/auth/login?redirectUri=https%3A%2F%2Fpulse.mirea.ru%2Fservices&rememberMe=True',
        ),
        redirectUrls: _csv(
          const String.fromEnvironment(
            'APP_NFC_PASS_REDIRECT_URLS',
            defaultValue: 'https://pulse.mirea.ru/services',
          ),
        ),
        accessTokenUrl: const String.fromEnvironment(
          'APP_NFC_PASS_ACCESS_TOKEN_URL',
          defaultValue:
              'https://attendance.mirea.ru/rtu.pulse_app.LongTimeTokenService/GetAccessTokenForDigitalPass',
        ),
        sendVerificationCodeUrl: const String.fromEnvironment(
          'APP_NFC_PASS_SEND_CODE_URL',
          defaultValue:
              'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/SendVerificationCode',
        ),
        getDigitalPassUrl: const String.fromEnvironment(
          'APP_NFC_PASS_GET_PASS_URL',
          defaultValue:
              'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/GetDigitalPass',
        ),
      ),
      enabledCapabilities: UniversityCapability.parseCsv(
        const String.fromEnvironment(
          'APP_ENABLED_CAPABILITIES',
          defaultValue: 'campus_map,nfc_pass,virtual_tour',
        ),
      ),
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      winterSessionStartMonth: winterStartMonth,
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      winterSessionStartDay: winterStartDay,
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      summerSessionStartMonth: summerStartMonth,
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      summerSessionStartDay: summerStartDay,
      mentorTopicKeys: _csv(
        const String.fromEnvironment(
          'MENTOR_TOPIC_KEYS',
          defaultValue: 'ml,python,career,design,frontend,cybersec',
        ),
      ),
      mentorLevelKeys: _csv(
        const String.fromEnvironment(
          'MENTOR_LEVEL_KEYS',
          defaultValue: 'course3,course4,master',
        ),
      ),
      mentorFormatKeys: _csv(
        const String.fromEnvironment(
          'MENTOR_FORMAT_KEYS',
          defaultValue: 'online,campus,chat',
        ),
      ),
      mentorWhenSlotKeys: _csv(
        const String.fromEnvironment(
          'MENTOR_WHEN_SLOT_KEYS',
          defaultValue: 'tonight,tomorrow,week',
        ),
      ),
      teamKindKeys: _csv(
        const String.fromEnvironment(
          'TEAM_KIND_KEYS',
          defaultValue: 'hackathon,project,study',
        ),
      ),
      teamRoleKeys: _csv(
        const String.fromEnvironment(
          'TEAM_ROLE_KEYS',
          defaultValue: 'frontend,ml,design,backend,marketing',
        ),
      ),
      marketplaceCategoryKeys: _csv(
        const String.fromEnvironment(
          'MARKETPLACE_CATEGORY_KEYS',
          defaultValue: 'books,tech,cloth,free,other',
        ),
      ),
      // Can differ from the constructor default through --dart-define.
      // ignore: avoid_redundant_argument_values
      marketplaceCurrencyCode: const String.fromEnvironment(
        'MARKETPLACE_CURRENCY_CODE',
        defaultValue: 'RUB',
      ),
      lostFoundCategoryKeys: _csv(
        const String.fromEnvironment(
          'LOST_FOUND_CATEGORY_KEYS',
          defaultValue: 'tech,docs,keys,cloth,other',
        ),
      ),
      lessonBellSlots: _bellSlots(
        const String.fromEnvironment(
          'LESSON_BELL_SLOTS',
          defaultValue:
              '09:00-10:30,10:40-12:10,12:40-14:10,14:20-15:50,'
              '16:20-17:50,18:00-19:30,19:40-21:10',
        ),
      ),
      lessonColorValues: _colorValues(
        const String.fromEnvironment(
          'LESSON_COLOR_VALUES',
          defaultValue:
              'FF2F7AFF,FFA45CFF,FFFF8A2F,FF1FB872,FFFF4F4F,'
              'FFFF6FB1',
        ),
      ),
      lessonReminderLeadMinutes: _integers(
        const String.fromEnvironment(
          'LESSON_REMINDER_LEAD_MINUTES',
          defaultValue: '5,10,15,30,60',
        ),
        'LESSON_REMINDER_LEAD_MINUTES',
      ),
    );
    return config..validate();
  }

  static final current = UniversityConfig.fromEnvironment();

  final String organizationId;
  final String appName;
  final String universityName;
  final String universityShortName;
  final String websiteUrl;
  final String supportEmail;
  final List<String> allowedEmailDomains;
  final String deepLinkScheme;
  final String webAppHost;
  final String webAppPathPrefix;
  final String communityForumUrl;
  final String? communityChatUrl;
  final String? calendarEventUrl;
  final NfcPassConfig nfcPass;
  final Set<UniversityCapability> enabledCapabilities;
  final int winterSessionStartMonth;
  final int winterSessionStartDay;
  final int summerSessionStartMonth;
  final int summerSessionStartDay;
  final List<String> mentorTopicKeys;
  final List<String> mentorLevelKeys;
  final List<String> mentorFormatKeys;
  final List<String> mentorWhenSlotKeys;
  final List<String> teamKindKeys;
  final List<String> teamRoleKeys;
  final List<String> marketplaceCategoryKeys;
  final String marketplaceCurrencyCode;
  final List<String> lostFoundCategoryKeys;
  final List<LessonBellSlotConfig> lessonBellSlots;
  final List<int> lessonColorValues;
  final List<int> lessonReminderLeadMinutes;

  String get emailDomainHint =>
      allowedEmailDomains.map((domain) => '@$domain').join(', ');

  bool isEnabled(UniversityCapability capability) =>
      enabledCapabilities.contains(capability);

  String get emailPlaceholder {
    final domain = allowedEmailDomains.firstOrNull;
    return 'student@${domain ?? 'university.example'}';
  }

  static const defaultLessonBellSlots = [
    LessonBellSlotConfig(startMinutes: 540, endMinutes: 630),
    LessonBellSlotConfig(startMinutes: 640, endMinutes: 730),
    LessonBellSlotConfig(startMinutes: 760, endMinutes: 850),
    LessonBellSlotConfig(startMinutes: 860, endMinutes: 950),
    LessonBellSlotConfig(startMinutes: 980, endMinutes: 1070),
    LessonBellSlotConfig(startMinutes: 1080, endMinutes: 1170),
    LessonBellSlotConfig(startMinutes: 1180, endMinutes: 1270),
  ];
  static const defaultLessonColorValues = [
    0xFF2F7AFF,
    0xFFA45CFF,
    0xFFFF8A2F,
    0xFF1FB872,
    0xFFFF4F4F,
    0xFFFF6FB1,
  ];
  static const defaultLessonReminderLeadMinutes = [5, 10, 15, 30, 60];

  void validate() {
    _requireMatch(
      organizationId,
      r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
      'APP_ORGANIZATION_ID',
    );
    _validateWebsite();
    _requireMatch(
      supportEmail,
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      'APP_SUPPORT_EMAIL',
    );
    _validateEmailDomains();
    _requireMatch(
      deepLinkScheme,
      r'^[a-z][a-z0-9+.-]*$',
      'APP_DEEP_LINK_SCHEME',
    );
    if (deepLinkScheme == 'http' || deepLinkScheme == 'https') {
      throw ArgumentError.value(deepLinkScheme, 'APP_DEEP_LINK_SCHEME');
    }
    _requireMatch(
      webAppHost,
      r'^(?:[A-Za-z0-9-]+\.)+[A-Za-z][A-Za-z0-9-]*$',
      'APP_WEB_HOST',
    );
    _requireMatch(
      webAppPathPrefix,
      r'^/(?:[A-Za-z0-9._~-]+(?:/[A-Za-z0-9._~-]+)*)?$',
      'APP_WEB_PATH_PREFIX',
    );
    _validateOptionalHttpsUrl(communityChatUrl, 'APP_COMMUNITY_CHAT_URL');
    _validateOptionalAbsoluteUri(calendarEventUrl, 'APP_CALENDAR_EVENT_URL');
    _validateNfcPass();
    _validateHttpsUrl(communityForumUrl, 'APP_COMMUNITY_FORUM_URL');
    _validateCalendarDate(
      winterSessionStartMonth,
      winterSessionStartDay,
      'WINTER_SESSION_START',
    );
    _validateCalendarDate(
      summerSessionStartMonth,
      summerSessionStartDay,
      'SUMMER_SESSION_START',
    );
    _validateOptions(mentorTopicKeys, 'MENTOR_TOPIC_KEYS');
    _validateOptions(mentorLevelKeys, 'MENTOR_LEVEL_KEYS');
    _validateOptions(mentorFormatKeys, 'MENTOR_FORMAT_KEYS');
    _validateOptions(mentorWhenSlotKeys, 'MENTOR_WHEN_SLOT_KEYS');
    _validateOptions(teamKindKeys, 'TEAM_KIND_KEYS');
    _validateOptions(teamRoleKeys, 'TEAM_ROLE_KEYS');
    _validateOptions(marketplaceCategoryKeys, 'MARKETPLACE_CATEGORY_KEYS');
    _validateOptions(lostFoundCategoryKeys, 'LOST_FOUND_CATEGORY_KEYS');
    _validateBellSlots();
    _validateIntegerOptions(
      lessonColorValues,
      'LESSON_COLOR_VALUES',
      minimum: 0,
      maximum: 0xFFFFFFFF,
    );
    _validateIntegerOptions(
      lessonReminderLeadMinutes,
      'LESSON_REMINDER_LEAD_MINUTES',
      minimum: 1,
      maximum: Duration.minutesPerDay,
    );
    for (final category in marketplaceCategoryKeys) {
      _requireMatch(
        category,
        r'^[a-z][a-z0-9_]{0,39}$',
        'MARKETPLACE_CATEGORY_KEYS',
      );
    }
    for (final category in lostFoundCategoryKeys) {
      _requireMatch(
        category,
        r'^[a-z][a-z0-9_]{0,39}$',
        'LOST_FOUND_CATEGORY_KEYS',
      );
    }
    _requireMatch(
      marketplaceCurrencyCode,
      r'^[A-Z]{3}$',
      'MARKETPLACE_CURRENCY_CODE',
    );
    if (mentorWhenSlotKeys.any(
      (value) => !const {'tonight', 'tomorrow', 'week'}.contains(value),
    )) {
      throw ArgumentError.value(mentorWhenSlotKeys, 'MENTOR_WHEN_SLOT_KEYS');
    }
  }

  static void _validateOptionalAbsoluteUri(String? value, String key) {
    if (value == null) return;

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isAbsolute || uri.scheme == 'http') {
      throw ArgumentError.value(value, key);
    }
  }

  void _validateNfcPass() {
    _validateHttpsUrl(nfcPass.oauthUrl, 'APP_NFC_PASS_OAUTH_URL');
    _validateHttpsUrl(
      nfcPass.accessTokenUrl,
      'APP_NFC_PASS_ACCESS_TOKEN_URL',
    );
    _validateHttpsUrl(
      nfcPass.sendVerificationCodeUrl,
      'APP_NFC_PASS_SEND_CODE_URL',
    );
    _validateHttpsUrl(nfcPass.getDigitalPassUrl, 'APP_NFC_PASS_GET_PASS_URL');
    if (nfcPass.redirectUrls.isEmpty) {
      throw ArgumentError.value(
        nfcPass.redirectUrls,
        'APP_NFC_PASS_REDIRECT_URLS',
      );
    }
    for (final url in nfcPass.redirectUrls) {
      _validateHttpsUrl(url, 'APP_NFC_PASS_REDIRECT_URLS');
    }
  }

  void _validateWebsite() {
    _validateHttpsUrl(websiteUrl, 'UNIVERSITY_WEBSITE_URL');
  }

  static void _validateHttpsUrl(String value, String name) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw ArgumentError.value(value, name);
    }
  }

  static void _validateOptionalHttpsUrl(String? value, String name) {
    if (value == null) return;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw ArgumentError.value(value, name);
    }
  }

  void _validateEmailDomains() {
    if (allowedEmailDomains.isEmpty ||
        allowedEmailDomains.toSet().length != allowedEmailDomains.length ||
        allowedEmailDomains.any(
          (domain) => !RegExp(
            r'^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+'
            r'[a-z](?:[a-z0-9-]{0,61}[a-z0-9])?$',
          ).hasMatch(domain),
        )) {
      throw ArgumentError.value(
        allowedEmailDomains,
        'APP_ALLOWED_EMAIL_DOMAINS',
      );
    }
  }

  static void _requireMatch(String value, String pattern, String name) {
    if (!RegExp(pattern).hasMatch(value)) {
      throw ArgumentError.value(value, name);
    }
  }

  static void _validateCalendarDate(int month, int day, String name) {
    final date = DateTime(2024, month, day);
    if (date.month != month || date.day != day) {
      throw ArgumentError.value('$month-$day', name);
    }
  }

  static List<String> _csv(String raw) => raw
      .split(',')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);

  static String? _optionalString(String value) => value.isEmpty ? null : value;

  static List<LessonBellSlotConfig> _bellSlots(String raw) => _csv(raw)
      .map((value) {
        final [start, end] = switch (value.split('-')) {
          [final parsedStart, final parsedEnd] => [parsedStart, parsedEnd],
          _ => throw ArgumentError.value(raw, 'LESSON_BELL_SLOTS'),
        };
        return LessonBellSlotConfig(
          startMinutes: _timeMinutes(start, 'LESSON_BELL_SLOTS'),
          endMinutes: _timeMinutes(end, 'LESSON_BELL_SLOTS'),
        );
      })
      .toList(growable: false);

  static List<int> _colorValues(String raw) => _csv(raw)
      .map((value) {
        final normalized = value.replaceFirst('#', '');
        if (!RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(normalized)) {
          throw ArgumentError.value(value, 'LESSON_COLOR_VALUES');
        }
        final parsed = int.tryParse(normalized, radix: 16);
        if (parsed == null) {
          throw ArgumentError.value(value, 'LESSON_COLOR_VALUES');
        }
        return parsed;
      })
      .toList(growable: false);

  static List<int> _integers(String raw, String name) => _csv(raw)
      .map((value) {
        final parsed = int.tryParse(value);
        if (parsed == null) throw ArgumentError.value(value, name);
        return parsed;
      })
      .toList(growable: false);

  static int _timeMinutes(String value, String name) {
    final [hourText, minuteText] = switch (value.split(':')) {
      [final hour, final minute] => [hour, minute],
      _ => throw ArgumentError.value(value, name),
    };
    final hour = int.tryParse(hourText);
    final minute = int.tryParse(minuteText);
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      throw ArgumentError.value(value, name);
    }
    return hour * Duration.minutesPerHour + minute;
  }

  static void _validateOptions(List<String> values, String name) {
    if (values.isEmpty || values.toSet().length != values.length) {
      throw ArgumentError.value(values, name);
    }
  }

  void _validateBellSlots() {
    if (lessonBellSlots.isEmpty) {
      throw ArgumentError.value(lessonBellSlots, 'LESSON_BELL_SLOTS');
    }
    var previousEnd = -1;
    for (final slot in lessonBellSlots) {
      if (slot.startMinutes < 0 ||
          slot.endMinutes > Duration.minutesPerDay ||
          slot.startMinutes >= slot.endMinutes ||
          slot.startMinutes < previousEnd) {
        throw ArgumentError.value(lessonBellSlots, 'LESSON_BELL_SLOTS');
      }
      previousEnd = slot.endMinutes;
    }
  }

  static void _validateIntegerOptions(
    List<int> values,
    String name, {
    required int minimum,
    required int maximum,
  }) {
    if (values.isEmpty ||
        values.toSet().length != values.length ||
        values.any((value) => value < minimum || value > maximum)) {
      throw ArgumentError.value(values, name);
    }
  }
}

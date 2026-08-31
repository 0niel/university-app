import 'dart:convert';

final class UniversityDeploymentConfig {
  const UniversityDeploymentConfig({
    required this.organizationId,
    required this.appDisplayName,
    required this.universityName,
    required this.universityShortName,
    required this.universityWebsiteUrl,
    required this.appSupportEmail,
    required this.appDeepLinkScheme,
    required this.appWebHost,
    required this.appWebPathPrefix,
    required this.lessonBellSlots,
    required this.lessonColorValues,
    required this.lessonReminderLeadMinutes,
    this.appCommunityChatUrl,
    this.appCommunityForumUrl,
    this.appCalendarEventUrl,
    this.appNfcPassOauthUrl,
    this.appNfcPassRedirectUrls,
    this.appNfcPassAccessTokenUrl,
    this.appNfcPassSendCodeUrl,
    this.appNfcPassGetPassUrl,
    this.appAllowedEmailDomains,
    this.appEnabledCapabilities,
  });

  factory UniversityDeploymentConfig.fromJsonString(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UniversityConfigurationException(
          'Configuration is not valid JSON: ${error.message}',
        ),
        stackTrace,
      );
    }

    if (decoded is! Map<String, Object?>) {
      throw const UniversityConfigurationException(
        'Configuration must be a JSON object.',
      );
    }

    final actualKeys = decoded.keys.toSet();
    final missingKeys = _requiredKeys.difference(actualKeys).toList()..sort();
    final unknownKeys = actualKeys.difference(_supportedKeys).toList()..sort();
    if (missingKeys.isNotEmpty || unknownKeys.isNotEmpty) {
      final details = <String>[
        if (missingKeys.isNotEmpty) 'missing: ${missingKeys.join(', ')}',
        if (unknownKeys.isNotEmpty) 'unknown: ${unknownKeys.join(', ')}',
      ];
      throw UniversityConfigurationException(
        'Configuration keys do not match the schema (${details.join('; ')}).',
      );
    }

    final values = <String, String>{};
    for (final key in actualKeys) {
      final value = decoded[key];
      if (value is! String) {
        throw UniversityConfigurationException('$key must be a string.');
      }
      if (value != value.trim() || value.isEmpty) {
        throw UniversityConfigurationException(
          '$key must be a non-empty string without surrounding whitespace.',
        );
      }
      if (value.runes.any((rune) => rune < 0x20 || rune == 0x7f)) {
        throw UniversityConfigurationException(
          '$key must not contain control characters.',
        );
      }
      if (value.contains(r'$') ||
          value.contains('//') &&
              !const {
                'UNIVERSITY_WEBSITE_URL',
                'APP_COMMUNITY_CHAT_URL',
                'APP_COMMUNITY_FORUM_URL',
                'APP_CALENDAR_EVENT_URL',
                'APP_NFC_PASS_OAUTH_URL',
                'APP_NFC_PASS_REDIRECT_URLS',
                'APP_NFC_PASS_ACCESS_TOKEN_URL',
                'APP_NFC_PASS_SEND_CODE_URL',
                'APP_NFC_PASS_GET_PASS_URL',
              }.contains(key) ||
          value.contains('/*') ||
          value.contains('*/')) {
        throw UniversityConfigurationException(
          '$key contains syntax reserved by generated native configuration.',
        );
      }
      values[key] = value;
    }

    final organizationId = _valueFor(values, 'APP_ORGANIZATION_ID');
    final appDisplayName = _valueFor(values, 'APP_DISPLAY_NAME');
    final universityName = _valueFor(values, 'UNIVERSITY_NAME');
    final universityShortName = _valueFor(values, 'UNIVERSITY_SHORT_NAME');
    final universityWebsiteUrl = _valueFor(values, 'UNIVERSITY_WEBSITE_URL');
    final appSupportEmail = _valueFor(values, 'APP_SUPPORT_EMAIL');
    final appDeepLinkScheme = _valueFor(values, 'APP_DEEP_LINK_SCHEME');
    final appWebHost = _valueFor(values, 'APP_WEB_HOST');
    final appWebPathPrefix = _valueFor(values, 'APP_WEB_PATH_PREFIX');
    final appCommunityChatUrl = values['APP_COMMUNITY_CHAT_URL'];
    final appCommunityForumUrl = values['APP_COMMUNITY_FORUM_URL'];
    final appCalendarEventUrl = values['APP_CALENDAR_EVENT_URL'];
    final appNfcPassOauthUrl = values['APP_NFC_PASS_OAUTH_URL'];
    final appNfcPassRedirectUrls = values['APP_NFC_PASS_REDIRECT_URLS'];
    final appNfcPassAccessTokenUrl = values['APP_NFC_PASS_ACCESS_TOKEN_URL'];
    final appNfcPassSendCodeUrl = values['APP_NFC_PASS_SEND_CODE_URL'];
    final appNfcPassGetPassUrl = values['APP_NFC_PASS_GET_PASS_URL'];
    final appAllowedEmailDomains = values['APP_ALLOWED_EMAIL_DOMAINS'];
    final appEnabledCapabilities = values['APP_ENABLED_CAPABILITIES'];
    final lessonBellSlots =
        values['LESSON_BELL_SLOTS'] ?? _defaultLessonBellSlots;
    final lessonColorValues =
        values['LESSON_COLOR_VALUES'] ?? _defaultLessonColorValues;
    final lessonReminderLeadMinutes =
        values['LESSON_REMINDER_LEAD_MINUTES'] ??
        _defaultLessonReminderLeadMinutes;

    _validateOrganizationId(organizationId);
    _validateName('APP_DISPLAY_NAME', appDisplayName);
    _validateName('UNIVERSITY_NAME', universityName);
    _validateName(
      'UNIVERSITY_SHORT_NAME',
      universityShortName,
      maximumLength: 40,
    );
    _validateWebsite(universityWebsiteUrl);
    _validateEmail(appSupportEmail);
    _validateDeepLinkScheme(appDeepLinkScheme);
    _validateWebHost(appWebHost);
    _validateWebPathPrefix(appWebPathPrefix);
    _validateOptionalHttpsUrl('APP_COMMUNITY_CHAT_URL', appCommunityChatUrl);
    _validateOptionalHttpsUrl('APP_COMMUNITY_FORUM_URL', appCommunityForumUrl);
    _validateOptionalAbsoluteUri('APP_CALENDAR_EVENT_URL', appCalendarEventUrl);
    _validateOptionalHttpsUrl('APP_NFC_PASS_OAUTH_URL', appNfcPassOauthUrl);
    _validateOptionalCsvHttpsUrls(
      'APP_NFC_PASS_REDIRECT_URLS',
      appNfcPassRedirectUrls,
    );
    _validateOptionalHttpsUrl(
      'APP_NFC_PASS_ACCESS_TOKEN_URL',
      appNfcPassAccessTokenUrl,
    );
    _validateOptionalHttpsUrl(
      'APP_NFC_PASS_SEND_CODE_URL',
      appNfcPassSendCodeUrl,
    );
    _validateOptionalHttpsUrl(
      'APP_NFC_PASS_GET_PASS_URL',
      appNfcPassGetPassUrl,
    );
    _validateOptionalEmailDomains(
      'APP_ALLOWED_EMAIL_DOMAINS',
      appAllowedEmailDomains,
    );
    _validateOptionalCapabilities(appEnabledCapabilities);
    _validateLessonBellSlots(lessonBellSlots);
    _validateLessonColorValues(lessonColorValues);
    _validateLessonReminderLeadMinutes(lessonReminderLeadMinutes);

    return UniversityDeploymentConfig(
      organizationId: organizationId,
      appDisplayName: appDisplayName,
      universityName: universityName,
      universityShortName: universityShortName,
      universityWebsiteUrl: universityWebsiteUrl,
      appSupportEmail: appSupportEmail,
      appDeepLinkScheme: appDeepLinkScheme,
      appWebHost: appWebHost,
      appWebPathPrefix: appWebPathPrefix,
      appCommunityChatUrl: appCommunityChatUrl,
      appCommunityForumUrl: appCommunityForumUrl,
      appCalendarEventUrl: appCalendarEventUrl,
      appNfcPassOauthUrl: appNfcPassOauthUrl,
      appNfcPassRedirectUrls: appNfcPassRedirectUrls,
      appNfcPassAccessTokenUrl: appNfcPassAccessTokenUrl,
      appNfcPassSendCodeUrl: appNfcPassSendCodeUrl,
      appNfcPassGetPassUrl: appNfcPassGetPassUrl,
      appAllowedEmailDomains: appAllowedEmailDomains,
      appEnabledCapabilities: appEnabledCapabilities,
      lessonBellSlots: lessonBellSlots,
      lessonColorValues: lessonColorValues,
      lessonReminderLeadMinutes: lessonReminderLeadMinutes,
    );
  }

  static const _requiredKeys = {
    'APP_ORGANIZATION_ID',
    'APP_DISPLAY_NAME',
    'UNIVERSITY_NAME',
    'UNIVERSITY_SHORT_NAME',
    'UNIVERSITY_WEBSITE_URL',
    'APP_SUPPORT_EMAIL',
    'APP_DEEP_LINK_SCHEME',
    'APP_WEB_HOST',
    'APP_WEB_PATH_PREFIX',
  };
  static const _optionalKeys = {
    'APP_COMMUNITY_CHAT_URL',
    'APP_COMMUNITY_FORUM_URL',
    'APP_CALENDAR_EVENT_URL',
    'APP_NFC_PASS_OAUTH_URL',
    'APP_NFC_PASS_REDIRECT_URLS',
    'APP_NFC_PASS_ACCESS_TOKEN_URL',
    'APP_NFC_PASS_SEND_CODE_URL',
    'APP_NFC_PASS_GET_PASS_URL',
    'APP_ALLOWED_EMAIL_DOMAINS',
    'APP_ENABLED_CAPABILITIES',
    'LESSON_BELL_SLOTS',
    'LESSON_COLOR_VALUES',
    'LESSON_REMINDER_LEAD_MINUTES',
  };
  static const Set<String> _supportedKeys = {
    ..._requiredKeys,
    ..._optionalKeys,
  };
  static const _defaultLessonBellSlots =
      '09:00-10:30,10:40-12:10,12:40-14:10,14:20-15:50,'
      '16:20-17:50,18:00-19:30,19:40-21:10';
  static const _defaultLessonColorValues =
      'FF2F7AFF,FFA45CFF,FFFF8A2F,FF1FB872,FFFF4F4F,FFFF6FB1';
  static const _defaultLessonReminderLeadMinutes = '5,10,15,30,60';

  final String organizationId;
  final String appDisplayName;
  final String universityName;
  final String universityShortName;
  final String universityWebsiteUrl;
  final String appSupportEmail;
  final String appDeepLinkScheme;
  final String appWebHost;
  final String appWebPathPrefix;
  final String? appCommunityChatUrl;
  final String? appCommunityForumUrl;
  final String? appCalendarEventUrl;
  final String? appNfcPassOauthUrl;
  final String? appNfcPassRedirectUrls;
  final String? appNfcPassAccessTokenUrl;
  final String? appNfcPassSendCodeUrl;
  final String? appNfcPassGetPassUrl;
  final String? appAllowedEmailDomains;
  final String? appEnabledCapabilities;
  final String lessonBellSlots;
  final String lessonColorValues;
  final String lessonReminderLeadMinutes;

  Map<String, String> toEnvironmentMap() {
    final values = {
      'APP_ORGANIZATION_ID': organizationId,
      'APP_DISPLAY_NAME': appDisplayName,
      'UNIVERSITY_NAME': universityName,
      'UNIVERSITY_SHORT_NAME': universityShortName,
      'UNIVERSITY_WEBSITE_URL': universityWebsiteUrl,
      'APP_SUPPORT_EMAIL': appSupportEmail,
      'APP_DEEP_LINK_SCHEME': appDeepLinkScheme,
      'APP_WEB_HOST': appWebHost,
      'APP_WEB_PATH_PREFIX': appWebPathPrefix,
      'LESSON_BELL_SLOTS': lessonBellSlots,
      'LESSON_COLOR_VALUES': lessonColorValues,
      'LESSON_REMINDER_LEAD_MINUTES': lessonReminderLeadMinutes,
    };
    final chatUrl = appCommunityChatUrl;
    if (chatUrl != null) values['APP_COMMUNITY_CHAT_URL'] = chatUrl;
    final forumUrl = appCommunityForumUrl;
    if (forumUrl != null) values['APP_COMMUNITY_FORUM_URL'] = forumUrl;
    final calendarEventUrl = appCalendarEventUrl;
    if (calendarEventUrl != null) {
      values['APP_CALENDAR_EVENT_URL'] = calendarEventUrl;
    }
    final nfcPassOauthUrl = appNfcPassOauthUrl;
    if (nfcPassOauthUrl != null) {
      values['APP_NFC_PASS_OAUTH_URL'] = nfcPassOauthUrl;
    }
    final nfcPassRedirectUrls = appNfcPassRedirectUrls;
    if (nfcPassRedirectUrls != null) {
      values['APP_NFC_PASS_REDIRECT_URLS'] = nfcPassRedirectUrls;
    }
    final nfcPassAccessTokenUrl = appNfcPassAccessTokenUrl;
    if (nfcPassAccessTokenUrl != null) {
      values['APP_NFC_PASS_ACCESS_TOKEN_URL'] = nfcPassAccessTokenUrl;
    }
    final nfcPassSendCodeUrl = appNfcPassSendCodeUrl;
    if (nfcPassSendCodeUrl != null) {
      values['APP_NFC_PASS_SEND_CODE_URL'] = nfcPassSendCodeUrl;
    }
    final nfcPassGetPassUrl = appNfcPassGetPassUrl;
    if (nfcPassGetPassUrl != null) {
      values['APP_NFC_PASS_GET_PASS_URL'] = nfcPassGetPassUrl;
    }
    final emailDomains = appAllowedEmailDomains;
    if (emailDomains != null) {
      values['APP_ALLOWED_EMAIL_DOMAINS'] = emailDomains;
    }
    final capabilities = appEnabledCapabilities;
    if (capabilities != null) {
      values['APP_ENABLED_CAPABILITIES'] = capabilities;
    }
    return values;
  }

  static String _valueFor(Map<String, String> values, String key) {
    final value = values[key];
    if (value == null) {
      throw StateError('Validated configuration is missing $key.');
    }
    return value;
  }

  static void _validateOrganizationId(String value) {
    if (value.length > 63 ||
        !RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(value)) {
      throw const UniversityConfigurationException(
        'APP_ORGANIZATION_ID must be a lowercase kebab-case identifier with '
        'at most 63 characters.',
      );
    }
  }

  static void _validateName(
    String key,
    String value, {
    int maximumLength = 120,
  }) {
    if (value.runes.length > maximumLength) {
      throw UniversityConfigurationException(
        '$key must contain at most $maximumLength characters.',
      );
    }
  }

  static void _validateWebsite(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const UniversityConfigurationException(
        'UNIVERSITY_WEBSITE_URL must be an HTTPS URL without credentials, '
        'query parameters, or a fragment.',
      );
    }
  }

  static void _validateOptionalHttpsUrl(String key, String? value) {
    if (value == null) return;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw UniversityConfigurationException('$key must be an HTTPS URL.');
    }
  }

  static void _validateOptionalAbsoluteUri(String key, String? value) {
    if (value == null) return;

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isAbsolute || uri.scheme == 'http') {
      throw UniversityConfigurationException(
        '$key must be an absolute HTTPS or custom-scheme URL.',
      );
    }
  }

  static void _validateOptionalCsvHttpsUrls(String key, String? value) {
    if (value == null) return;
    final urls = value.split(',');
    if (urls.toSet().length != urls.length) {
      throw UniversityConfigurationException(
        '$key must contain unique comma-separated HTTPS URLs.',
      );
    }
    for (final url in urls) {
      _validateOptionalHttpsUrl(key, url);
    }
  }

  static void _validateOptionalEmailDomains(String key, String? value) {
    if (value == null) return;
    final domains = value.split(',');
    final domainPattern = RegExp(
      r'^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+'
      r'[a-z](?:[a-z0-9-]{0,61}[a-z0-9])?$',
    );
    if (domains.isEmpty ||
        domains.toSet().length != domains.length ||
        domains.any((domain) => !domainPattern.hasMatch(domain))) {
      throw UniversityConfigurationException(
        '$key must contain unique comma-separated lowercase email domains.',
      );
    }
  }

  static void _validateOptionalCapabilities(String? value) {
    if (value == null) return;
    const allowed = {'campus_map', 'nfc_pass', 'virtual_tour'};
    final values = value.split(',');
    if (values.isEmpty ||
        values.toSet().length != values.length ||
        values.any((item) => !allowed.contains(item))) {
      throw const UniversityConfigurationException(
        'APP_ENABLED_CAPABILITIES must contain unique supported values.',
      );
    }
  }

  static void _validateEmail(String value) {
    if (value.length > 254 ||
        !RegExp(
          r'^[A-Za-z0-9.!#$%&\x27*+/=?^_`{|}~-]+@'
          '[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
          r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$',
        ).hasMatch(value)) {
      throw const UniversityConfigurationException(
        'APP_SUPPORT_EMAIL must be a valid email address.',
      );
    }
  }

  static void _validateDeepLinkScheme(String value) {
    if (value.length > 63 ||
        !RegExp(r'^[a-z][a-z0-9+.-]*$').hasMatch(value) ||
        value == 'http' ||
        value == 'https') {
      throw const UniversityConfigurationException(
        'APP_DEEP_LINK_SCHEME must be a lowercase custom URI scheme.',
      );
    }
  }

  static void _validateWebHost(String value) {
    if (value.length > 253 ||
        !RegExp(
          r'^(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+'
          r'[A-Za-z](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?$',
        ).hasMatch(value)) {
      throw const UniversityConfigurationException(
        'APP_WEB_HOST must be a DNS hostname without a scheme, port, or path.',
      );
    }
  }

  static void _validateWebPathPrefix(String value) {
    if (value != '/' &&
        !RegExp(r'^/[A-Za-z0-9._~-]+(?:/[A-Za-z0-9._~-]+)*$').hasMatch(value)) {
      throw const UniversityConfigurationException(
        'APP_WEB_PATH_PREFIX must be / or an absolute URL path without a '
        'trailing slash.',
      );
    }
  }

  static void _validateLessonBellSlots(String value) {
    final slots = value.split(',');
    if (slots.isEmpty) {
      throw const UniversityConfigurationException(
        'LESSON_BELL_SLOTS must contain at least one time range.',
      );
    }
    var previousEnd = -1;
    for (final slot in slots) {
      final match = RegExp(
        r'^(\d{2}):(\d{2})-(\d{2}):(\d{2})$',
      ).firstMatch(slot);
      if (match == null) {
        throw const UniversityConfigurationException(
          'LESSON_BELL_SLOTS must use comma-separated HH:mm-HH:mm ranges.',
        );
      }
      final start = _minutes(match.group(1), match.group(2));
      final end = _minutes(match.group(3), match.group(4));
      if (start == null || end == null || start >= end || start < previousEnd) {
        throw const UniversityConfigurationException(
          'LESSON_BELL_SLOTS ranges must be valid, ordered, and '
          'non-overlapping.',
        );
      }
      previousEnd = end;
    }
  }

  static void _validateLessonColorValues(String value) {
    final colors = value.split(',');
    if (colors.isEmpty ||
        colors.toSet().length != colors.length ||
        colors.any((color) => !RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(color))) {
      throw const UniversityConfigurationException(
        'LESSON_COLOR_VALUES must contain unique eight-digit ARGB colors.',
      );
    }
  }

  static void _validateLessonReminderLeadMinutes(String value) {
    final values = value.split(',').map(int.tryParse).toList();
    if (values.isEmpty ||
        values.toSet().length != values.length ||
        values.any(
          (minutes) => minutes == null || minutes < 1 || minutes > 1440,
        )) {
      throw const UniversityConfigurationException(
        'LESSON_REMINDER_LEAD_MINUTES must contain unique values from 1 to '
        '1440.',
      );
    }
  }

  static int? _minutes(String? hourText, String? minuteText) {
    final hour = int.tryParse(hourText ?? '');
    final minute = int.tryParse(minuteText ?? '');
    if (hour == null || minute == null || hour > 23 || minute > 59) return null;
    return hour * Duration.minutesPerHour + minute;
  }
}

final class UniversityConfigurationException implements Exception {
  const UniversityConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}

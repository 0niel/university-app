import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// The translations for English (`en`).
class NeonLocalizationsEn extends NeonLocalizations {
  NeonLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get nextcloud => 'Nextcloud';

  @override
  String get nextcloudLogo => 'Nextcloud logo';

  @override
  String appImplementationName(String app) {
    String _temp0 = intl.Intl.selectLogic(
      app,
      {
        'nextcloud': 'Nextcloud',
        'core': 'Server',
        'dashboard': 'Dashboard',
        'files': 'Files',
        'news': 'News',
        'notes': 'Notes',
        'notifications': 'Notifications',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get loginAgain => 'Login again';

  @override
  String get loginOpenAgain => 'Open again';

  @override
  String get loginSwitchToBrowserWindow => 'Please switch to the browser window that just opened and proceed there';

  @override
  String get loginWorksWith => 'works with';

  @override
  String get loginUsingQRcode => 'Login using a QR code';

  @override
  String get loginUsingServerAddress => 'Login using the server address';

  @override
  String get loginCheckingServerVersion => 'Checking server version';

  @override
  String loginSupportedServerVersion(String version) {
    return 'Supported server version: $version';
  }

  @override
  String loginUnsupportedServerVersion(String version) {
    return 'Unsupported server version: $version';
  }

  @override
  String get loginCheckingMaintenanceMode => 'Checking maintenance mode';

  @override
  String get loginMaintenanceModeEnabled => 'Maintenance mode enabled';

  @override
  String get loginMaintenanceModeDisabled => 'Maintenance mode disabled';

  @override
  String get loginCheckingAccount => 'Checking account';

  @override
  String get errorCredentialsForAccountNoLongerMatch => 'The credentials for this account no longer match';

  @override
  String get errorServerHadAProblemProcessingYourRequest =>
      'The server had a problem while processing your request. You might want to try again';

  @override
  String get errorSomethingWentWrongTryAgainLater => 'Something went wrong. Please try again later';

  @override
  String get errorUnableToReachServer => 'Unable to reach the server';

  @override
  String errorUnableToReachServerAt(String url) {
    return 'Unable to reach the server at $url';
  }

  @override
  String get errorConnectionTimedOut => 'Connection has timed out';

  @override
  String get errorNoCompatibleNextcloudAppsFound =>
      'No compatible Nextcloud apps could be found.\nWe are working hard to implement more and more apps!';

  @override
  String get errorServerInMaintenanceMode =>
      'The server is in maintenance mode. Please try again later or contact the server admin.';

  @override
  String errorMissingPermission(String name) {
    return 'Permission for $name is missing';
  }

  @override
  String errorUnsupportedAppVersions(String names) {
    return 'Sorry, the version of the following apps on your Nextcloud instance are not supported. \n $names \n Please contact your administrator to resolve the issues.';
  }

  @override
  String get errorEmptyField => 'This field can not be empty';

  @override
  String get errorInvalidURL => 'Invalid URL provided';

  @override
  String get errorInvalidQRcode => 'Invalid QR-Code provided';

  @override
  String errorRouteNotFound(String route) {
    return 'Route not found: $route';
  }

  @override
  String get errorDialog => 'An error has occurred';

  @override
  String get actionYes => 'Yes';

  @override
  String get actionNo => 'No';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionShowSlashHide => 'Show/Hide';

  @override
  String get actionExit => 'Exit';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get firstLaunchGoToSettingsToEnablePushNotifications => 'Go to the settings to enable push notifications';

  @override
  String get nextPushSupported => 'NextPush is supported!';

  @override
  String get nextPushSupportedText =>
      'NextPush is a FOSS way of receiving push notifications using the UnifiedPush protocol via a Nextcloud instance.\nYou can install NextPush from the F-Droid app store.';

  @override
  String get nextPushSupportedInstall => 'Install NextPush';

  @override
  String get search => 'Search';

  @override
  String get searchCancel => 'Cancel search';

  @override
  String get searchNoResults => 'No search results';

  @override
  String get settings => 'Settings';

  @override
  String get settingsApps => 'Apps';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAccountManage => 'Manage accounts';

  @override
  String get settingsExport => 'Export settings';

  @override
  String get settingsImport => 'Import settings';

  @override
  String get settingsReset => 'Reset settings?';

  @override
  String get settingsImportWrongFileExtension => 'Settings import has wrong file extension (has to be .json.base64)';

  @override
  String get settingsResetAll => 'Reset all settings';

  @override
  String get settingsResetAllConfirmation => 'Do you want to reset all settings?';

  @override
  String get settingsResetAllExplanation => 'This will reset all preferences back to their default settings.';

  @override
  String settingsResetFor(String name) {
    return 'Reset all settings for $name';
  }

  @override
  String get settingsResetForExplanation => 'This will reset your account preferences back to their default settings.';

  @override
  String get settingsResetForClientExplanation =>
      'This will reset all preferences for the app back to their default settings.';

  @override
  String settingsResetForConfirmation(String name) {
    return 'Do you want to reset all settings for $name?';
  }

  @override
  String get optionsCategoryGeneral => 'General';

  @override
  String get optionsCategoryTheme => 'Theme';

  @override
  String get optionsCategoryPushNotifications => 'Push notifications';

  @override
  String get optionsCategoryOther => 'Other';

  @override
  String get optionsCategoryAccounts => 'Accounts';

  @override
  String get optionsCategoryStartup => 'Startup';

  @override
  String get optionsCategoryNavigation => 'Navigation';

  @override
  String get optionsSortOrderAscending => 'Ascending';

  @override
  String get optionsSortOrderDescending => 'Descending';

  @override
  String get globalOptionsThemeMode => 'Theme mode';

  @override
  String get globalOptionsThemeModeLight => 'Light';

  @override
  String get globalOptionsThemeModeDark => 'Dark';

  @override
  String get globalOptionsThemeModeAutomatic => 'Automatic';

  @override
  String get globalOptionsThemeOLEDAsDark => 'OLED theme as dark theme';

  @override
  String get globalOptionsThemeUseNextcloudTheme => 'Use Nextcloud theme';

  @override
  String get globalOptionsThemeCustomBackground => 'Custom background';

  @override
  String get globalOptionsPushNotificationsEnabled => 'Enabled';

  @override
  String get globalOptionsPushNotificationsEnabledDisabledNotice =>
      'No UnifiedPush distributor could be found or you denied the permission for showing notifications. Please go to the app settings and allow notifications and go to https://unifiedpush.org/users/distributors and setup any of the listed distributors. Then re-open this app and you should be able to enable notifications';

  @override
  String get globalOptionsPushNotificationsDistributor => 'UnifiedPush Distributor';

  @override
  String get globalOptionsPushNotificationsDistributorGotifyUP => 'Gotify-UP (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorFirebaseEmbedded => 'Firebase (proprietary)';

  @override
  String get globalOptionsPushNotificationsDistributorNtfy => 'ntfy (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorFCMUP => 'FCM-UP (proprietary)';

  @override
  String get globalOptionsPushNotificationsDistributorNextPush => 'NextPush (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorNoProvider2Push => 'NoProvider2Push (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorConversations => 'Conversations';

  @override
  String get globalOptionsStartupMinimized => 'Start minimized';

  @override
  String get globalOptionsStartupMinimizeInsteadOfExit => 'Minimize instead of exit';

  @override
  String get globalOptionsAccountsRememberLastUsedAccount => 'Remember last used account';

  @override
  String get globalOptionsAccountsInitialAccount => 'Initial account';

  @override
  String get globalOptionsAccountsAdd => 'Add account';

  @override
  String get globalOptionsNavigationMode => 'Navigation mode';

  @override
  String get globalOptionsNavigationModeDrawer => 'Drawer';

  @override
  String get globalOptionsNavigationModeDrawerAlwaysVisible => 'Drawer always visible';

  @override
  String get accountOptionsRemove => 'Remove account';

  @override
  String accountOptionsRemoveConfirm(String id) {
    return 'Are you sure you want to remove the account $id?';
  }

  @override
  String get accountOptionsCategoryStorageInfo => 'Storage info';

  @override
  String accountOptionsQuotaUsedOf(String used, String total, String relative) {
    return '$used used of $total ($relative%)';
  }

  @override
  String get accountOptionsInitialApp => 'App to show initially';

  @override
  String get accountOptionsAutomatic => 'Automatic';

  @override
  String get licenses => 'Licenses';

  @override
  String get sourceCode => 'Source code';

  @override
  String get issueTracker => 'Report a bug or request a feature';

  @override
  String get relativeTimeNow => 'now';

  @override
  String relativeTimePast(String time) {
    return '$time ago';
  }

  @override
  String relativeTimeFuture(String time) {
    return 'in $time';
  }

  @override
  String relativeTimeMinutes(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeHours(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeDays(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeYears(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$time $_temp0';
  }
}

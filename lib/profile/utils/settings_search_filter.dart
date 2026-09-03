import 'package:rtu_mirea_app/l10n/l10n.dart';

class SettingsSearchFilter {
  SettingsSearchFilter({required String query, required this.l10n})
    : _query = query.trim().toLowerCase();

  final AppLocalizations l10n;
  final String _query;

  bool get isActive => _query.isNotEmpty;

  bool get showAppearance => _matches([
    l10n.settingsAppearance,
    l10n.settingsTheme,
    l10n.settingsLessonColors,
    l10n.settingsAmoledTitle,
  ]);

  bool get showNotifications => _matches([
    l10n.notifications,
    l10n.settingsNotificationsOn,
    l10n.settingsNotificationsOff,
  ]);

  bool get showPrivacy => _matches([
    l10n.settingsPrivacy,
    l10n.settingsWhoSeesProfile,
    l10n.settingsAnonymousReactions,
    l10n.settingsBiometricsPass,
    l10n.settingsNfcEmulation,
  ]);

  bool get showSchedule => _matches([
    l10n.schedule,
    l10n.settingsMyGroup,
    l10n.settingsLessonReactions,
    l10n.settingsExportCalendar,
  ]);

  bool get showHome => _matches([
    l10n.settingsHomeAndWidgets,
    l10n.settingsAppTour,
    l10n.settingsHomeContent,
    l10n.settingsQuickServices,
    l10n.settingsScreenWidgets,
  ]);

  bool get showSupport => _matches([l10n.supportOurService]);

  bool get showData => _matches([
    l10n.settingsDataAndLanguage,
    l10n.settingsLanguage,
    l10n.settingsSync,
    l10n.settingsClearCache,
  ]);

  bool get showAbout => _matches([l10n.aboutApp]);

  bool get showAccount => _matches([
    l10n.profileAccount,
    l10n.settingsManageAccount,
    l10n.profileSignOut,
  ]);

  bool get hasResults =>
      showAppearance ||
      showNotifications ||
      showPrivacy ||
      showSchedule ||
      showHome ||
      showSupport ||
      showData ||
      showAbout ||
      showAccount;

  bool _matches(List<String> values) =>
      _query.isEmpty ||
      values.any((value) => value.toLowerCase().contains(_query));
}

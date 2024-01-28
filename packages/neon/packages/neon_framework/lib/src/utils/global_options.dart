import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/label_builder.dart';
import 'package:neon_framework/src/settings/models/option.dart';
import 'package:neon_framework/src/settings/models/options_collection.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';

/// The package id of the NextPush UnifiedPush distributor.
const unifiedPushNextPushID = 'org.unifiedpush.distributor.nextpush';

/// Global options for the Neon framework.
@internal
@immutable
class GlobalOptions extends OptionsCollection {
  /// Creates a new global options collection.
  GlobalOptions(
    this._packageInfo,
  ) : super(const AppStorage(StorageKeys.global)) {
    pushNotificationsEnabled.addListener(_pushNotificationsEnabledListener);
    rememberLastUsedAccount.addListener(_rememberLastUsedAccountListener);
  }

  void _rememberLastUsedAccountListener() {
    initialAccount.enabled = !rememberLastUsedAccount.value;
    if (rememberLastUsedAccount.value) {
      initialAccount.reset();
    } else {
      // Only override the initial account if there already has been a value,
      // which means it's not the initial emit from rememberLastUsedAccount
      initialAccount.value = initialAccount.values.keys.first;
    }
  }

  Future<void> _pushNotificationsEnabledListener() async {
    if (pushNotificationsEnabled.value) {
      final response = await Permission.notification.request();
      if (response.isPermanentlyDenied) {
        pushNotificationsEnabled.enabled = false;
      }
      if (!response.isGranted) {
        pushNotificationsEnabled.value = false;
      }
    } else {
      pushNotificationsDistributor.reset();
    }
  }

  final PackageInfo _packageInfo;

  late final _distributorsMap = <String, LabelBuilder>{
    _packageInfo.packageName: (context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorFirebaseEmbedded,
    'com.github.gotify.up': (context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorGotifyUP,
    'eu.siacs.conversations': (context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorConversations,
    'io.heckel.ntfy': (context) => NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNtfy,
    'org.unifiedpush.distributor.fcm': (context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorFCMUP,
    unifiedPushNextPushID: (context) => NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNextPush,
    'org.unifiedpush.distributor.noprovider2push': (context) =>
        NeonLocalizations.of(context).globalOptionsPushNotificationsDistributorNoProvider2Push,
  };

  @override
  late final List<Option<dynamic>> options = [
    themeMode,
    themeOLEDAsDark,
    themeUseNextcloudTheme,
    themeCustomBackground,
    pushNotificationsEnabled,
    pushNotificationsDistributor,
    startupMinimized,
    startupMinimizeInsteadOfExit,
    rememberLastUsedAccount,
    initialAccount,
    navigationMode,
  ];

  @override
  void dispose() {
    super.dispose();

    pushNotificationsEnabled.removeListener(_pushNotificationsEnabledListener);
    rememberLastUsedAccount.removeListener(_rememberLastUsedAccountListener);
  }

  /// Updates the available values of [initialAccount].
  ///
  /// If the current `initialAccount` is not supported anymore the option will be reset.
  void updateAccounts(List<Account> accounts) {
    initialAccount.values = Map.fromEntries(
      accounts.map(
        (account) => MapEntry(account.id, (context) => account.humanReadableID),
      ),
    );
  }

  /// Updates the values of [pushNotificationsDistributor].
  ///
  /// If the new `distributors` does not contain the currently active one
  /// both [pushNotificationsDistributor] and [pushNotificationsEnabled] will be reset.
  void updateDistributors(List<String> distributors) {
    pushNotificationsDistributor.values = Map.fromEntries(
      distributors.map(
        (distributor) => MapEntry(distributor, _distributorsMap[distributor] ?? (_) => distributor),
      ),
    );

    pushNotificationsEnabled.enabled = pushNotificationsDistributor.values.isNotEmpty;
  }

  /// The theme mode of the app implementing the Neon framework.
  late final themeMode = SelectOption(
    storage: storage,
    key: GlobalOptionKeys.themeMode,
    label: (context) => NeonLocalizations.of(context).globalOptionsThemeMode,
    defaultValue: ThemeMode.system,
    values: {
      ThemeMode.light: (context) => NeonLocalizations.of(context).globalOptionsThemeModeLight,
      ThemeMode.dark: (context) => NeonLocalizations.of(context).globalOptionsThemeModeDark,
      ThemeMode.system: (context) => NeonLocalizations.of(context).globalOptionsThemeModeAutomatic,
    },
  );

  /// Whether the [ThemeMode.dark] should use a plain black background.
  ///
  /// This is commonly used for OLED screens.
  /// Defaults to `false`.
  late final themeOLEDAsDark = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.themeOLEDAsDark,
    label: (context) => NeonLocalizations.of(context).globalOptionsThemeOLEDAsDark,
    defaultValue: false,
  );

  /// Whether the `ColorScheme` should keep the colors provided by the Nextcloud server.
  ///
  /// Defaults to `false` generating a Material 3 style color.
  late final themeUseNextcloudTheme = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.themeUseNextcloudTheme,
    label: (context) => NeonLocalizations.of(context).globalOptionsThemeUseNextcloudTheme,
    defaultValue: true,
  );

  /// Whether to enable custom backgrounds provided by the Nextcloud server.
  ///
  /// Defaults to `true`.
  /// Depends on [themeUseNextcloudTheme] to be enabled.
  late final themeCustomBackground = ToggleOption.depend(
    storage: storage,
    key: GlobalOptionKeys.themeCustomBackground,
    label: (context) => NeonLocalizations.of(context).globalOptionsThemeCustomBackground,
    defaultValue: true,
    enabled: themeUseNextcloudTheme,
  );

  /// Whether to enable the push notifications plugin.
  ///
  /// Setting this option to true will request the permission to show notifications.
  /// Disabling this option will reset [pushNotificationsDistributor].
  ///
  /// Defaults to `false`.
  late final pushNotificationsEnabled = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.pushNotificationsEnabled,
    label: (context) => NeonLocalizations.of(context).globalOptionsPushNotificationsEnabled,
    defaultValue: false,
  );

  /// The registered distributor for push notifications.
  late final pushNotificationsDistributor = SelectOption<String?>.depend(
    storage: storage,
    key: GlobalOptionKeys.pushNotificationsDistributor,
    label: (context) => NeonLocalizations.of(context).globalOptionsPushNotificationsDistributor,
    defaultValue: null,
    values: {},
    enabled: pushNotificationsEnabled,
  );

  /// Whether to start the app minimized.
  ///
  /// Defaults to `false`.
  ///
  /// See:
  ///   * [minimizeInsteadOfExit]: for an option to minimize instead of closing the app.
  late final startupMinimized = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.startupMinimized,
    label: (context) => NeonLocalizations.of(context).globalOptionsStartupMinimized,
    defaultValue: false,
  );

  /// Whether to minimize app instead of closing it.
  ///
  /// Defaults to `false`.
  ///
  /// See:
  ///   * [startupMinimized]: for an option to startup in the minimized state.
  late final startupMinimizeInsteadOfExit = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.startupMinimizeInsteadOfExit,
    label: (context) => NeonLocalizations.of(context).globalOptionsStartupMinimizeInsteadOfExit,
    defaultValue: false,
  );

  /// Whether to remember the last active account.
  ///
  /// Enabling this option will reset the [initialAccount].
  /// Defaults to `true`.
  late final rememberLastUsedAccount = ToggleOption(
    storage: storage,
    key: GlobalOptionKeys.rememberLastUsedAccount,
    label: (context) => NeonLocalizations.of(context).globalOptionsAccountsRememberLastUsedAccount,
    defaultValue: true,
  );

  /// The initial account to use when opening the app.
  late final initialAccount = SelectOption<String?>(
    storage: storage,
    key: GlobalOptionKeys.initialAccount,
    label: (context) => NeonLocalizations.of(context).globalOptionsAccountsInitialAccount,
    defaultValue: null,
    values: {},
  );

  late final navigationMode = SelectOption(
    storage: storage,
    key: GlobalOptionKeys.navigationMode,
    label: (context) => NeonLocalizations.of(context).globalOptionsNavigationMode,
    defaultValue: Platform.isAndroid || Platform.isIOS ? NavigationMode.drawer : NavigationMode.drawerAlwaysVisible,
    values: {
      NavigationMode.drawer: (context) => NeonLocalizations.of(context).globalOptionsNavigationModeDrawer,
      if (!Platform.isAndroid && !Platform.isIOS)
        NavigationMode.drawerAlwaysVisible: (context) =>
            NeonLocalizations.of(context).globalOptionsNavigationModeDrawerAlwaysVisible,
    },
  );
}

/// The storage keys for the [GlobalOptions].
@internal
enum GlobalOptionKeys implements Storable {
  /// The storage key for [GlobalOptions.themeMode]
  themeMode._('theme-mode'),

  /// The storage key for [GlobalOptions.themeOLEDAsDark]
  themeOLEDAsDark._('theme-oled-as-dark'),

  /// The storage key for [GlobalOptions.themeUseNextcloudTheme]
  themeUseNextcloudTheme._('theme-use-nextcloud-theme'),

  /// The storage key for [GlobalOptions.themeCustomBackground]
  themeCustomBackground._('theme-custom-background'),

  /// The storage key for [GlobalOptions.pushNotificationsEnabled]
  pushNotificationsEnabled._('push-notifications-enabled'),

  /// The storage key for [GlobalOptions.pushNotificationsDistributor]
  pushNotificationsDistributor._('push-notifications-distributor'),

  /// The storage key for [GlobalOptions.startupMinimized]
  startupMinimized._('startup-minimized'),

  /// The storage key for [GlobalOptions.startupMinimizeInsteadOfExit]
  startupMinimizeInsteadOfExit._('startup-minimize-instead-of-exit'),

  /// The storage key for [GlobalOptions.rememberLastUsedAccount]
  rememberLastUsedAccount._('remember-last-used-account'),

  /// The storage key for [GlobalOptions.initialAccount]
  initialAccount._('initial-account'),

  /// The storage key for [GlobalOptions.navigationMode]
  navigationMode._('navigation-mode');

  const GlobalOptionKeys._(this.value);

  @override
  final String value;
}

/// App navigation modes.
@internal
enum NavigationMode {
  /// Drawer behind a hamburger menu.
  ///
  /// The default for small screen sizes.
  drawer,

  /// Persistent drawer on the leading edge.
  ///
  /// The default on large screen sizes.
  drawerAlwaysVisible,
}

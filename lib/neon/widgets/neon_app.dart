import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/maintenance_mode.dart';
import 'package:neon_framework/src/blocs/unified_search.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/theme/server.dart';
import 'package:neon_framework/src/theme/theme.dart';
import 'package:neon_framework/src/utils/account_options.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/utils/localizations.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/options_collection_builder.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:rtu_mirea_app/neon/neon.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';

class NeonAppProvider extends StatefulWidget {
  /// Creates a new Neon app.
  const NeonAppProvider({
    required this.neonDependencies,
    required this.child,
    super.key,
  });

  final NeonDependencies neonDependencies;

  final Widget child;

  @override
  State<NeonAppProvider> createState() => _NeonAppProviderState();
}

class _NeonAppProviderState extends State<NeonAppProvider> with WidgetsBindingObserver, WindowListener {
  final _appRegex = RegExp(r'^([a-z]+)_app$', multiLine: true);

  late final BuiltSet<AppImplementation> _appImplementations;
  late final GlobalOptions _globalOptions;
  late final AccountsBloc _accountsBloc;

  @override
  void initState() {
    super.initState();

    _appImplementations = widget.neonDependencies.appImplementations;
    _globalOptions = widget.neonDependencies.globalOptions;
    _accountsBloc = widget.neonDependencies.accountsBloc;

    WidgetsBinding.instance.addObserver(this);
    if (NeonPlatform.instance.canUseWindowManager) {
      windowManager.addListener(this);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final localizations = await appLocalizationsFromSystem();

      if (!mounted) {
        return;
      }
      if (NeonPlatform.instance.canUseQuickActions) {
        const quickActions = QuickActions();
        await quickActions.setShortcutItems(
          _appImplementations
              .map(
                (app) => ShortcutItem(
                  type: '${app.id}_app',
                  localizedTitle: app.nameFromLocalization(localizations),
                  icon: '${app.id}_app',
                ),
              )
              .toList(),
        );
        await quickActions.initialize(_handleShortcut);
      }

      if (NeonPlatform.instance.canUseWindowManager) {
        await windowManager.setPreventClose(true);

        if (_globalOptions.startupMinimized.value) {
          await windowManager.minimize();
        }
      }
    });
  }

  @override
  Future<void> onWindowClose() async {
    if (_globalOptions.startupMinimizeInsteadOfExit.value) {
      await windowManager.minimize();
    } else {
      exit(0);
    }
  }

  @override
  Future<void> onWindowMinimize() async {}

  Future<void> _handleShortcut(String shortcutType) async {
    final matches = _appRegex.allMatches(shortcutType);
    final activeAccount = await _accountsBloc.activeAccount.first;
    if (matches.isNotEmpty && activeAccount != null) {
      await _openAppFromExternal(activeAccount, matches.first.group(1)!);
    }
  }

  Future<void> _openAppFromExternal(Account account, String id) async {
    _accountsBloc.getAppsBlocFor(account).setActiveApp(id);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (NeonPlatform.instance.canUseWindowManager) {
      windowManager.removeListener(this);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (deviceThemeLight, deviceThemeDark) => OptionsCollectionBuilder(
        valueListenable: _globalOptions,
        builder: (context, options, _) => StreamBuilder(
          stream: _accountsBloc.activeAccount,
          builder: (context, activeAccountSnapshot) {
            FlutterNativeSplash.remove();
            return ResultBuilder.behaviorSubject(
              subject: activeAccountSnapshot.hasData
                  ? _accountsBloc.getCapabilitiesBlocFor(activeAccountSnapshot.data!).capabilities
                  : null,
              builder: (context, capabilitiesSnapshot) {
                final appTheme = AppTheme(
                  serverTheme: ServerTheme(
                    nextcloudTheme: capabilitiesSnapshot.data?.capabilities.themingPublicCapabilities?.theming,
                  ),
                  useNextcloudTheme: options.themeUseNextcloudTheme.value,
                  deviceThemeLight: deviceThemeLight,
                  deviceThemeDark: deviceThemeDark,
                  oledAsDark: options.themeOLEDAsDark.value,
                  appThemes: _appImplementations.map((a) => a.theme).nonNulls,
                  neonTheme: widget.neonDependencies.neonTheme,
                );

                if (activeAccountSnapshot.hasData) {
                  final account = activeAccountSnapshot.requireData!;

                  return MultiProvider(
                    providers: [
                      Provider<AccountRepository>.value(
                        value: widget.neonDependencies.accountRepository,
                      ),
                      Provider<Account>.value(
                        value: account,
                      ),
                      NeonProvider<AccountOptions>.value(
                        value: _accountsBloc.getOptionsFor(account),
                      ),
                      NeonProvider<AppsBloc>.value(
                        value: _accountsBloc.getAppsBlocFor(account),
                      ),
                      NeonProvider<CapabilitiesBloc>.value(
                        value: _accountsBloc.getCapabilitiesBlocFor(account),
                      ),
                      NeonProvider<UserDetailsBloc>.value(
                        value: _accountsBloc.getUserDetailsBlocFor(account),
                      ),
                      NeonProvider<UserStatusBloc>.value(
                        value: _accountsBloc.getUserStatusBlocFor(account),
                      ),
                      NeonProvider<UnifiedSearchBloc>.value(
                        value: _accountsBloc.getUnifiedSearchBlocFor(account),
                      ),
                      NeonProvider<WeatherStatusBloc>.value(
                        value: _accountsBloc.getWeatherStatusBlocFor(account),
                      ),
                      NeonProvider<MaintenanceModeBloc>.value(
                        value: _accountsBloc.getMaintenanceModeBlocFor(account),
                      ),
                      NeonProvider<ReferencesBloc>.value(
                        value: _accountsBloc.getReferencesBlocFor(account),
                      ),
                      NeonProvider<GlobalOptions>.value(
                        value: _globalOptions,
                      ),
                      NeonProvider<AccountsBloc>.value(
                        value: _accountsBloc,
                      ),
                    ],
                    child: widget.child,
                  );
                }

                return widget.child;
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:provider/single_child_widget.dart';
import 'package:rtu_mirea_app/neon/apps.dart';
import 'package:rtu_mirea_app/neon/branding.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/first_launch.dart';
import 'package:neon_framework/src/blocs/next_push.dart';
import 'package:neon_framework/src/blocs/push_notifications.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:neon_framework/src/utils/user_agent.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// Runs Neon with the given [appImplementations].
///
/// This duplicates the behavior in `package:neon_framework/src/theme/neon.dart`.
Future<(NeonTheme, List<SingleChildWidget>)> runNeon({
  @visibleForTesting WidgetsBinding? bindingOverride,
  @visibleForTesting Account? account,
  @visibleForTesting bool firstLaunchDisabled = false,
  @visibleForTesting bool nextPushDisabled = false,
}) async {
  await NeonPlatform.setup();
  await RequestManager.instance.initCache();
  await NeonStorage.init();

  final packageInfo = await PackageInfo.fromPlatform();
  buildUserAgent(packageInfo);

  final globalOptions = GlobalOptions(
    packageInfo,
  );

  final accountsBloc = AccountsBloc(
    globalOptions,
    appImplementations,
  );
  if (account != null) {
    accountsBloc
      ..addAccount(account)
      ..setActiveAccount(account);
  }
  PushNotificationsBloc(
    accountsBloc,
    globalOptions,
  );
  final firstLaunchBloc = FirstLaunchBloc(
    disabled: firstLaunchDisabled,
  );
  final nextPushBloc = NextPushBloc(
    accountsBloc,
    globalOptions,
    disabled: nextPushDisabled,
  );

  return (
    neonTheme,
    [
      NeonProvider<GlobalOptions>.value(value: globalOptions),
      NeonProvider<AccountsBloc>.value(value: accountsBloc),
      NeonProvider<FirstLaunchBloc>.value(value: firstLaunchBloc),
      NeonProvider<NextPushBloc>.value(value: nextPushBloc),
      Provider<Iterable<AppImplementation>>(
        create: (_) => appImplementations,
        dispose: (_, appImplementations) => appImplementations.disposeAll(),
      ),
      Provider<PackageInfo>.value(value: packageInfo),
    ],
  );
}

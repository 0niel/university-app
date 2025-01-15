// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/first_launch.dart';
import 'package:neon_framework/src/blocs/next_push.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/storage/keys.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/utils/timezone.dart';
import 'package:neon_framework/src/utils/user_agent.dart';
import 'package:neon_framework/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/neon/neon_dependencies.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<NeonDependencies> initializeNeonDependencies({
  required BuiltSet<AppImplementation> appImplementations,
  required NeonTheme theme,
  http.Client? httpClient,
}) async {
  assert(appImplementations.isNotEmpty, 'At least one AppImplementation required');

  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }

  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await NeonPlatform.instance.init();
  tzdata.initializeTimeZones();

  final location = guessDeviceLocation();
  if (location != null) {
    tz.setLocalLocation(location);
  }

  await NeonStorage().init();

  final packageInfo = await PackageInfo.fromPlatform();

  final accountStorage = AccountStorage(
    accountsPersistence: NeonStorage().singleValueStore(StorageKeys.accounts),
    lastAccountPersistence: NeonStorage().singleValueStore(StorageKeys.lastUsedAccount),
  );

  final accountRepository = AccountRepository(
    userAgent: buildUserAgent(packageInfo, theme.branding.name),
    httpClient: httpClient ?? http.Client(),
    storage: accountStorage,
  );

  final globalOptions = GlobalOptions(
    packageInfo,
    BuiltList<String>(),
  );

  await accountRepository.loadAccounts(
    initialAccount: globalOptions.initialAccount.value,
    rememberLastUsedAccount: globalOptions.rememberLastUsedAccount.value,
  );

  final accountsBloc = AccountsBloc(
    allAppImplementations: appImplementations,
    accountRepository: accountRepository,
  );

  final firstLaunchBloc = FirstLaunchBloc();
  final nextPushBloc = NextPushBloc(
    accountsSubject: accountsBloc.accounts,
    globalOptions: globalOptions,
  );

  return NeonDependencies(
    appImplementations: appImplementations,
    neonTheme: theme,
    accountRepository: accountRepository,
    globalOptions: globalOptions,
    accountsBloc: accountsBloc,
    firstLaunchBloc: firstLaunchBloc,
    nextPushBloc: nextPushBloc,
    packageInfo: packageInfo,
  );
}

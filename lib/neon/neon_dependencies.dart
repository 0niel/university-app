// ignore_for_file: implementation_imports

import 'package:account_repository/account_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/first_launch.dart';
import 'package:neon_framework/src/blocs/next_push.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NeonDependencies {
  final BuiltSet<AppImplementation> appImplementations;
  final NeonTheme neonTheme;
  final AccountRepository accountRepository;
  final GlobalOptions globalOptions;
  final AccountsBloc accountsBloc;
  final FirstLaunchBloc firstLaunchBloc;
  final NextPushBloc nextPushBloc;
  final PackageInfo packageInfo;

  NeonDependencies({
    required this.appImplementations,
    required this.neonTheme,
    required this.accountRepository,
    required this.globalOptions,
    required this.accountsBloc,
    required this.firstLaunchBloc,
    required this.nextPushBloc,
    required this.packageInfo,
  });
}

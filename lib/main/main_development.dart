import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/di/app_scope.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

void main() async {
  await bootstrap((sharedPreferences) async {
    setPathUrlStrategy();
    final packageInfo = await PackageInfo.fromPlatform();
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    final holder = AppScopeHolder(
      sharedPreferences: sharedPreferences,
      packageInfo: packageInfo,
      dev: true,
    );
    await holder.create();

    final user = await holder.scope!.userRepository.user.first;

    if (kDebugMode) logger.i('Running in development mode with yx_scope DI');

    return ScopeProvider(holder: holder, child: App(user: user));
  });
}

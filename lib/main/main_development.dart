import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/di/app_scope.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

void main() async {
  await bootstrap((_) async {
    setPathUrlStrategy();

    final holder = AppScopeHolder(dev: true);
    await holder.create();

    final scope = holder.scope;
    if (scope == null) {
      throw Exception('Failed to initialize AppScope');
    }

    final user = await scope.userRepository.user.first;

    if (kDebugMode) logger.i('Running in development mode with yx_scope DI');

    return ScopeProvider(holder: holder, child: App(user: user));
  });
}

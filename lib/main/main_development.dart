import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/app/view/app_yx_scope.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap_yx_scope.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await bootstrap((appScopeHolder) async {
    // Initialize common services
    setPathUrlStrategy();

    final appScope = appScopeHolder.scope;
    if (appScope != null) {
      // TODO(Oniel): Create custom API client for development
      logger.d(
        'We set localhost API client. Ensure that you are running the server locally.',
      );
    }

    if (kDebugMode) {
      Logger().i('Running in development mode');
    }

    return AppWithYxScope(appScopeHolder: appScopeHolder);
  });
}

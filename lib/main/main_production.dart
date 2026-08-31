import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/di/app_scope.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

void main() async {
  await bootstrap((_) async {
    usePathUrlStrategy();

    final holder = AppScopeHolder();
    await holder.create();

    final scope = holder.scope;
    if (scope == null) {
      throw Exception('Failed to initialize AppScope');
    }

    final user = await scope.userRepository.user.first;
    return ScopeProvider(
      holder: holder,
      child: App(user: user),
    );
  });
}

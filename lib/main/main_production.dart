import 'package:rtu_mirea_app/app/view/app_yx_scope.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap_yx_scope.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await bootstrap((appScopeHolder) async {
    // Initialize common services
    setPathUrlStrategy();

    return AppWithYxScope(appScopeHolder: appScopeHolder);
  });
}

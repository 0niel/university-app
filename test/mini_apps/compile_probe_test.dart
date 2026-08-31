import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/mini_apps/mini_apps.dart';

void main() {
  test('mini apps feature compiles', () {
    expect(MiniAppsPage, isNotNull);
    expect(MiniAppRunnerPage, isNotNull);
    expect(MiniAppSubmitPage, isNotNull);
    expect(MiniAppsModerationPage, isNotNull);
    expect(MiniAppConsentSheet, isNotNull);
  });
}

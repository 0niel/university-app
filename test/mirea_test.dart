import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/service_locator.dart' as service_locator;

import 'utils/calendar_test.dart';
import 'widgets/onboarding_test.dart';

/// Основная функция запуска тестирования
void main() {
  print('Unit-testing:');

  // Test calendar util
  CalendarTest.testEverything();

  setUpAll(() {
    service_locator.setup();
  });

  // Test OnBoarding screen
  OnBoardingTest.testEverythg();
}

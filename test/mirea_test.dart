import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/service_locator.dart' as service_locator;
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/calendar_test.dart' as cal_utils;

/// Test all
void main() {
  group('calendar utils', cal_utils.main);

  // Prepare to widget-testing
  // setUpAll(() async {
  //   SharedPreferences.setMockInitialValues({});
  //   await service_locator.setup();
  // });
}

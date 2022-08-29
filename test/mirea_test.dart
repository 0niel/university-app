import 'package:flutter_test/flutter_test.dart';

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

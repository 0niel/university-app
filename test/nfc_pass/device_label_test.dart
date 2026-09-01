import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/nfc_pass/device_label.dart';

void main() {
  test('uses stable labels for supported platforms', () {
    expect(deviceLabelFor(TargetPlatform.android), 'Android device');
    expect(deviceLabelFor(TargetPlatform.iOS), 'Apple mobile device');
    expect(deviceLabelFor(TargetPlatform.macOS), 'Mac');
    expect(deviceLabelFor(TargetPlatform.windows), 'Windows PC');
    expect(deviceLabelFor(TargetPlatform.linux), 'Linux computer');
    expect(deviceLabelFor(TargetPlatform.fuchsia), 'Mobile device');
  });
}

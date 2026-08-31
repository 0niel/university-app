import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';

void main() {
  group('formatPickedTime', () {
    test('zero-pads hour and minute to HH:MM', () {
      expect(formatPickedTime((hour: 9, minute: 0)), '09:00');
      expect(formatPickedTime((hour: 18, minute: 5)), '18:05');
      expect(formatPickedTime((hour: 0, minute: 0)), '00:00');
      expect(formatPickedTime((hour: 23, minute: 59)), '23:59');
    });
  });
}

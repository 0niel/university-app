import 'package:flutter_test/flutter_test.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$AmbientModeListener', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('updates when ambient mode is activated', () {
      final listener = AmbientModeListener.instance..value = false;

      simulatePlatformCall('ambient_mode', 'onEnterAmbient');

      expect(listener.isAmbientModeActive, isTrue);
    });

    test('updates when ambient mode is update', () {
      final listener = AmbientModeListener.instance..value = false;

      simulatePlatformCall('ambient_mode', 'onUpdateAmbient');

      expect(listener.isAmbientModeActive, isTrue);
    });

    test('updates when ambient mode is deactivated', () async {
      final listener = AmbientModeListener.instance..value = true;

      await simulatePlatformCall('ambient_mode', 'onExitAmbient');

      expect(listener.isAmbientModeActive, isFalse);
    });

    test('does not change on unknown method', () async {
      final listener = AmbientModeListener.instance..value = true;

      await simulatePlatformCall('ambient_mode', 'onUnknownMethod');

      expect(listener.isAmbientModeActive, isTrue);
    });
  });
}

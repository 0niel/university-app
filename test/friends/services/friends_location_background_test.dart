import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/friends/services/friends_location_background.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('ninja.mirea/friends_location_background');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => calls.add(call));
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('Android retains and releases the publishing engine', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await FriendsLocationBackground.setEnabled(enabled: true);
    await FriendsLocationBackground.setEnabled(enabled: false);
    expect(calls.map((call) => call.method), ['setEnabled', 'setEnabled']);
    expect(calls.map((call) => call.arguments), [true, false]);
  });

  test('other platforms do not use Android engine retention', () async {
    for (final platform in TargetPlatform.values) {
      if (platform == TargetPlatform.android) continue;
      debugDefaultTargetPlatformOverride = platform;
      await FriendsLocationBackground.setEnabled(enabled: true);
      await FriendsLocationBackground.setEnabled(enabled: false);
    }
    expect(calls, isEmpty);
  });

  test('native failure is reported to the location service', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
          throw PlatformException(code: 'engine_unavailable');
        });
    await expectLater(
      FriendsLocationBackground.setEnabled(enabled: true),
      throwsA(isA<PlatformException>()),
    );
  });
}

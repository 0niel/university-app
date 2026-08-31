import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_client/permission_client.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PermissionClient', () {
    const channel = MethodChannel(
      'flutter.baseflow.com/permissions/methods',
    );
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    late PermissionClient permissionClient;
    late List<MethodCall> calls;

    setUp(() {
      permissionClient = const PermissionClient();
      calls = [];

      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);

        if (call.method == 'checkPermissionStatus') {
          return PermissionStatus.granted.index;
        } else if (call.method == 'requestPermissions') {
          return <Object?, int>{
            for (final key in call.arguments as List<Object?>)
              key: PermissionStatus.granted.index,
          };
        } else if (call.method == 'openAppSettings') {
          return true;
        }

        return null;
      });
    });

    tearDown(() => messenger.setMockMethodCallHandler(channel, null));

    Matcher permissionWasRequested(Permission permission) => contains(
      isA<MethodCall>()
          .having((c) => c.method, 'method', 'requestPermissions')
          .having((c) => c.arguments, 'arguments', contains(permission.value)),
    );

    Matcher permissionWasChecked(Permission permission) => contains(
      isA<MethodCall>()
          .having((c) => c.method, 'method', 'checkPermissionStatus')
          .having((c) => c.arguments, 'arguments', equals(permission.value)),
    );

    group('requestNotifications', () {
      test('calls correct method', () async {
        await permissionClient.requestNotifications();
        expect(calls, permissionWasRequested(.notification));
      });
    });

    group('notificationsStatus', () {
      test('calls correct method', () async {
        await permissionClient.notificationsStatus();
        expect(calls, permissionWasChecked(.notification));
      });
    });

    group('requestLocationWhenInUse', () {
      test('requests foreground location permission', () async {
        await permissionClient.requestLocationWhenInUse();

        expect(calls, permissionWasRequested(.locationWhenInUse));
      });
    });

    group('locationWhenInUseStatus', () {
      test('checks foreground location permission', () async {
        await permissionClient.locationWhenInUseStatus();

        expect(calls, permissionWasChecked(.locationWhenInUse));
      });
    });

    group('requestNearbyWifiDevices', () {
      test('requests nearby Wi-Fi device permission', () async {
        await permissionClient.requestNearbyWifiDevices();

        expect(calls, permissionWasRequested(.nearbyWifiDevices));
      });
    });

    group('openPermissionSettings', () {
      test('calls correct method', () async {
        await permissionClient.openPermissionSettings();

        expect(
          calls,
          contains(
            isA<MethodCall>().having(
              (c) => c.method,
              'method',
              'openAppSettings',
            ),
          ),
        );
      });
    });
  });
}

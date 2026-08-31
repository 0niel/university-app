import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/app/services/device_token_sync_controller.dart';

void main() {
  test(
    'logout waits for an in-flight registration before unregistering',
    () async {
      final registerCompleter = Completer<void>();
      final calls = <String>[];
      final controller = DeviceTokenSyncController(
        getToken: () async => 'token',
        tokenRefresh: const Stream.empty(),
        register: (token) async {
          calls.add('register:$token');
          await registerCompleter.future;
        },
        unregister: (token) async => calls.add('unregister:$token'),
        deleteToken: () async => calls.add('delete'),
        onError: (error, stackTrace) => fail('$error\n$stackTrace'),
      );

      final start = controller.start();
      await Future<void>.delayed(.zero);
      final logout = controller.stopAndUnregister();
      expect(calls, ['register:token']);

      registerCompleter.complete();
      await Future.wait([start, logout]);
      expect(calls, ['register:token', 'unregister:token', 'delete']);
    },
  );

  test('logout unregisters the last successfully registered token', () async {
    final unregistered = <String>[];
    final controller = DeviceTokenSyncController(
      getToken: () async => 'token',
      tokenRefresh: const Stream.empty(),
      register: (_) => Future.value(),
      unregister: (token) async => unregistered.add(token),
      deleteToken: Future.value,
      onError: (error, stackTrace) => fail('$error\n$stackTrace'),
    );

    await controller.start();
    await controller.stopAndUnregister();

    expect(unregistered, ['token']);
  });

  test(
    'an unauthenticated startup invalidates a stale Firebase token',
    () async {
      var deleted = false;
      final controller = DeviceTokenSyncController(
        getToken: () async => null,
        tokenRefresh: const Stream.empty(),
        register: (_) => Future.value(),
        unregister: (_) => Future.value(),
        deleteToken: () async => deleted = true,
        onError: (error, stackTrace) => fail('$error\n$stackTrace'),
      );

      await controller.stopAndUnregister();

      expect(deleted, isTrue);
    },
  );
}

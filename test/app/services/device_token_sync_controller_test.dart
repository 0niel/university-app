import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/app/services/device_token_sync_controller.dart';

void main() {
  test(
    'failed token refresh registration can recover for the same user',
    () async {
      final refresh = StreamController<String>.broadcast(sync: true);
      var token = 'first';
      var rejectRefresh = false;
      final registered = <String>[];
      final errors = <Object>[];
      final controller = DeviceTokenSyncController(
        getToken: () async => token,
        tokenRefresh: refresh.stream,
        register: (value) async {
          if (rejectRefresh) throw StateError('offline');
          registered.add(value);
        },
        unregister: (_) async {},
        deleteToken: () async {},
        onError: (error, _) => errors.add(error),
      );
      await controller.synchronizeUser('A');
      token = 'refreshed';
      rejectRefresh = true;
      refresh.add(token);
      await Future<void>.delayed(Duration.zero);
      expect(errors, hasLength(1));
      rejectRefresh = false;
      await controller.synchronizeUser('A');
      expect(registered, ['first', 'refreshed']);
      await controller.pause();
      await refresh.close();
    },
  );
  test(
    'account replacement invalidates before registering a fresh token',
    () async {
      final fixture = _TokenFixture();
      addTearDown(fixture.close);
      await fixture.controller.synchronizeUser('A');
      fixture.user = 'B';
      await fixture.controller.synchronizeUser('B');
      expect(fixture.calls, [
        'get:A:token-1',
        'register:A:token-1',
        'delete:token-1',
        'get:B:token-2',
        'register:B:token-2',
      ]);
    },
  );

  test('rapid account replacement only registers the latest user', () async {
    final fixture = _TokenFixture();
    addTearDown(fixture.close);
    await fixture.controller.synchronizeUser('A');
    fixture.user = 'B';
    final second = fixture.controller.synchronizeUser('B');
    fixture.user = 'C';
    final third = fixture.controller.synchronizeUser('C');
    await Future.wait([second, third]);
    expect(fixture.calls.where((call) => call.startsWith('register:')), [
      'register:A:token-1',
      'register:C:token-2',
    ]);
    expect(
      fixture.calls.where((call) => call.startsWith('unregister:')),
      isEmpty,
    );
  });

  test('an old token lookup cannot register after A to B to C', () async {
    final fixture = _TokenFixture()..getGate = Completer<void>();
    addTearDown(fixture.close);
    final first = fixture.controller.synchronizeUser('A');
    await Future<void>.delayed(.zero);
    fixture.user = 'B';
    final second = fixture.controller.synchronizeUser('B');
    fixture.user = 'C';
    final third = fixture.controller.synchronizeUser('C');
    fixture.getGate!.complete();
    await Future.wait([first, second, third]);
    expect(fixture.calls.where((call) => call.startsWith('register:')), [
      'register:C:token-2',
    ]);
  });

  test(
    'old registration completes before rotation without old-user unregister',
    () async {
      final fixture = _TokenFixture()..registerGate = Completer<void>();
      addTearDown(fixture.close);
      final first = fixture.controller.synchronizeUser('A');
      await Future<void>.delayed(.zero);
      fixture.user = 'B';
      final second = fixture.controller.synchronizeUser('B');
      fixture.user = 'C';
      final third = fixture.controller.synchronizeUser('C');
      expect(fixture.calls, ['get:A:token-1', 'register:A:token-1']);
      fixture.registerGate!.complete();
      await Future.wait([first, second, third]);
      expect(fixture.calls, [
        'get:A:token-1',
        'register:A:token-1',
        'delete:token-1',
        'get:C:token-2',
        'register:C:token-2',
      ]);
    },
  );

  test(
    'a switch during deletion discards refreshes and the intermediate user',
    () async {
      final fixture = _TokenFixture();
      addTearDown(fixture.close);
      await fixture.controller.synchronizeUser('A');
      fixture
        ..deleteGate = Completer<void>()
        ..user = 'B';
      final second = fixture.controller.synchronizeUser('B');
      await Future<void>.delayed(.zero);
      fixture.refresh.add('stale-A');
      fixture.user = 'C';
      final third = fixture.controller.synchronizeUser('C');
      fixture.deleteGate!.complete();
      await Future.wait([second, third]);
      expect(fixture.calls.where((call) => call.startsWith('register:')), [
        'register:A:token-1',
        'register:C:token-2',
      ]);
    },
  );

  test(
    'failed rotation remains required before retrying the same account',
    () async {
      final fixture = _TokenFixture();
      addTearDown(fixture.close);
      await fixture.controller.synchronizeUser('A');
      fixture
        ..user = 'B'
        ..deleteFails = true;
      await expectLater(
        fixture.controller.synchronizeUser('B'),
        throwsStateError,
      );
      expect(
        fixture.calls.where((call) => call.startsWith('register:B')),
        isEmpty,
      );
      fixture.deleteFails = false;
      await fixture.controller.synchronizeUser('B');
      expect(fixture.calls.last, 'register:B:token-2');
      expect(
        fixture.calls.where((call) => call == 'delete:token-1'),
        hasLength(2),
      );
    },
  );

  test('a stale lookup failure cannot pause a newer account binding', () async {
    final fixture = _TokenFixture()
      ..getGate = Completer<void>()
      ..getFailsOnce = true;
    addTearDown(fixture.close);
    final first = fixture.controller.synchronizeUser('A');
    final failure = expectLater(first, throwsStateError);
    await Future<void>.delayed(.zero);
    fixture.user = 'B';
    final second = fixture.controller.synchronizeUser('B');
    fixture.getGate!.complete();
    await Future.wait([failure, second]);
    fixture.refresh.add('refreshed-B');
    await Future<void>.delayed(.zero);
    expect(fixture.calls.last, 'register:B:refreshed-B');
  });

  test(
    'logout followed immediately by login avoids old-user unregister',
    () async {
      final fixture = _TokenFixture();
      addTearDown(fixture.close);
      await fixture.controller.synchronizeUser('A');
      final logout = fixture.controller.synchronizeUser(null);
      fixture.user = 'B';
      final login = fixture.controller.synchronizeUser('B');
      await Future.wait([logout, login]);
      expect(
        fixture.calls.where((call) => call.startsWith('unregister:')),
        isEmpty,
      );
      expect(fixture.calls.last, 'register:B:token-2');
    },
  );

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

class _TokenFixture {
  _TokenFixture() {
    controller = DeviceTokenSyncController(
      getToken: () async {
        final token = _token ??= 'token-${++_sequence}';
        calls.add('get:$user:$token');
        await getGate?.future;
        if (getFailsOnce) {
          getFailsOnce = false;
          throw StateError('lookup failed');
        }
        return token;
      },
      tokenRefresh: refresh.stream,
      register: (token) async {
        calls.add('register:$user:$token');
        await registerGate?.future;
      },
      unregister: (token) async => calls.add('unregister:$user:$token'),
      deleteToken: () async {
        calls.add('delete:$_token');
        await deleteGate?.future;
        if (deleteFails) throw StateError('rotation failed');
        _token = null;
      },
      onError: (error, stackTrace) => fail('$error\n$stackTrace'),
    );
  }

  late final DeviceTokenSyncController controller;
  final refresh = StreamController<String>.broadcast(sync: true);
  final calls = <String>[];
  String user = 'A';
  String? _token;
  int _sequence = 0;
  Completer<void>? getGate;
  Completer<void>? registerGate;
  Completer<void>? deleteGate;
  bool deleteFails = false;
  bool getFailsOnce = false;

  Future<void> close() async {
    await controller.pause();
    await refresh.close();
  }
}

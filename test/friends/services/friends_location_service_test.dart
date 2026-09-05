import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rtu_mirea_app/friends/services/friends_location_service.dart';

class _Geolocator extends GeolocatorPlatform {
  final positions = StreamController<Position>.broadcast();
  final services = StreamController<ServiceStatus>.broadcast();
  LocationPermission permission = LocationPermission.whileInUse;
  bool serviceEnabled = true;
  int requests = 0;
  int streams = 0;
  int serviceChecks = 0;
  int settingsOpened = 0;
  int currentRequests = 0;
  LocationSettings? settings;
  Completer<LocationPermission>? permissionResult;
  Completer<Position>? currentResult;
  final currentStarted = Completer<void>();

  @override
  Future<bool> isLocationServiceEnabled() async {
    serviceChecks++;
    return serviceEnabled;
  }

  @override
  Future<LocationPermission> checkPermission() async =>
      permissionResult?.future ?? permission;

  @override
  Future<LocationPermission> requestPermission() async {
    requests++;
    return permission;
  }

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    streams++;
    settings = locationSettings;
    return positions.stream;
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() => services.stream;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    currentRequests++;
    if (!currentStarted.isCompleted) currentStarted.complete();
    return currentResult?.future ?? _position();
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened++;
    return true;
  }

  Future<void> close() async {
    await positions.close();
    await services.close();
  }
}

Position _position({double latitude = 55.67, DateTime? timestamp}) => Position(
  longitude: 37.48,
  latitude: latitude,
  timestamp: timestamp ?? DateTime.now(),
  accuracy: 10,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Geolocator geolocator;
  late FriendsLocationService service;

  setUp(() {
    geolocator = _Geolocator();
    service = FriendsLocationService(
      geolocator: geolocator,
      platform: TargetPlatform.android,
    );
  });

  tearDown(() async {
    await service.dispose();
    await geolocator.close();
  });

  Future<void> useFastHeartbeat() async {
    await service.dispose();
    service = FriendsLocationService(
      geolocator: geolocator,
      platform: TargetPlatform.android,
      heartbeatInterval: const Duration(milliseconds: 10),
    );
  }

  test(
    'background sharing uses one foreground service with notification',
    () async {
      await service.start(backgroundEnabled: true);
      final settings = geolocator.settings! as AndroidSettings;
      expect(settings.foregroundNotificationConfig, isNotNull);
      expect(settings.foregroundNotificationConfig!.enableWakeLock, isTrue);
      expect(geolocator.streams, 1);
      final fix = service.positions.first;
      service.didChangeAppLifecycleState(AppLifecycleState.paused);
      geolocator.positions.add(_position());
      await fix;
      expect(service.status, FriendsLocationStatus.active);
      expect(geolocator.positions.hasListener, isTrue);
    },
  );

  test('foreground viewing stops on pause and recovers on resume', () async {
    await service.start(backgroundEnabled: false);
    service.didChangeAppLifecycleState(AppLifecycleState.paused);
    await Future<void>.delayed(Duration.zero);
    expect(geolocator.positions.hasListener, isFalse);
    expect(service.status, FriendsLocationStatus.stopped);
    service.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(geolocator.streams, 2);
    expect(geolocator.requests, 0);
  });

  test('stop cancels tracking and lifecycle cannot restart it', () async {
    await service.start(backgroundEnabled: true);
    await service.stop();
    service.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(geolocator.positions.hasListener, isFalse);
    expect(geolocator.services.hasListener, isFalse);
    expect(geolocator.streams, 1);
    expect(service.status, FriendsLocationStatus.stopped);
  });

  test('repeated start preserves the active background service', () async {
    await service.start(backgroundEnabled: true);
    final fix = service.positions.first;
    geolocator.positions.add(_position());
    await fix;
    service.didChangeAppLifecycleState(AppLifecycleState.paused);
    await service.start(backgroundEnabled: true, requestPermission: false);
    expect(geolocator.streams, 1);
    expect(geolocator.positions.hasListener, isTrue);
    expect(service.status, FriendsLocationStatus.active);
  });

  test('rejects invalid, stale and out-of-order positions', () async {
    final received = <Position>[];
    final subscription = service.positions.listen(received.add);
    await service.start(backgroundEnabled: true);
    final now = DateTime.now();
    geolocator.positions.add(_position(latitude: double.nan));
    geolocator.positions.add(_position(latitude: 91));
    geolocator.positions.add(
      _position(timestamp: now.subtract(const Duration(minutes: 3))),
    );
    geolocator.positions.add(
      _position(timestamp: now.add(const Duration(minutes: 2))),
    );
    geolocator.positions.add(_position(timestamp: now));
    geolocator.positions.add(
      _position(timestamp: now.subtract(const Duration(seconds: 1))),
    );
    await Future<void>.delayed(Duration.zero);
    expect(received, hasLength(1));
    await subscription.cancel();
  });

  test('a permission response after stop cannot restart tracking', () async {
    geolocator.permissionResult = Completer<LocationPermission>();
    final starting = service.start(backgroundEnabled: true);
    await Future<void>.delayed(Duration.zero);
    await service.stop();
    geolocator.permissionResult!.complete(LocationPermission.whileInUse);
    await starting;
    expect(geolocator.streams, 0);
    expect(service.status, FriendsLocationStatus.stopped);
  });

  test('stationary sharing obtains a fresh fix in background', () async {
    await useFastHeartbeat();
    final received = <Position>[];
    final subscription = service.positions.listen(received.add);
    await service.start(backgroundEnabled: true);
    service.didChangeAppLifecycleState(AppLifecycleState.paused);
    await geolocator.currentStarted.future.timeout(const Duration(seconds: 2));
    await Future<void>.delayed(Duration.zero);
    expect(geolocator.currentRequests, 1);
    expect(received, hasLength(1));
    await service.stop();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(geolocator.currentRequests, 1);
    await subscription.cancel();
  });

  test('heartbeat result arriving after stop is discarded', () async {
    await useFastHeartbeat();
    final received = <Position>[];
    final subscription = service.positions.listen(received.add);
    geolocator.currentResult = Completer<Position>();
    await service.start(backgroundEnabled: true);
    await geolocator.currentStarted.future.timeout(const Duration(seconds: 2));
    expect(geolocator.currentRequests, 1);
    await service.stop();
    geolocator.currentResult!.complete(_position());
    await Future<void>.delayed(Duration.zero);
    expect(received, isEmpty);
    await subscription.cancel();
  });

  test(
    'a failed background stream cannot leave its heartbeat running',
    () async {
      await useFastHeartbeat();
      await service.start(backgroundEnabled: true);
      service.didChangeAppLifecycleState(AppLifecycleState.paused);
      geolocator.positions.addError(StateError('Location unavailable'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(service.status, FriendsLocationStatus.failure);
      expect(geolocator.currentRequests, 0);
      expect(geolocator.positions.hasListener, isFalse);
    },
  );

  test('heartbeat does not renew a stale cached coordinate', () async {
    await useFastHeartbeat();
    final received = <Position>[];
    final subscription = service.positions.listen(received.add);
    geolocator.currentResult = Completer<Position>()
      ..complete(
        _position(
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        ),
      );
    await service.start(backgroundEnabled: true);
    await geolocator.currentStarted.future.timeout(const Duration(seconds: 2));
    await Future<void>.delayed(Duration.zero);
    expect(received, isEmpty);
    await service.stop();
    await subscription.cancel();
  });

  test('denied forever is distinct and does not ask again', () async {
    geolocator.permission = LocationPermission.deniedForever;
    await service.start(backgroundEnabled: true);
    expect(service.status, FriendsLocationStatus.permissionDeniedForever);
    expect(geolocator.requests, 0);
    expect(geolocator.streams, 0);
    expect(geolocator.settingsOpened, 0);
    await service.start(backgroundEnabled: true);
    expect(geolocator.settingsOpened, 1);
  });

  test('restoring device location restarts an enabled session', () async {
    geolocator.serviceEnabled = false;
    await service.start(backgroundEnabled: true);
    expect(service.status, FriendsLocationStatus.serviceDisabled);
    geolocator.serviceEnabled = true;
    geolocator.services.add(ServiceStatus.enabled);
    await Future<void>.delayed(Duration.zero);
    expect(geolocator.streams, 1);
  });

  test(
    'GPS disabled cancels publication without starting in background',
    () async {
      await service.start(backgroundEnabled: true);
      service.didChangeAppLifecycleState(AppLifecycleState.paused);
      geolocator.services.add(ServiceStatus.disabled);
      await Future<void>.delayed(Duration.zero);
      expect(geolocator.positions.hasListener, isFalse);
      expect(service.status, FriendsLocationStatus.serviceDisabled);
      geolocator.services.add(ServiceStatus.enabled);
      await Future<void>.delayed(Duration.zero);
      expect(geolocator.streams, 1);
      service.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);
      expect(geolocator.streams, 2);
    },
  );

  test(
    'web supports browser permission fallback and stops when hidden',
    () async {
      await service.dispose();
      service = FriendsLocationService(
        geolocator: geolocator,
        platform: TargetPlatform.android,
        isWeb: true,
      );
      geolocator.permission = LocationPermission.unableToDetermine;
      await service.start(backgroundEnabled: true);
      expect(geolocator.serviceChecks, 0);
      expect(geolocator.settings, isA<WebSettings>());
      expect(service.supportsBackground, isFalse);
      expect(geolocator.positions.hasListener, isTrue);
      service.didChangeAppLifecycleState(AppLifecycleState.hidden);
      await Future<void>.delayed(Duration.zero);
      expect(geolocator.positions.hasListener, isFalse);
    },
  );

  test('Apple background indicator requires explicit sharing', () {
    final foreground =
        friendsMapLocationSettings(
              TargetPlatform.iOS,
              forceGnss: false,
            )
            as AppleSettings;
    final background =
        friendsMapLocationSettings(
              TargetPlatform.iOS,
              forceGnss: false,
              backgroundEnabled: true,
            )
            as AppleSettings;
    expect(foreground.allowBackgroundLocationUpdates, isFalse);
    expect(foreground.showBackgroundLocationIndicator, isFalse);
    expect(background.allowBackgroundLocationUpdates, isTrue);
    expect(background.showBackgroundLocationIndicator, isTrue);
    expect(background.distanceFilter, 0);
    expect(background.pauseLocationUpdatesAutomatically, isFalse);
  });

  test(
    'Apple sharing does not create an uncancellable one-time request',
    () async {
      await service.dispose();
      service = FriendsLocationService(
        geolocator: geolocator,
        platform: TargetPlatform.iOS,
        heartbeatInterval: const Duration(milliseconds: 1),
      );
      await service.start(backgroundEnabled: true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(geolocator.currentRequests, 0);
      expect(geolocator.positions.hasListener, isTrue);
    },
  );

  test('desktop settings avoid mobile background configuration', () {
    for (final platform in [TargetPlatform.windows, TargetPlatform.linux]) {
      final settings = friendsMapLocationSettings(
        platform,
        forceGnss: false,
        backgroundEnabled: true,
      );
      expect(settings, isNot(isA<AndroidSettings>()));
      expect(settings, isNot(isA<AppleSettings>()));
    }
    final mac =
        friendsMapLocationSettings(
              TargetPlatform.macOS,
              forceGnss: false,
              backgroundEnabled: true,
            )
            as AppleSettings;
    expect(mac.allowBackgroundLocationUpdates, isFalse);
  });
}

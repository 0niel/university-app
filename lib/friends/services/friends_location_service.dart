import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

enum FriendsLocationStatus {
  stopped,
  locating,
  active,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  unavailable,
  failure,
}

class FriendsLocationService with WidgetsBindingObserver {
  FriendsLocationService({
    GeolocatorPlatform? geolocator,
    TargetPlatform? platform,
    bool? isWeb,
    this.heartbeatInterval = const Duration(seconds: 90),
  }) : _geolocator = geolocator ?? GeolocatorPlatform.instance,
       _platform = platform ?? defaultTargetPlatform,
       _isWeb = isWeb ?? kIsWeb {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground =
        lifecycle == null || lifecycle == .resumed || lifecycle == .inactive;
    WidgetsBinding.instance.addObserver(this);
  }

  final GeolocatorPlatform _geolocator;
  final TargetPlatform _platform;
  final bool _isWeb;
  final Duration heartbeatInterval;
  final _positions = StreamController<Position>.broadcast();
  final _statuses = StreamController<FriendsLocationStatus>.broadcast();
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<ServiceStatus>? _serviceSubscription;
  Timer? _retryTimer;
  Timer? _heartbeatTimer;
  FriendsLocationStatus _status = FriendsLocationStatus.stopped;
  var _generation = 0;
  var _enabled = false;
  var _backgroundEnabled = false;
  var _sharingEnabled = false;
  var _heartbeatBusy = false;
  var _disposed = false;
  var _foreground = true;
  DateTime? _lastPositionAt;

  Stream<Position> get positions => _positions.stream;
  Stream<FriendsLocationStatus> get statuses => _statuses.stream;
  FriendsLocationStatus get status => _status;
  bool get supportsBackground =>
      !_isWeb && (_platform == .android || _platform == .iOS);

  Future<void> start({
    required bool backgroundEnabled,
    bool requestPermission = true,
  }) async {
    if (_disposed) return;
    final nextBackground = backgroundEnabled && supportsBackground;
    if (_enabled &&
        _backgroundEnabled == nextBackground &&
        _sharingEnabled == backgroundEnabled &&
        _positionSubscription != null &&
        (_status == .locating || _status == .active)) {
      return;
    }
    final openPermissionSettings =
        !_isWeb && requestPermission && _status == .permissionDeniedForever;
    final openServiceSettings =
        !_isWeb && requestPermission && _status == .serviceDisabled;
    _enabled = true;
    _sharingEnabled = backgroundEnabled;
    _backgroundEnabled = nextBackground;
    final generation = ++_generation;
    _retryTimer?.cancel();
    _heartbeatTimer?.cancel();
    final previousSubscription = _positionSubscription;
    _positionSubscription = null;
    await previousSubscription?.cancel();
    if (!_isCurrent(generation)) return;
    if (!_foreground) return;
    _setStatus(.locating);
    try {
      if (!_isWeb && !await _geolocator.isLocationServiceEnabled()) {
        if (!_isCurrent(generation)) return;
        _setStatus(.serviceDisabled);
        _watchService();
        if (openServiceSettings) await _geolocator.openLocationSettings();
        return;
      }
      if (!_isCurrent(generation)) return;
      var permission = await _geolocator.checkPermission();
      if (!_isCurrent(generation)) return;
      if (permission == .denied && requestPermission) {
        permission = await _geolocator.requestPermission();
      }
      if (!_isCurrent(generation)) return;
      if (permission == .deniedForever) {
        _setStatus(.permissionDeniedForever);
        if (openPermissionSettings) await _geolocator.openAppSettings();
        return;
      }
      if (permission == .denied) {
        _setStatus(.permissionDenied);
        return;
      }
      if (permission == .unableToDetermine && !_isWeb) {
        _setStatus(.unavailable);
        return;
      }
      if (!_foreground) return;
      _watchService();
      _positionSubscription = _geolocator
          .getPositionStream(
            locationSettings: friendsMapLocationSettings(
              _platform,
              forceGnss: false,
              backgroundEnabled: _backgroundEnabled,
              isWeb: _isWeb,
            ),
          )
          .listen(
            (position) {
              if (!_isCurrent(generation)) return;
              _emitPosition(position);
            },
            onError: (Object error, StackTrace stackTrace) {
              if (!_isCurrent(generation)) return;
              _handleError(error);
            },
            onDone: () {
              if (!_isCurrent(generation)) return;
              _handleError(StateError('Location stream closed'));
            },
            cancelOnError: true,
          );
      if (_sharingEnabled &&
          (_isWeb || (_platform != .iOS && _platform != .macOS))) {
        _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
          unawaited(_refreshPosition(generation));
        });
      }
    } on Object catch (error) {
      if (_isCurrent(generation)) _handleError(error);
    }
  }

  bool _isCurrent(int generation) =>
      !_disposed && _enabled && generation == _generation;

  void _emitPosition(Position position) {
    if (!_isUsablePosition(position)) return;
    _lastPositionAt = position.timestamp;
    _setStatus(.active);
    _positions.add(position);
  }

  Future<void> _refreshPosition(int generation) async {
    if (!_isCurrent(generation) || _heartbeatBusy) return;
    if (!_foreground && (_isWeb || supportsBackground && !_backgroundEnabled)) {
      return;
    }
    _heartbeatBusy = true;
    try {
      final position = await _geolocator
          .getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: .high,
              timeLimit: Duration(seconds: 15),
            ),
          )
          .timeout(const Duration(seconds: 15));
      if (_isCurrent(generation)) _emitPosition(position);
    } on Object catch (error) {
      if (_isCurrent(generation) &&
          (error is PermissionDeniedException ||
              error is LocationServiceDisabledException)) {
        _handleError(error);
      }
    } finally {
      _heartbeatBusy = false;
    }
  }

  bool _isUsablePosition(Position position) {
    if (!position.latitude.isFinite ||
        !position.longitude.isFinite ||
        position.latitude.abs() > 90 ||
        position.longitude.abs() > 180 ||
        !position.accuracy.isFinite ||
        position.accuracy < 0) {
      return false;
    }
    final age = DateTime.now().difference(position.timestamp);
    if (age > const Duration(minutes: 2) || age < const Duration(minutes: -1)) {
      return false;
    }
    final previous = _lastPositionAt;
    return previous == null || position.timestamp.isAfter(previous);
  }

  void _watchService() {
    if (_isWeb || _serviceSubscription != null) return;
    try {
      _serviceSubscription = _geolocator.getServiceStatusStream().listen(
        (service) {
          if (_disposed || !_enabled) return;
          if (service == .disabled) {
            ++_generation;
            _heartbeatTimer?.cancel();
            unawaited(_positionSubscription?.cancel());
            _positionSubscription = null;
            _setStatus(.serviceDisabled);
          } else if (_foreground) {
            unawaited(
              start(
                backgroundEnabled: _sharingEnabled,
                requestPermission: false,
              ),
            );
          }
        },
        onError: (Object _) {},
      );
    } on Object catch (_) {
      _serviceSubscription = null;
    }
  }

  void _handleError(Object error) {
    ++_generation;
    _heartbeatTimer?.cancel();
    unawaited(_positionSubscription?.cancel());
    _positionSubscription = null;
    if (error is PermissionDeniedException) {
      _setStatus(.permissionDenied);
    } else if (error is LocationServiceDisabledException) {
      _setStatus(.serviceDisabled);
    } else if (error is UnsupportedError ||
        error is UnimplementedError ||
        error is MissingPluginException) {
      _setStatus(.unavailable);
    } else {
      _setStatus(.failure);
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    if (!_foreground || !_enabled || _disposed) return;
    _retryTimer = Timer(const Duration(seconds: 15), () {
      unawaited(
        start(backgroundEnabled: _sharingEnabled, requestPermission: false),
      );
    });
  }

  void _setStatus(FriendsLocationStatus status) {
    if (_disposed || _status == status) return;
    _status = status;
    _statuses.add(status);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == .resumed) {
      _foreground = true;
      if (_enabled && _status != .active) {
        unawaited(
          start(
            backgroundEnabled: _sharingEnabled,
            requestPermission: false,
          ),
        );
      }
    } else if (state == .paused || state == .hidden || state == .detached) {
      _foreground = false;
      _retryTimer?.cancel();
      if (_isWeb || (!_backgroundEnabled && supportsBackground)) {
        ++_generation;
        _heartbeatTimer?.cancel();
        unawaited(_positionSubscription?.cancel());
        _positionSubscription = null;
        _setStatus(.stopped);
      }
    }
  }

  Future<void> stop() async {
    _enabled = false;
    final generation = ++_generation;
    _retryTimer?.cancel();
    _heartbeatTimer?.cancel();
    _lastPositionAt = null;
    final positionSubscription = _positionSubscription;
    final serviceCancellation = _serviceSubscription?.cancel();
    _positionSubscription = null;
    _serviceSubscription = null;
    await positionSubscription?.cancel();
    await serviceCancellation;
    if (generation == _generation) _setStatus(.stopped);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    await stop();
    await _positions.close();
    await _statuses.close();
  }
}

LocationSettings friendsMapLocationSettings(
  TargetPlatform platform, {
  required bool forceGnss,
  bool backgroundEnabled = false,
  bool isWeb = false,
}) {
  if (isWeb) {
    return WebSettings(accuracy: .high);
  }
  return switch (platform) {
    .android => AndroidSettings(
      accuracy: .high,
      distanceFilter: 10,
      intervalDuration: const Duration(seconds: 10),
      forceLocationManager: forceGnss,
      foregroundNotificationConfig: backgroundEnabled
          ? const ForegroundNotificationConfig(
              notificationTitle: 'Геопозиция на карте',
              notificationText:
                  'Вы делитесь геопозицией. '
                  'Отключить можно в настройках карты.',
              enableWakeLock: true,
              setOngoing: true,
            )
          : null,
    ),
    .iOS || .macOS => AppleSettings(
      accuracy: .high,
      activityType: .otherNavigation,
      allowBackgroundLocationUpdates: backgroundEnabled && platform == .iOS,
      showBackgroundLocationIndicator: backgroundEnabled && platform == .iOS,
    ),
    .fuchsia || .linux || .windows => const LocationSettings(
      accuracy: .high,
      distanceFilter: 10,
    ),
  };
}

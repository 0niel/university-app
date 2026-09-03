import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_client/permission_client.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friend_location_merger.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_state.dart';
import 'package:rtu_mirea_app/friends/cubit/geo_fusion.dart';

export 'friends_map_state.dart';

class FriendsMapCubit extends Cubit<FriendsMapState> {
  FriendsMapCubit({
    required this._repository,
    PreferencesRepository? preferencesRepository,
    PermissionClient permissionClient = const PermissionClient(),
    GeoFusionFilter? fusionFilter,
    this.wifiRefineInterval = const Duration(seconds: 30),
  }) : _preferences = preferencesRepository,
       _permissions = permissionClient,
       _fusion = fusionFilter ?? GeoFusionFilter(),
       super(const FriendsMapState());

  final FriendsRepository _repository;
  final PreferencesRepository? _preferences;
  final PermissionClient _permissions;

  final GeoFusionFilter _fusion;

  final Duration wifiRefineInterval;

  static const _geoPrefsKey = 'geo_sharing';

  StreamSubscription<List<FriendLocationUpdate>>? _locationsSub;
  StreamSubscription<Position>? _positionSub;
  Future<void> _privacyOperations = Future.value();
  bool _isClosing = false;

  Future<void> load() async {
    if (state.status == .loading) return;
    emit(state.copyWith(status: .loading));
    try {
      final friends = await _repository.getFriends();
      if (isClosed) return;
      final requests = await _repository.getFriendRequests();
      if (isClosed) return;
      final isGhost = await _repository.getGhostMode();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: .ready,
          friends: friends,
          requests: requests,
          isGhost: isGhost,
        ),
      );
      await _loadGeoSettings();
      if (isClosed) return;
      await _subscribeToLocations();
      if (isClosed) return;
      await _startPublishingOwnLocation();
      if (isClosed) return;
      _startWifiRefineLoop();
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _subscribeToLocations() async {
    await _locationsSub?.cancel();
    if (isClosed) return;
    _locationsSub = _repository.watchLocations().listen(
      _applyLocationUpdates,
      onError: _onLocationStreamError,
    );
  }

  void _onLocationStreamError(Object error, StackTrace stackTrace) {
    if (isClosed) return;
    Logger().w('locations stream error', error: error, stackTrace: stackTrace);
    addError(error, stackTrace);
  }

  void _applyLocationUpdates(List<FriendLocationUpdate> rows) {
    if (isClosed) return;
    final byUser = {for (final row in rows) row.userId: row};
    final myId = _repository.currentUserId;

    var isGhost = state.isGhost;
    final mine = myId != null ? byUser[myId] : null;
    if (mine != null) isGhost = mine.isGhost;

    final friends = mergeFriendLocations(state.friends, rows);

    emit(state.copyWith(friends: friends, isGhost: isGhost));
  }

  DateTime? _lastPublishAt;
  StreamSubscription<Position>? _gnssSub;

  Position? _lastDevicePosition;
  DateTime? _lastDeviceFixAt;
  Timer? _wifiTimer;
  DateTime? _lastWifiSubmitAt;
  bool? _wifiPermissionGranted;
  var _wifiRefinementInProgress = false;

  Future<void> _startPublishingOwnLocation() async {
    final hasPermission = await _ensureLocationPermission();
    if (isClosed) return;
    if (!hasPermission) {
      emit(state.copyWith(locationPermissionDenied: true));
      return;
    }

    try {
      final last = await Geolocator.getLastKnownPosition();
      if (isClosed) return;
      if (last != null) _onPositionCandidate(last);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }

    await _positionSub?.cancel();
    if (isClosed) return;
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: friendsMapLocationSettings(
            defaultTargetPlatform,
            forceGnss: false,
          ),
        ).listen(
          _onPositionCandidate,
          onError: (Object error) => Logger().w('fused stream error: $error'),
        );

    await _gnssSub?.cancel();
    if (isClosed) return;
    if (defaultTargetPlatform == .android) {
      _gnssSub =
          Geolocator.getPositionStream(
            locationSettings: friendsMapLocationSettings(
              defaultTargetPlatform,
              forceGnss: true,
            ),
          ).listen(
            _onPositionCandidate,
            onError: (Object error) => Logger().w('gnss stream error: $error'),
          );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: friendsMapLocationSettings(
          defaultTargetPlatform,
          forceGnss: false,
        ),
      ).timeout(const Duration(seconds: 12));
      if (isClosed) return;
      _onPositionCandidate(position);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  @visibleForTesting
  void ingestDeviceFix(Position candidate) {
    final estimate = _fusion.add(
      GeoFix(
        latitude: candidate.latitude,
        longitude: candidate.longitude,
        accuracyM: candidate.accuracy,
        timestamp: candidate.timestamp,
        speedMps: (candidate.speed.isFinite && candidate.speed > 0)
            ? candidate.speed
            : null,
      ),
    );
    if (estimate == null || isClosed) return;

    _lastDevicePosition = candidate;
    _lastDeviceFixAt = DateTime.now();
    emit(
      state.copyWith(
        myLatitude: estimate.latitude,
        myLongitude: estimate.longitude,
        locationPermissionDenied: false,
      ),
    );
    unawaited(
      _maybePublish(
        estimate,
        heading: candidate.heading,
        speedMps: candidate.speed,
      ),
    );
  }

  void _onPositionCandidate(Position candidate) => ingestDeviceFix(candidate);

  Future<void> _maybePublish(
    GeoFix estimate, {
    double? heading,
    double? speedMps,
  }) async {
    final settings = state.geoSettings;
    if (state.isGhost || !settings.sharing || settings.visibility == .none) {
      return;
    }
    final now = DateTime.now();
    final last = _lastPublishAt;
    if (last != null && now.difference(last) < const Duration(seconds: 5)) {
      return;
    }
    _lastPublishAt = now;

    final (lat, lng, accuracy) = switch (settings.precision) {
      .campus => (
        _round(estimate.latitude, 0.01),
        _round(estimate.longitude, 0.01),
        1000.0,
      ),
      .city => (
        _round(estimate.latitude, 0.1),
        _round(estimate.longitude, 0.1),
        10000.0,
      ),
      .exact => (
        estimate.latitude,
        estimate.longitude,
        estimate.accuracyM,
      ),
    };

    try {
      await _repository.publishLocation(
        latitude: lat,
        longitude: lng,
        accuracyM: accuracy,
        heading: heading,
        speedMps: speedMps,
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  static const _deviceFixFreshness = Duration(seconds: 20);
  static const _deviceFixGoodAccuracyM = 60.0;
  static const _wifiSubmitInterval = Duration(seconds: 30);

  void _startWifiRefineLoop() {
    if (defaultTargetPlatform != .android) return;
    _wifiTimer?.cancel();
    _wifiTimer = Timer.periodic(wifiRefineInterval, (_) => refineViaWifi());
    unawaited(refineViaWifi());
  }

  @visibleForTesting
  Future<void> refineViaWifi() async {
    if (_wifiRefinementInProgress || isClosed || _isClosing) return;
    _wifiRefinementInProgress = true;
    try {
      if (!await _ensureWifiScanPermission()) return;
      if (isClosed || _isClosing) return;
      final accessPoints = await _repository.scanWifiAccessPoints();
      if (isClosed || _isClosing) return;
      if (accessPoints.length < 2) return;

      final device = _lastDevicePosition;
      final fixAt = _lastDeviceFixAt;
      final now = DateTime.now();
      final deviceAlive =
          device != null &&
          fixAt != null &&
          now.difference(fixAt) < _deviceFixFreshness &&
          device.accuracy > 0 &&
          device.accuracy <= _deviceFixGoodAccuracyM;

      if (deviceAlive) {
        await _maybeSubmitWifiObservations(device, accessPoints, now);
        return;
      }

      final estimate = await _repository.resolveWifiPosition(accessPoints);
      if (estimate == null || isClosed || _isClosing) return;
      _onWifiEstimate(estimate);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    } finally {
      _wifiRefinementInProgress = false;
    }
  }

  Future<void> _maybeSubmitWifiObservations(
    Position device,
    List<WifiAccessPointReading> accessPoints,
    DateTime now,
  ) async {
    final settings = state.geoSettings;
    if (!settings.sharing ||
        settings.visibility == .none ||
        state.isGhost ||
        isClosed ||
        _isClosing) {
      return;
    }
    final last = _lastWifiSubmitAt;
    if (last != null && now.difference(last) < _wifiSubmitInterval) return;
    _lastWifiSubmitAt = now;
    await _repository.submitWifiObservations(
      latitude: device.latitude,
      longitude: device.longitude,
      accuracyM: device.accuracy,
      accessPoints: accessPoints,
    );
  }

  void _onWifiEstimate(NetworkLocationEstimate wifiEstimate) {
    final estimate = _fusion.add(
      GeoFix(
        latitude: wifiEstimate.latitude,
        longitude: wifiEstimate.longitude,
        accuracyM: math.max(40, wifiEstimate.accuracyM),
        timestamp: DateTime.now(),
      ),
    );
    if (estimate == null || isClosed) return;
    emit(
      state.copyWith(
        myLatitude: estimate.latitude,
        myLongitude: estimate.longitude,
        locationPermissionDenied: false,
      ),
    );
    unawaited(_maybePublish(estimate));
  }

  Future<bool> _ensureWifiScanPermission() async {
    final cached = _wifiPermissionGranted;
    if (cached != null) return cached;
    try {
      final status = await _permissions.requestNearbyWifiDevices();
      _wifiPermissionGranted = status.isGranted || status.isLimited;
    } on Exception {
      _wifiPermissionGranted = false;
    }
    return _wifiPermissionGranted ?? false;
  }

  static double _round(double value, double grid) =>
      (value / grid).roundToDouble() * grid;

  Future<void> _loadGeoSettings() async {
    final prefs = _preferences;
    try {
      final entry = await prefs?.get(_geoPrefsKey);
      if (isClosed) return;
      final settings = entry == null
          ? const GeoSharingSettings()
          : GeoSharingSettings.fromJson(entry.value);
      await _applyGeoSettings(settings, persist: false);
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            geoSettings: state.geoSettings.copyWith(sharing: false),
            isGhost: true,
            privacySyncFailed: true,
          ),
        );
      }
      addError(error, stackTrace);
    }
  }

  Future<void> updateGeoSettings(GeoSharingSettings settings) async {
    await _enqueuePrivacyOperation(() => _updateGeoSettings(settings));
  }

  Future<void> _updateGeoSettings(GeoSharingSettings settings) async {
    if (isClosed || _isClosing) return;
    emit(state.copyWith(privacyBusy: true));
    try {
      await _applyGeoSettings(settings, persist: true);
      if (!isClosed && !_isClosing) {
        emit(state.copyWith(privacyBusy: false));
      }
    } on Object catch (error, stackTrace) {
      if (isClosed || _isClosing) return;
      addError(error, stackTrace);
      final safe = settings.copyWith(
        sharing: false,
        visibility: .none,
        privacyForcedGhost: true,
      );
      emit(
        state.copyWith(
          geoSettings: safe,
          isGhost: true,
          privacySyncFailed: true,
        ),
      );
      try {
        await _preferences?.set(_geoPrefsKey, safe.toJson());
      } on Object catch (error, stackTrace) {
        if (!isClosed && !_isClosing) addError(error, stackTrace);
      }
      if (isClosed || _isClosing) return;
      try {
        await _repository.setGhostMode(ghost: true);
      } on Object catch (error, stackTrace) {
        if (!isClosed && !_isClosing) addError(error, stackTrace);
      }
      if (!isClosed && !_isClosing) {
        emit(state.copyWith(privacyBusy: false));
      }
    }
  }

  Future<void> _applyGeoSettings(
    GeoSharingSettings settings, {
    required bool persist,
  }) async {
    if (isClosed || _isClosing) return;
    final shouldHide = !settings.sharing || settings.visibility == .none;
    final wasPrivacyForced =
        state.geoSettings.privacyForcedGhost || settings.privacyForcedGhost;
    final privacyForced = shouldHide && (wasPrivacyForced || !state.isGhost);
    final normalized = settings.copyWith(
      privacyForcedGhost: privacyForced,
    );

    if (shouldHide) {
      if (!isClosed) {
        emit(
          state.copyWith(
            geoSettings: normalized,
            isGhost: true,
            privacySyncFailed: false,
          ),
        );
      }
      await _repository.setGhostMode(ghost: true);
      if (isClosed || _isClosing) return;
      if (persist) await _preferences?.set(_geoPrefsKey, normalized.toJson());
    } else if (wasPrivacyForced) {
      if (persist) await _preferences?.set(_geoPrefsKey, normalized.toJson());
      if (isClosed || _isClosing) return;
      await _repository.setGhostMode(ghost: false);
    } else if (persist) {
      await _preferences?.set(_geoPrefsKey, normalized.toJson());
    }
    if (isClosed || _isClosing) return;
    emit(
      state.copyWith(
        geoSettings: normalized,
        isGhost: shouldHide || (!wasPrivacyForced && state.isGhost),
        privacySyncFailed: false,
      ),
    );
  }

  Future<bool> _ensureLocationPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      var permission = await Geolocator.checkPermission();
      if (permission == .denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == .always || permission == .whileInUse;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<void> toggleGhostMode() async {
    await _enqueuePrivacyOperation(_toggleGhostMode);
  }

  Future<void> _toggleGhostMode() async {
    if (isClosed || _isClosing) return;
    final settings = state.geoSettings;
    if (!settings.sharing || settings.visibility == .none) return;
    final next = !state.isGhost;
    emit(state.copyWith(isGhost: next, privacyBusy: true));
    try {
      await _repository.setGhostMode(ghost: next);
      if (isClosed || _isClosing) return;
      emit(state.copyWith(privacyBusy: false));
    } on Exception catch (error, stackTrace) {
      if (isClosed || _isClosing) return;
      emit(state.copyWith(isGhost: !next, privacyBusy: false));
      addError(error, stackTrace);
    }
  }

  Future<void> _enqueuePrivacyOperation(
    Future<void> Function() operation,
  ) {
    if (isClosed || _isClosing) return Future.value();
    final result = _privacyOperations.then((_) => operation());
    _privacyOperations = result.then<void>(
      (_) => null,
      onError: (Object _, StackTrace _) => null,
    );
    return result;
  }

  Future<bool> respondRequest({
    required String friendshipId,
    required bool accept,
  }) async {
    if (state.pendingResponseIds.contains(friendshipId)) return false;
    final index = state.requests.indexWhere(
      (request) => request.friendshipId == friendshipId,
    );
    if (index == -1) return false;
    final request = state.requests.elementAtOrNull(index);
    if (request == null) return false;
    emit(
      state.copyWith(
        requests: [...state.requests]..remove(request),
        pendingResponseIds: {...state.pendingResponseIds, friendshipId},
      ),
    );
    try {
      await _repository.respondFriendRequest(
        friendshipId: friendshipId,
        accept: accept,
      );
      if (isClosed) return false;
      final friends = await _repository.getFriends();
      if (isClosed) return false;
      final requests = await _repository.getFriendRequests();
      if (isClosed) return false;
      emit(
        state.copyWith(
          friends: friends,
          requests: requests,
          pendingResponseIds: {...state.pendingResponseIds}
            ..remove(friendshipId),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        final requests = [...state.requests]
          ..insert(index.clamp(0, state.requests.length), request);
        emit(
          state.copyWith(
            requests: requests,
            pendingResponseIds: {...state.pendingResponseIds}
              ..remove(friendshipId),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> sendRequest(String userId) async {
    try {
      await _repository.sendFriendRequest(userId);
      return true;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> removeFriend(String userId) async {
    try {
      await _repository.removeFriend(userId);
      if (isClosed) return true;
      final friends = await _repository.getFriends();
      if (isClosed) return true;
      emit(state.copyWith(friends: friends));
      return true;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<List<UserSearchResult>> search(String query) {
    return _repository.searchUsers(query);
  }

  @override
  Future<void> close() async {
    _isClosing = true;
    _wifiTimer?.cancel();
    await _locationsSub?.cancel();
    await _positionSub?.cancel();
    await _gnssSub?.cancel();
    return super.close();
  }
}

@visibleForTesting
LocationSettings friendsMapLocationSettings(
  TargetPlatform platform, {
  required bool forceGnss,
}) {
  return switch (platform) {
    .android => AndroidSettings(
      accuracy: .bestForNavigation,
      distanceFilter: 10,
      intervalDuration: const Duration(seconds: 5),
      forceLocationManager: forceGnss,
    ),
    .iOS || .macOS => AppleSettings(
      accuracy: .bestForNavigation,
      distanceFilter: 10,
      activityType: .fitness,
      allowBackgroundLocationUpdates: false,
    ),
    .fuchsia || .linux || .windows => const LocationSettings(
      accuracy: .bestForNavigation,
      distanceFilter: 10,
    ),
  };
}

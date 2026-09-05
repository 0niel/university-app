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
import 'package:rtu_mirea_app/friends/services/friends_location_service.dart';

export 'package:rtu_mirea_app/friends/services/friends_location_service.dart'
    show friendsMapLocationSettings;

export 'friends_map_state.dart';

class FriendsMapCubit extends Cubit<FriendsMapState> {
  FriendsMapCubit({
    required this._repository,
    PreferencesRepository? preferencesRepository,
    PermissionClient permissionClient = const PermissionClient(),
    GeoFusionFilter? fusionFilter,
    FriendsLocationService? locationService,
    this.wifiRefineInterval = const Duration(seconds: 30),
  }) : _preferences = preferencesRepository,
       _permissions = permissionClient,
       _fusion = fusionFilter ?? GeoFusionFilter(),
       _locationService = locationService ?? FriendsLocationService(),
       _ownerId = _repository.currentUserId,
       super(const FriendsMapState());

  final String? _ownerId;
  bool get _sessionEnded => _repository.currentUserId != _ownerId;
  final FriendsLocationService _locationService;
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
  bool _mapVisible = false;
  Future<void>? _initialization;
  StreamSubscription<FriendsLocationStatus>? _locationStatusSub;
  Timer? _studentsTimer;
  bool _studentsRefreshing = false;
  bool _publishInProgress = false;
  Completer<void>? _pendingPublish;
  bool _friendsRefreshing = false;

  Future<void> initialize() =>
      _initialization ??= _enqueuePrivacyOperation(_initialize);

  Future<void> _initialize() async {
    if (isClosed || _isClosing || _sessionEnded) return;
    emit(state.copyWith(privacyBusy: true));
    try {
      final isGhost = await _repository.getGhostMode();
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(state.copyWith(isGhost: isGhost));
      await _loadGeoSettings();
      if (state.privacySyncFailed) _initialization = null;
      if (isClosed || _isClosing || _sessionEnded) return;
      await _syncTracking(requestPermission: false);
    } on Object catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
      _initialization = null;
      emit(state.copyWith(isGhost: true, privacySyncFailed: true));
      addError(error, stackTrace);
    } finally {
      if (!isClosed && !_isClosing && !_sessionEnded) {
        emit(state.copyWith(privacyBusy: false));
      }
    }
  }

  Future<void> setMapVisible({required bool visible}) async {
    if (isClosed || _isClosing || _sessionEnded) return;
    _mapVisible = visible;
    _studentsTimer?.cancel();
    if (visible) {
      await load();
      if (isClosed || _isClosing || _sessionEnded || !_mapVisible) return;
      _studentsTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        unawaited(refreshStudents());
        unawaited(_refreshFriends());
      });
    } else {
      await _locationsSub?.cancel();
      _locationsSub = null;
    }
    if (!isClosed && !_isClosing && !_sessionEnded) {
      await _syncTracking(requestPermission: false);
    }
  }

  Future<void> refreshStudents() async {
    if (isClosed || _isClosing || _sessionEnded || _studentsRefreshing) return;
    _studentsRefreshing = true;
    emit(state.copyWith(studentsLoading: true));
    try {
      final students = await _repository.getMapStudents();
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          students: students,
          studentsLoading: false,
          studentsLoadFailed: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          students: const [],
          studentsLoading: false,
          studentsLoadFailed: true,
        ),
      );
      addError(error, stackTrace);
    } finally {
      _studentsRefreshing = false;
    }
  }

  Future<void> _refreshFriends() async {
    if (isClosed || _isClosing || _sessionEnded || _friendsRefreshing) return;
    _friendsRefreshing = true;
    try {
      final friends = await _repository.getFriends();
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(state.copyWith(friends: friends));
    } on Object catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          friends: [
            for (final friend in state.friends) friend.withoutLocation(),
          ],
        ),
      );
      addError(error, stackTrace);
    } finally {
      _friendsRefreshing = false;
    }
  }

  Future<void> retryLocation() => _syncTracking(requestPermission: true);

  Future<void> retryPrivacy() async {
    if (_initialization == null) {
      await initialize();
    } else {
      await updateGeoSettings(state.geoSettings);
    }
  }

  Future<void> _syncTracking({required bool requestPermission}) async {
    if (isClosed || _isClosing || _sessionEnded) return;
    final sharing =
        state.geoSettings.sharing &&
        state.geoSettings.visibility != .none &&
        !state.isGhost &&
        !state.privacySyncFailed;
    _wifiTimer?.cancel();
    if (!_mapVisible && !sharing) {
      await _locationService.stop();
      return;
    }
    _positionSub ??= _locationService.positions.listen(_onPositionCandidate);
    _locationStatusSub ??= _locationService.statuses.listen((status) {
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          locationStatus: status,
          backgroundLocationActive:
              status == FriendsLocationStatus.active &&
              _locationService.supportsBackground &&
              state.geoSettings.sharing &&
              !state.isGhost,
          locationPermissionDenied:
              status == FriendsLocationStatus.permissionDenied ||
              status == FriendsLocationStatus.permissionDeniedForever,
        ),
      );
    });
    await _locationService.start(
      backgroundEnabled: sharing,
      requestPermission: requestPermission,
    );
    if (!isClosed && !_isClosing && !_sessionEnded && sharing && _mapVisible) {
      _startWifiRefineLoop();
    }
  }

  Future<void> load() async {
    if (isClosed || _isClosing || _sessionEnded || state.status == .loading) {
      return;
    }
    emit(state.copyWith(status: .loading));
    try {
      final friends = await _repository.getFriends();
      if (isClosed || _isClosing || _sessionEnded) return;
      final requests = await _repository.getFriendRequests();
      if (isClosed || _isClosing || _sessionEnded) return;
      await initialize();
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          status: .ready,
          friends: friends,
          requests: requests,
        ),
      );
      await _subscribeToLocations();
    } on Exception catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    } finally {
      if (!isClosed && !_isClosing && !_sessionEnded) {
        await refreshStudents();
      }
    }
  }

  Future<void> _subscribeToLocations() async {
    await _locationsSub?.cancel();
    if (isClosed || _isClosing || _sessionEnded) return;
    _locationsSub = _repository.watchLocations().listen(
      _applyLocationUpdates,
      onError: _onLocationStreamError,
    );
  }

  void _onLocationStreamError(Object error, StackTrace stackTrace) {
    if (isClosed || _isClosing || _sessionEnded) return;
    emit(
      state.copyWith(
        friends: [
          for (final friend in state.friends) friend.withoutLocation(),
        ],
      ),
    );
    Logger().w('locations stream error', error: error, stackTrace: stackTrace);
    addError(error, stackTrace);
  }

  void _applyLocationUpdates(List<FriendLocationUpdate> rows) {
    if (isClosed || _isClosing || _sessionEnded) return;
    final byUser = {for (final row in rows) row.userId: row};
    final myId = _repository.currentUserId;

    var isGhost = state.isGhost;
    final mine = myId != null ? byUser[myId] : null;
    if (mine != null && !state.privacyBusy) {
      isGhost =
          mine.isGhost ||
          !state.geoSettings.sharing ||
          state.geoSettings.visibility == .none ||
          state.privacySyncFailed;
    }

    final friends = mergeFriendLocations(state.friends, rows);

    final ghostChanged = isGhost != state.isGhost;
    emit(state.copyWith(friends: friends, isGhost: isGhost));
    if (ghostChanged) unawaited(_syncTracking(requestPermission: false));
  }

  DateTime? _lastPublishAt;

  Position? _lastDevicePosition;
  DateTime? _lastDeviceFixAt;
  Timer? _wifiTimer;
  DateTime? _lastWifiSubmitAt;
  bool? _wifiPermissionGranted;
  var _wifiRefinementInProgress = false;

  @visibleForTesting
  void ingestDeviceFix(Position candidate) {
    if (isClosed ||
        _isClosing ||
        _sessionEnded ||
        candidate.latitude.abs() > 90 ||
        candidate.longitude.abs() > 180) {
      return;
    }
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
    if (isClosed ||
        _isClosing ||
        _sessionEnded ||
        _publishInProgress ||
        state.privacyBusy ||
        state.privacySyncFailed) {
      return;
    }
    if (state.isGhost || !settings.sharing || settings.visibility == .none) {
      return;
    }
    final now = DateTime.now();
    final last = _lastPublishAt;
    if (last != null && now.difference(last) < const Duration(seconds: 5)) {
      return;
    }
    _lastPublishAt = now;
    _publishInProgress = true;
    final pending = Completer<void>();
    _pendingPublish = pending;

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
        heading: settings.precision == .exact && heading?.isFinite == true
            ? heading
            : null,
        speedMps: settings.precision == .exact && speedMps?.isFinite == true
            ? speedMps
            : null,
      );
      if (!isClosed &&
          !_isClosing &&
          !_sessionEnded &&
          state.locationPublishFailed) {
        emit(state.copyWith(locationPublishFailed: false));
      }
    } on Object catch (error, stackTrace) {
      _lastPublishAt = null;
      if (!isClosed && !_isClosing && !_sessionEnded) {
        emit(state.copyWith(locationPublishFailed: true));
        addError(error, stackTrace);
      }
    } finally {
      _publishInProgress = false;
      pending.complete();
      if (identical(_pendingPublish, pending)) _pendingPublish = null;
    }
  }

  static const _deviceFixFreshness = Duration(seconds: 20);
  static const _deviceFixGoodAccuracyM = 60.0;
  static const _wifiSubmitInterval = Duration(seconds: 30);

  void _startWifiRefineLoop() {
    if (kIsWeb || defaultTargetPlatform != .android) return;
    _wifiTimer?.cancel();
    _wifiTimer = Timer.periodic(wifiRefineInterval, (_) => refineViaWifi());
    unawaited(refineViaWifi());
  }

  @visibleForTesting
  Future<void> refineViaWifi() async {
    if (_wifiRefinementInProgress || isClosed || _isClosing || _sessionEnded) {
      return;
    }
    _wifiRefinementInProgress = true;
    try {
      if (!await _ensureWifiScanPermission()) return;
      if (isClosed || _isClosing || _sessionEnded) return;
      final accessPoints = await _repository.scanWifiAccessPoints();
      if (isClosed || _isClosing || _sessionEnded) return;
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
      if (estimate == null || isClosed || _isClosing || _sessionEnded) return;
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
      if (isClosed || _isClosing || _sessionEnded) return;
      final settings = entry == null
          ? const GeoSharingSettings()
          : GeoSharingSettings.fromJson(entry.value);
      final visibleToStudents = await _repository.getLocationVisibility();
      if (isClosed || _isClosing || _sessionEnded) return;
      await _applyGeoSettings(
        settings.copyWith(
          visibility: settings.visibility == .none
              ? .none
              : visibleToStudents
              ? .students
              : .all,
        ),
        persist: false,
      );
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
    if (isClosed || _isClosing || _sessionEnded) return;
    emit(state.copyWith(privacyBusy: true));
    try {
      await _applyGeoSettings(settings, persist: true);
      if (!isClosed && !_isClosing && !_sessionEnded) {
        emit(state.copyWith(privacyBusy: false));
        await _syncTracking(requestPermission: true);
      }
    } on Object catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
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
        if (!isClosed && !_isClosing && !_sessionEnded) {
          addError(error, stackTrace);
        }
      }
      if (isClosed || _isClosing || _sessionEnded) return;
      try {
        await _repository.setGhostMode(ghost: true);
      } on Object catch (error, stackTrace) {
        if (!isClosed && !_isClosing && !_sessionEnded) {
          addError(error, stackTrace);
        }
      }
      if (!isClosed && !_isClosing && !_sessionEnded) {
        emit(state.copyWith(privacyBusy: false));
        await _syncTracking(requestPermission: false);
      }
    }
  }

  Future<void> _applyGeoSettings(
    GeoSharingSettings settings, {
    required bool persist,
  }) async {
    if (isClosed || _isClosing || _sessionEnded) return;
    final shouldHide = !settings.sharing || settings.visibility == .none;
    final wasPrivacyForced =
        state.geoSettings.privacyForcedGhost || settings.privacyForcedGhost;
    final privacyForced = shouldHide && (wasPrivacyForced || !state.isGhost);
    final normalized = settings.copyWith(privacyForcedGhost: privacyForced);
    final remainGhost = shouldHide || (!wasPrivacyForced && state.isGhost);
    if (shouldHide) {
      emit(
        state.copyWith(
          geoSettings: normalized,
          isGhost: true,
          backgroundLocationActive: false,
          privacySyncFailed: false,
        ),
      );
      await _repository.setGhostMode(ghost: true);
      if (isClosed || _isClosing || _sessionEnded) return;
      if (persist) await _preferences?.set(_geoPrefsKey, normalized.toJson());
    } else {
      final audienceChanged =
          settings.visibility != state.geoSettings.visibility;
      final publicationPending = _pendingPublish;
      final precisionChanged =
          settings.precision != state.geoSettings.precision;
      if (persist) {
        if (audienceChanged || precisionChanged || publicationPending != null) {
          await _repository.setGhostMode(ghost: true);
          if (isClosed || _isClosing || _sessionEnded) return;
        }
        await publicationPending?.future;
        if (isClosed || _isClosing || _sessionEnded) return;
        await _repository.setLocationVisibility(
          visibleToStudents: settings.visibility == .students,
        );
        if (isClosed || _isClosing || _sessionEnded) return;
        await _preferences?.set(_geoPrefsKey, normalized.toJson());
        if (isClosed || _isClosing || _sessionEnded) return;
      }
      if (!remainGhost &&
          (wasPrivacyForced ||
              (persist &&
                  (audienceChanged ||
                      precisionChanged ||
                      publicationPending != null)))) {
        await _repository.setGhostMode(ghost: false);
      }
    }
    if (isClosed || _isClosing || _sessionEnded) return;
    _lastPublishAt = null;
    emit(
      state.copyWith(
        geoSettings: normalized,
        isGhost: remainGhost,
        backgroundLocationActive:
            !remainGhost && state.backgroundLocationActive,
        privacySyncFailed: false,
      ),
    );
  }

  Future<void> toggleGhostMode() async {
    await _enqueuePrivacyOperation(_toggleGhostMode);
  }

  Future<void> _toggleGhostMode() async {
    if (isClosed || _isClosing || _sessionEnded) return;
    final settings = state.geoSettings;
    if (!settings.sharing || settings.visibility == .none) return;
    final next = !state.isGhost;
    emit(
      state.copyWith(
        isGhost: next,
        privacyBusy: true,
        backgroundLocationActive: !next && state.backgroundLocationActive,
      ),
    );
    try {
      await _repository.setGhostMode(ghost: next);
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(state.copyWith(privacyBusy: false, privacySyncFailed: false));
      _lastPublishAt = null;
      await _syncTracking(requestPermission: !next);
    } on Exception catch (error, stackTrace) {
      if (isClosed || _isClosing || _sessionEnded) return;
      emit(
        state.copyWith(
          isGhost: true,
          privacyBusy: false,
          privacySyncFailed: true,
        ),
      );
      await _syncTracking(requestPermission: false);
      addError(error, stackTrace);
    }
  }

  Future<void> _enqueuePrivacyOperation(
    Future<void> Function() operation,
  ) {
    if (isClosed || _isClosing || _sessionEnded) return Future.value();
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
    _studentsTimer?.cancel();
    final closed = super.close();
    await _locationStatusSub?.cancel();
    await _locationsSub?.cancel();
    await _positionSub?.cancel();
    await _locationService.dispose();
    await closed;
  }
}

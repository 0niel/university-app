import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync_status.dart';

export 'remote_preference_sync_status.dart';

mixin RemotePreferenceSync<S> on Cubit<S> {
  PreferencesRepository? get preferencesRepository;

  String get preferenceKey;

  Duration get remotePreferencePushDelay => const .new(seconds: 2);

  Map<String, dynamic>? toPreferencePayload(S state);

  S? fromPreferencePayload(Map<String, dynamic> payload);

  DateTime? remotePreferenceUpdatedAt(S _) => null;

  FutureOr<void> onRemotePreferenceRestored(S _, S _) => null;

  void onRemotePreferenceSyncStatusChanged(RemotePreferenceSyncStatus status) =>
      status;

  Timer? _pushTimer;
  Future<void>? _restoreFuture;
  Future<void>? _activePush;
  _PendingPreference? _pending;
  String? _lastSynced;
  var _remoteRevision = 0;
  var _localVersion = 0;
  var _restoreFinished = false;
  var _isInternalChange = false;
  var _hasUnresolvedConflict = false;

  Future<void> restoreFromRemote() =>
      _restoreFuture ??= _performRemoteRestore();

  Future<void> _performRemoteRestore() async {
    final repository = preferencesRepository;
    if (repository == null || !repository.hasAuthenticatedUser) {
      _restoreFinished = true;
      return;
    }
    _notifyStatus(.initializing);
    final versionAtStart = _localVersion;
    try {
      final entry = await repository.get(preferenceKey);
      if (isClosed) return;
      if (entry == null) {
        _remoteRevision = 0;
        _restoreFinished = true;
        _schedulePush(state);
        return;
      }
      _remoteRevision = entry.revision;
      final restored = fromPreferencePayload(entry.value);
      if (restored == null) {
        _restoreFinished = true;
        _notifyStatus(.offline);
        return;
      }
      final localUpdatedAt = remotePreferenceUpdatedAt(state)?.toUtc();
      final localIsNewer = localUpdatedAt?.isAfter(entry.updatedAt.toUtc());
      if (_localVersion != versionAtStart || localIsNewer == true) {
        _lastSynced = jsonEncode(entry.value);
        _restoreFinished = true;
        _schedulePush(state);
        return;
      }
      final previous = state;
      _lastSynced = jsonEncode(entry.value);
      _emitInternal(restored);
      _restoreFinished = true;
      _notifyStatus(.synced);
      try {
        await onRemotePreferenceRestored(previous, restored);
      } on Object catch (error, stackTrace) {
        _notifyStatus(.offline);
        addError(error, stackTrace);
      }
    } on PreferencesFailure catch (error, stackTrace) {
      _restoreFinished = true;
      _notifyStatus(.offline);
      addError(error, stackTrace);
      if (_pending != null) _armPush();
    }
  }

  @override
  void onChange(Change<S> change) {
    super.onChange(change);
    if (_isInternalChange) return;
    _localVersion++;
    _schedulePush(change.nextState);
  }

  void _schedulePush(S nextState) {
    final repository = preferencesRepository;
    if (repository == null || !repository.hasAuthenticatedUser) return;
    final payload = toPreferencePayload(nextState);
    if (payload == null) return;
    final encoded = jsonEncode(payload);
    if (encoded == _lastSynced) {
      _pending = null;
      _notifyStatus(.synced);
      return;
    }
    _pending = _PendingPreference(
      payload: payload,
      encoded: encoded,
    );
    _notifyStatus(_hasUnresolvedConflict ? .conflict : .dirty);
    if (_restoreFinished) _armPush();
  }

  void _armPush() {
    if (_hasUnresolvedConflict) return;
    _pushTimer?.cancel();
    _pushTimer = Timer(
      remotePreferencePushDelay,
      () => unawaited(flushRemotePreferences()),
    );
  }

  Future<void> flushRemotePreferences() => _flushRemotePreferences(
    resolveConflict: true,
  );

  Future<void> _flushRemotePreferences({
    required bool resolveConflict,
  }) async {
    if (_hasUnresolvedConflict && !resolveConflict) return;
    if (resolveConflict) _hasUnresolvedConflict = false;
    _pushTimer?.cancel();
    _pushTimer = null;
    final active = _activePush;
    if (active != null) {
      await active;
      return;
    }
    if (_pending == null) return;
    final push = _drainPushes();
    _activePush = push;
    try {
      await push;
    } finally {
      _activePush = null;
    }
  }

  Future<void> _drainPushes() async {
    final repository = preferencesRepository;
    if (repository == null) return;
    while (true) {
      final pending = _pending;
      if (pending == null) break;
      _pending = null;
      if (pending.encoded == _lastSynced) continue;
      _notifyStatus(.syncing);
      try {
        _remoteRevision = await repository.setVersioned(
          preferenceKey,
          pending.payload,
          expectedRevision: _remoteRevision,
        );
        _hasUnresolvedConflict = false;
        _lastSynced = pending.encoded;
      } on PreferenceConflictFailure catch (error, stackTrace) {
        await _refreshRevisionAfterConflict(repository);
        _pending ??= pending;
        _hasUnresolvedConflict = true;
        _notifyStatus(.conflict);
        addError(error, stackTrace);
        return;
      } on PreferencesFailure catch (error, stackTrace) {
        _pending ??= pending;
        _notifyStatus(.offline);
        addError(error, stackTrace);
        return;
      }
    }
    _notifyStatus(.synced);
  }

  Future<bool> _refreshRevisionAfterConflict(
    PreferencesRepository repository,
  ) async {
    try {
      final remote = await repository.get(preferenceKey);
      _remoteRevision = remote?.revision ?? 0;
      return true;
    } on PreferencesFailure {
      return false;
    }
  }

  void _notifyStatus(RemotePreferenceSyncStatus status) {
    if (isClosed) return;
    _isInternalChange = true;
    try {
      onRemotePreferenceSyncStatusChanged(status);
    } finally {
      _isInternalChange = false;
    }
  }

  void _emitInternal(S nextState) {
    _isInternalChange = true;
    try {
      emit(nextState);
    } finally {
      _isInternalChange = false;
    }
  }

  @override
  Future<void> close() async {
    _pushTimer?.cancel();
    try {
      await _restoreFuture;
      await _flushRemotePreferences(resolveConflict: false);
    } finally {
      await super.close();
    }
  }
}

class _PendingPreference {
  const _PendingPreference({
    required this.payload,
    required this.encoded,
  });

  final Map<String, dynamic> payload;
  final String encoded;
}

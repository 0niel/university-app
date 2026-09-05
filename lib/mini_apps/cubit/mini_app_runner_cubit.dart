import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:stac_bridge/stac_bridge.dart';

part 'mini_app_runner_state.dart';
part 'mini_app_runner_status.dart';
part 'mini_app_runner_cubit.freezed.dart';

class MiniAppRunnerCubit extends Cubit<MiniAppRunnerState> {
  MiniAppRunnerCubit({
    required MiniAppsRepository miniAppsRepository,
    required this.slug,
  }) : _repository = miniAppsRepository,
       super(const MiniAppRunnerState());

  final MiniAppsRepository _repository;
  final String slug;

  static const _screenEquality = DeepCollectionEquality();

  Timer? _refreshTimer;
  Future<void>? _refreshFuture;
  Future<void>? _foregroundRefresh;
  bool _refreshSilent = false;
  var _loadId = 0;
  final _storageOwner = Object();

  Future<void> load() async {
    if (isClosed) return;
    if (state.status == .ready && state.screen != null) return refresh();
    final loadId = ++_loadId;
    _refreshTimer?.cancel();
    emit(state.copyWith(status: .loading, refreshFailed: false));
    try {
      final app = await _repository.getApp(slug);
      if (!_isCurrent(loadId)) return;
      if (app == null) {
        emit(state.copyWith(status: .notFound));
        return;
      }
      if (app.needsConsent) {
        emit(
          state.copyWith(status: .consentRequired, app: app),
        );
        return;
      }
      await _loadScreen(app, loadId);
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(loadId)) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> applyConsents(List<MiniAppPermission> scopes) async {
    final app = state.app;
    if (app == null) return;
    final loadId = ++_loadId;
    emit(state.copyWith(status: .loading));
    try {
      await _repository.setConsents(appId: app.id, scopes: scopes);
      if (!_isCurrent(loadId)) return;
      await _loadScreen(app.copyWith(grantedPermissions: scopes), loadId);
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(loadId)) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> updateConsents(List<MiniAppPermission> scopes) async {
    final app = state.app;
    if (app == null) return;
    try {
      await _repository.setConsents(appId: app.id, scopes: scopes);
      emit(state.copyWith(app: app.copyWith(grantedPermissions: scopes)));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> setStorageValue(String key, Object? value) async {
    final app = state.app;
    if (app == null) return;
    try {
      await _repository.setStorageValue(appId: app.id, key: key, value: value);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _loadScreen(MiniApp app, int loadId) async {
    _refreshTimer?.cancel();
    final cachedScreen = await _repository.readCachedScreen(slug: slug);
    if (!_isCurrent(loadId)) return;
    if (cachedScreen != null) {
      final cachedStorage = await _repository.readCachedStorage(app.id);
      if (!_isCurrent(loadId)) return;
      primeMiniAppStorage(
        cachedStorage ?? const {},
        owner: _storageOwner,
      );
      emit(
        state.copyWith(
          status: .ready,
          app: app,
          screen: cachedScreen,
          fromCache: true,
          refreshing: true,
          refreshFailed: false,
        ),
      );
    }

    try {
      final storage = await _repository.getStorage(app.id);
      if (!_isCurrent(loadId)) return;
      primeMiniAppStorage(storage, owner: _storageOwner);
      final screen = await _repository.fetchScreen(slug: slug);
      if (!_isCurrent(loadId)) return;
      _emitScreen(app, screen);
      _scheduleAutoRefresh(screen);
    } on Exception {
      if (!_isCurrent(loadId)) return;
      if (cachedScreen == null) rethrow;
      emit(state.copyWith(refreshing: false, refreshFailed: true));
      _scheduleAutoRefresh(cachedScreen);
    }
    if (_isCurrent(loadId) && app.status == .published) {
      await _repository.trackLaunch(app.id);
    }
  }

  void _emitScreen(MiniApp app, Map<String, dynamic> screen) {
    emit(
      state.copyWith(
        status: .ready,
        app: app,
        screen: _screenEquality.equals(state.screen, screen)
            ? state.screen
            : screen,
        fromCache: false,
        refreshing: false,
        refreshFailed: false,
      ),
    );
  }

  void _scheduleAutoRefresh(Map<String, dynamic> screen) {
    _refreshTimer?.cancel();
    final raw = screen['refreshIntervalSeconds'];
    final seconds = raw is num ? raw.toInt() : 0;
    if (seconds <= 0) return;
    _refreshTimer = Timer(
      Duration(seconds: seconds.clamp(5, 3600)),
      () => unawaited(refresh(silent: true)),
    );
  }

  Future<void> refresh({bool silent = false}) {
    if (isClosed) return Future<void>.value();
    final active = _refreshFuture;
    if (active != null) {
      if (!silent && !state.refreshing) {
        emit(state.copyWith(refreshing: true, refreshFailed: false));
      }
      if (!silent && _refreshSilent) return _queueForegroundRefresh(active);
      return active;
    }
    final app = state.app;
    if (app == null || state.status != .ready || state.screen == null) {
      return load();
    }
    final loadId = ++_loadId;
    _refreshTimer?.cancel();
    if (!silent) {
      emit(state.copyWith(refreshing: true, refreshFailed: false));
    }
    _refreshSilent = silent;
    late final Future<void> future;
    future = _refreshScreen(app, loadId).whenComplete(() {
      if (identical(_refreshFuture, future)) _refreshFuture = null;
    });
    _refreshFuture = future;
    return future;
  }

  Future<void> _queueForegroundRefresh(Future<void> active) {
    final queued = _foregroundRefresh;
    if (queued != null) return queued;
    final loadId = _loadId;
    late final Future<void> future;
    future = active
        .then((_) async {
          if (_isCurrent(loadId)) await refresh();
        })
        .whenComplete(() {
          if (identical(_foregroundRefresh, future)) _foregroundRefresh = null;
        });
    _foregroundRefresh = future;
    return future;
  }

  Future<void> _refreshScreen(MiniApp app, int loadId) async {
    try {
      final storage = await _repository.getStorage(app.id);
      if (!_isCurrent(loadId)) return;
      final screen = await _repository.fetchScreen(slug: slug);
      if (!_isCurrent(loadId)) return;
      if (_refreshSilent && _foregroundRefresh != null) return;
      primeMiniAppStorage(storage, owner: _storageOwner);
      _emitScreen(app, screen);
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(loadId)) return;
      if (_refreshSilent && _foregroundRefresh != null) return;
      emit(state.copyWith(refreshing: false, refreshFailed: true));
      addError(error, stackTrace);
    } finally {
      final screen = state.screen;
      if (_isCurrent(loadId) && screen != null) _scheduleAutoRefresh(screen);
    }
  }

  @override
  Future<void> close() {
    _loadId += 1;
    _refreshTimer?.cancel();
    clearMiniAppStorage(owner: _storageOwner);
    return super.close();
  }

  bool _isCurrent(int loadId) => !isClosed && loadId == _loadId;

  Future<Map<String, dynamic>?> fetchPage(String path) async {
    try {
      return await _repository.fetchScreen(slug: slug, path: path);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  Future<void> rate(int rating) async {
    final app = state.app;
    if (app == null) return;
    try {
      await _repository.rateApp(appId: app.id, rating: rating);
      emit(state.copyWith(app: app.copyWith(myRating: rating)));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<bool> report(MiniAppReportReason reason, String details) async {
    final app = state.app;
    if (app == null) return false;
    try {
      await _repository.reportApp(
        appId: app.id,
        reason: reason,
        details: details,
      );
      emit(state.copyWith(app: app.copyWith(hasMyOpenReport: true)));
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }
}

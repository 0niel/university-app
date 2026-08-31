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
  var _loadId = 0;
  final _storageOwner = Object();

  Future<void> load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(status: .loading));
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
      _scheduleAutoRefresh(cachedScreen);
    }
    if (_isCurrent(loadId) && app.status == .published) {
      await _repository.trackLaunch(app.id);
    }
  }

  void _emitScreen(MiniApp app, Map<String, dynamic> screen) {
    if (state.status == .ready &&
        _screenEquality.equals(state.screen, screen)) {
      return;
    }
    emit(
      state.copyWith(
        status: .ready,
        app: app,
        screen: screen,
        fromCache: false,
      ),
    );
  }

  void _scheduleAutoRefresh(Map<String, dynamic> screen) {
    _refreshTimer?.cancel();
    final raw = screen['refreshIntervalSeconds'];
    final seconds = raw is num ? raw.toInt() : 0;
    if (seconds <= 0) return;
    _refreshTimer = Timer.periodic(
      Duration(seconds: seconds.clamp(5, 3600)),
      (_) => unawaited(_refresh()),
    );
  }

  Future<void> _refresh() async {
    final app = state.app;
    if (app == null || state.status != .ready) return;
    final loadId = _loadId;
    try {
      final storage = await _repository.getStorage(app.id);
      if (!_isCurrent(loadId)) return;
      primeMiniAppStorage(storage, owner: _storageOwner);
      final screen = await _repository.fetchScreen(slug: slug);
      if (!_isCurrent(loadId)) return;
      _emitScreen(app, screen);
    } on Exception catch (_) {}
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

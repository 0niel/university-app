import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

part 'mini_apps_catalog_state.dart';
part 'mini_apps_catalog_status.dart';
part 'mini_apps_catalog_cubit.freezed.dart';

class MiniAppsCatalogCubit extends Cubit<MiniAppsCatalogState> {
  MiniAppsCatalogCubit({required MiniAppsRepository miniAppsRepository})
    : _repository = miniAppsRepository,
      super(const MiniAppsCatalogState());

  final MiniAppsRepository _repository;
  var _appsRequestId = 0;
  var _loadRequestId = 0;

  Future<void> load() async {
    if (isClosed) return;
    final appsRequestId = ++_appsRequestId;
    final loadRequestId = ++_loadRequestId;
    emit(state.copyWith(status: .loading));
    try {
      final responses = await Future.wait<Object?>([
        _repository.getApps(
          query: state.query.isEmpty ? null : state.query,
          category: state.category,
          sort: state.sort,
          includeHidden: state.showHidden,
        ),
        _repository.getMyApps(),
        _repository.isModerator(),
        _repository.getRecentApps(),
      ]);
      final result = switch (responses) {
        [
          final List<MiniApp> loadedApps,
          final List<MiniApp> loadedMyApps,
          final bool loadedModeratorFlag,
          final List<MiniApp> loadedRecents,
        ] =>
          (
            loadedApps,
            loadedMyApps,
            loadedModeratorFlag,
            loadedRecents,
          ),
        _ => throw const FormatException('Invalid mini apps response types'),
      };
      final (apps, myApps, isModerator, recents) = result;
      if (isClosed || loadRequestId != _loadRequestId) return;
      final hasLatestApps = appsRequestId == _appsRequestId;
      emit(
        state.copyWith(
          status: hasLatestApps ? .populated : state.status,
          apps: hasLatestApps ? apps : state.apps,
          myApps: myApps,
          isModerator: isModerator,
          recents: recents,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed ||
          appsRequestId != _appsRequestId ||
          loadRequestId != _loadRequestId) {
        return;
      }
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> queryChanged(String query) async {
    final trimmed = query.trim();
    if (isClosed || state.query == trimmed) return;
    emit(state.copyWith(query: trimmed));
    await _refetchApps();
  }

  Future<void> categoryChanged(MiniAppCategory? category) async {
    if (isClosed || state.category == category) return;
    emit(state.copyWith(category: category));
    await _refetchApps();
  }

  Future<void> searchToggled() async {
    if (isClosed) return;
    final isSearching = !state.isSearching;
    final hadQuery = state.query.isNotEmpty;
    emit(
      state.copyWith(
        isSearching: isSearching,
        query: isSearching ? state.query : '',
      ),
    );
    if (!isSearching && hadQuery) await _refetchApps();
  }

  Future<void> sortChanged(MiniAppSort sort) async {
    if (isClosed || state.sort == sort) return;
    emit(state.copyWith(sort: sort));
    await _refetchApps();
  }

  Future<void> resetFilters() async {
    if (isClosed || (state.query.isEmpty && state.category == null)) return;
    emit(state.copyWith(query: '', category: null));
    await _refetchApps();
  }

  Future<void> toggleFeatured(MiniApp app) async {
    if (isClosed) return;
    try {
      await _repository.setFeatured(appId: app.id, featured: !app.isFeatured);
      await _refetchApps();
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
    }
  }

  Future<void> setHidden(MiniApp app, {required bool hidden}) async {
    if (isClosed) return;
    try {
      await _repository.setHidden(appId: app.id, hidden: hidden);
      if (isClosed) return;
      final apps = state.showHidden
          ? [
              for (final a in state.apps)
                if (a.id == app.id) a.copyWith(isHidden: hidden) else a,
            ]
          : state.apps.where((a) => a.id != app.id || !hidden).toList();
      emit(state.copyWith(apps: apps));
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
    }
  }

  Future<bool> report(
    MiniApp app,
    MiniAppReportReason reason,
    String details,
  ) async {
    if (isClosed) return false;
    try {
      await _repository.reportApp(
        appId: app.id,
        reason: reason,
        details: details,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          apps: [
            for (final a in state.apps)
              if (a.id == app.id) a.copyWith(hasMyOpenReport: true) else a,
          ],
        ),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (isClosed) return false;
      addError(error, stackTrace);
      return false;
    }
  }

  Future<void> rate(MiniApp app, int rating) async {
    if (isClosed) return;
    try {
      await _repository.rateApp(appId: app.id, rating: rating);
      if (isClosed) return;
      emit(
        state.copyWith(
          apps: [
            for (final a in state.apps)
              if (a.id == app.id) a.copyWith(myRating: rating) else a,
          ],
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
    }
  }

  Future<void> setConsents(MiniApp app, List<MiniAppPermission> scopes) async {
    if (isClosed) return;
    try {
      await _repository.setConsents(appId: app.id, scopes: scopes);
      if (isClosed) return;
      emit(
        state.copyWith(
          apps: [
            for (final a in state.apps)
              if (a.id == app.id) a.copyWith(grantedPermissions: scopes) else a,
          ],
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
    }
  }

  Future<void> deleteMyApp(MiniApp app) async {
    if (isClosed) return;
    try {
      await _repository.deleteApp(app.id);
      if (isClosed) return;
      emit(
        state.copyWith(
          myApps: state.myApps.where((a) => a.id != app.id).toList(),
          apps: state.apps.where((a) => a.id != app.id).toList(),
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
    }
  }

  Future<void> _refetchApps() async {
    if (isClosed) return;
    final requestId = ++_appsRequestId;
    final query = state.query.isEmpty ? null : state.query;
    final category = state.category;
    final sort = state.sort;
    final includeHidden = state.showHidden;
    emit(state.copyWith(status: .loading));
    try {
      final apps = await _repository.getApps(
        query: query,
        category: category,
        sort: sort,
        includeHidden: includeHidden,
      );
      if (requestId != _appsRequestId || isClosed) return;
      emit(state.copyWith(status: .populated, apps: apps));
    } on Exception catch (error, stackTrace) {
      if (requestId != _appsRequestId || isClosed) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _appsRequestId++;
    _loadRequestId++;
    return super.close();
  }
}

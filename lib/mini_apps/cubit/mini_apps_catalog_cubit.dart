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

  Future<void> load() async {
    final appsRequestId = ++_appsRequestId;
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
      if (isClosed) return;
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
      if (appsRequestId != _appsRequestId || isClosed) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> queryChanged(String query) async {
    emit(state.copyWith(query: query.trim()));
    await _refetchApps();
  }

  Future<void> categoryChanged(MiniAppCategory? category) async {
    emit(state.copyWith(category: category));
    await _refetchApps();
  }

  Future<void> searchToggled() async {
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
    emit(state.copyWith(sort: sort));
    await _refetchApps();
  }

  Future<void> toggleFeatured(MiniApp app) async {
    try {
      await _repository.setFeatured(appId: app.id, featured: !app.isFeatured);
      await _refetchApps();
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> setHidden(MiniApp app, {required bool hidden}) async {
    try {
      await _repository.setHidden(appId: app.id, hidden: hidden);
      final apps = state.showHidden
          ? [
              for (final a in state.apps)
                if (a.id == app.id) a.copyWith(isHidden: hidden) else a,
            ]
          : state.apps.where((a) => a.id != app.id || !hidden).toList();
      emit(state.copyWith(apps: apps));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<bool> report(
    MiniApp app,
    MiniAppReportReason reason,
    String details,
  ) async {
    try {
      await _repository.reportApp(
        appId: app.id,
        reason: reason,
        details: details,
      );
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
      addError(error, stackTrace);
      return false;
    }
  }

  Future<void> rate(MiniApp app, int rating) async {
    try {
      await _repository.rateApp(appId: app.id, rating: rating);
      emit(
        state.copyWith(
          apps: [
            for (final a in state.apps)
              if (a.id == app.id) a.copyWith(myRating: rating) else a,
          ],
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> setConsents(MiniApp app, List<MiniAppPermission> scopes) async {
    try {
      await _repository.setConsents(appId: app.id, scopes: scopes);
      emit(
        state.copyWith(
          apps: [
            for (final a in state.apps)
              if (a.id == app.id) a.copyWith(grantedPermissions: scopes) else a,
          ],
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> deleteMyApp(MiniApp app) async {
    try {
      await _repository.deleteApp(app.id);
      emit(
        state.copyWith(
          myApps: state.myApps.where((a) => a.id != app.id).toList(),
          apps: state.apps.where((a) => a.id != app.id).toList(),
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _refetchApps() async {
    final requestId = ++_appsRequestId;
    final query = state.query.isEmpty ? null : state.query;
    final category = state.category;
    final sort = state.sort;
    final includeHidden = state.showHidden;
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
}

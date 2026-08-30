part of 'mini_apps_catalog_cubit.dart';

@freezed
abstract class MiniAppsCatalogState with _$MiniAppsCatalogState {
  const factory MiniAppsCatalogState({
    @Default(MiniAppsCatalogStatus.initial) MiniAppsCatalogStatus status,
    @Default(<MiniApp>[]) List<MiniApp> apps,
    @Default(<MiniApp>[]) List<MiniApp> myApps,
    @Default(<MiniApp>[]) List<MiniApp> recents,
    @Default(MiniAppSort.popular) MiniAppSort sort,
    MiniAppCategory? category,
    @Default('') String query,
    @Default(false) bool isSearching,
    @Default(false) bool showHidden,
    @Default(false) bool isModerator,
  }) = _MiniAppsCatalogState;
}

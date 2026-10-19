part of 'mini_apps_catalog.dart';

extension _CatalogResults on MiniAppsCatalogState {
  bool get hasFilters => query.isNotEmpty || category != null;

  bool get showRecents => !hasFilters && recents.isNotEmpty;

  int get resultCount => {
    for (final app in apps) app.id,
    for (final app in visibleOwnedApps) app.id,
  }.length;

  List<MiniApp> get visibleOwnedApps {
    final term = query.toLowerCase();
    return myApps.where((app) {
      final matchesCategory = category == null || app.category == category;
      final matchesQuery =
          term.isEmpty ||
          '${app.name} ${app.description} ${app.slug}'.toLowerCase().contains(
            term,
          );
      return matchesCategory && matchesQuery;
    }).toList();
  }

  bool get hasVisibleContent => apps.isNotEmpty || visibleOwnedApps.isNotEmpty;
}

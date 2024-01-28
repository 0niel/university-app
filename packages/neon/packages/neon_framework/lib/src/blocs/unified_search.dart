import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

/// Bloc for managing unified search.
sealed class UnifiedSearchBloc implements InteractiveBloc {
  @internal
  factory UnifiedSearchBloc(
    AppsBloc appsBloc,
    Account account,
  ) =>
      _UnifiedSearchBloc(
        appsBloc,
        account,
      );

  /// Search for a [term].
  void search(String term);

  /// Enable unified search.
  void enable();

  /// Disable unified search.
  void disable();

  /// Contains whether unified search is currently enabled.
  BehaviorSubject<bool> get enabled;

  /// Contains the unified search results mapped by provider.
  BehaviorSubject<Result<Map<core.UnifiedSearchProvider, Result<core.UnifiedSearchResult>>?>> get results;
}

class _UnifiedSearchBloc extends InteractiveBloc implements UnifiedSearchBloc {
  _UnifiedSearchBloc(
    this.appsBloc,
    this.account,
  ) {
    appsBloc.activeApp.listen((_) {
      if (enabled.value) {
        disable();
      }
    });
  }

  final AppsBloc appsBloc;
  final Account account;
  String term = '';

  @override
  BehaviorSubject<bool> enabled = BehaviorSubject.seeded(false);

  @override
  BehaviorSubject<Result<Map<core.UnifiedSearchProvider, Result<core.UnifiedSearchResult>>?>> results =
      BehaviorSubject.seeded(Result.success(null));

  @override
  void dispose() {
    unawaited(enabled.close());
    unawaited(results.close());
    super.dispose();
  }

  @override
  Future<void> refresh() async {
    if (term.isEmpty) {
      results.add(Result.success(null));
      return;
    }

    try {
      results.add(results.value.asLoading());
      final response = await account.client.core.unifiedSearch.getProviders();
      final providers = response.body.ocs.data;
      results.add(
        Result.success(Map.fromEntries(getLoadingProviders(providers))),
      );
      for (final provider in providers) {
        unawaited(searchProvider(provider));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      results.add(Result.error(e));
    }
  }

  @override
  Future<void> search(String term) async {
    this.term = term.trim();
    await refresh();
  }

  @override
  void enable() {
    enabled.add(true);
  }

  @override
  void disable() {
    enabled.add(false);
    results.add(Result.success(null));
    term = '';
  }

  Iterable<MapEntry<core.UnifiedSearchProvider, Result<core.UnifiedSearchResult>>> getLoadingProviders(
    Iterable<core.UnifiedSearchProvider> providers,
  ) sync* {
    for (final provider in providers) {
      yield MapEntry(provider, Result.loading());
    }
  }

  Future<void> searchProvider(core.UnifiedSearchProvider provider) async {
    updateResults(provider, Result.loading());
    try {
      final response = await account.client.core.unifiedSearch.search(
        providerId: provider.id,
        term: term,
      );
      updateResults(provider, Result.success(response.body.ocs.data));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      updateResults(provider, Result.error(e));
    }
  }

  void updateResults(core.UnifiedSearchProvider provider, Result<core.UnifiedSearchResult> result) => results.add(
        Result.success(
          Map.fromEntries(
            sortResults({
              ...?results.value.data,
              provider: result,
            }),
          ),
        ),
      );

  Iterable<MapEntry<core.UnifiedSearchProvider, Result<core.UnifiedSearchResult>>> sortResults(
    Map<core.UnifiedSearchProvider, Result<core.UnifiedSearchResult>> results,
  ) sync* {
    final activeApp = appsBloc.activeApp.value;

    yield* results.entries
        .where((entry) => providerMatchesApp(entry.key, activeApp))
        .sorted((a, b) => sortEntriesCount(a.value, b.value));
    yield* results.entries
        .whereNot((entry) => providerMatchesApp(entry.key, activeApp))
        .where((entry) => hasEntries(entry.value))
        .sorted((a, b) => sortEntriesCount(a.value, b.value));
  }

  bool providerMatchesApp(core.UnifiedSearchProvider provider, AppImplementation app) =>
      provider.id == app.id || provider.id.startsWith('${app.id}_');

  bool hasEntries(Result<core.UnifiedSearchResult> result) => !result.hasData || result.requireData.entries.isNotEmpty;

  int sortEntriesCount(Result<core.UnifiedSearchResult> a, Result<core.UnifiedSearchResult> b) =>
      (b.data?.entries.length ?? 0).compareTo(a.data?.entries.length ?? 0);
}

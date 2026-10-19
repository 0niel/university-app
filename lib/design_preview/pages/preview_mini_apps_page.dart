import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_mini_app_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_text_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_catalog.dart';

class PreviewMiniAppsPage extends StatefulWidget {
  const PreviewMiniAppsPage({required this.onOpen, super.key});

  final Future<void> Function(MiniApp app) onOpen;

  @override
  State<PreviewMiniAppsPage> createState() => _PreviewMiniAppsPageState();
}

class _PreviewMiniAppsPageState extends State<PreviewMiniAppsPage> {
  var _state = const MiniAppsCatalogState(status: .populated);
  List<MiniApp> _apps = const [];
  var _requestId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apps = PreviewMiniAppFixtures.apps(context.l10n);
    _state = _state.copyWith(
      apps: _filteredApps(_state),
      recents: _apps.take(3).toList(),
    );
  }

  List<MiniApp> _filteredApps(MiniAppsCatalogState state) {
    final query = state.query.toLowerCase();
    final apps = _apps.where((app) {
      final matchesCategory =
          state.category == null || app.category == state.category;
      return matchesCategory &&
          '${app.name} ${app.description}'.toLowerCase().contains(query);
    }).toList();
    return apps..sort((first, second) {
      final order = switch (state.sort) {
        MiniAppSort.popular => second.launchCount.compareTo(first.launchCount),
        MiniAppSort.top => second.ratingAvg.compareTo(first.ratingAvg),
        MiniAppSort.newest =>
          (second.publishedAt?.microsecondsSinceEpoch ?? 0).compareTo(
            first.publishedAt?.microsecondsSinceEpoch ?? 0,
          ),
      };
      return order == 0 ? first.id.compareTo(second.id) : order;
    });
  }

  Future<void> _refresh(MiniAppsCatalogState next) async {
    final requestId = ++_requestId;
    setState(() => _state = next.copyWith(status: .loading));
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted || requestId != _requestId) return;
    setState(() {
      _state = _state.copyWith(
        status: .populated,
        apps: _filteredApps(_state),
      );
    });
  }

  void _updateFilters(MiniAppsCatalogState next) {
    if (next == _state) return;
    unawaited(_refresh(next));
  }

  void _toggleSearch() {
    final searching = !_state.isSearching;
    final next = _state.copyWith(
      isSearching: searching,
      query: searching ? _state.query : '',
    );
    if (!searching && _state.query.isNotEmpty) {
      _updateFilters(next);
    } else {
      setState(() => _state = next);
    }
  }

  void _open(MiniApp app) {
    setState(() {
      _state = _state.copyWith(
        recents: [
          app,
          ..._state.recents.where((recent) => recent.id != app.id),
        ],
      );
    });
    unawaited(widget.onOpen(app));
  }

  Future<void> _create() async {
    final name = await showAppSheet<String>(
      context,
      title: context.l10n.miniAppsSubmitTitle,
      child: PreviewTextSheet(label: context.l10n.miniAppsSubmitNameHint),
    );
    if (!mounted || name == null || name.trim().isEmpty) return;
    final id = 'preview-draft-${DateTime.now().microsecondsSinceEpoch}';
    final app = MiniApp(
      id: id,
      slug: id,
      name: name.trim(),
      isOwner: true,
      category: .tools,
      accentColor: '#51B7A6',
    );
    setState(() => _state = _state.copyWith(myApps: [app, ..._state.myApps]));
  }

  @override
  void dispose() {
    _requestId++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MiniAppsCatalog(
    state: _state,
    onRefresh: () => _refresh(_state),
    onQueryChanged: (query) =>
        _updateFilters(_state.copyWith(query: query.trim())),
    onCategoryChanged: (category) =>
        _updateFilters(_state.copyWith(category: category)),
    onSortChanged: (sort) => _updateFilters(_state.copyWith(sort: sort)),
    onSearchToggled: _toggleSearch,
    onOpen: _open,
    onActions: (app) => unawaited(widget.onOpen(app)),
    onCreate: () => unawaited(_create()),
    onResetFilters: () =>
        _updateFilters(_state.copyWith(query: '', category: null)),
    onBack: () => Navigator.of(context).pop(),
  );
}

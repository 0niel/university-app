import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';

part 'mini_apps_app_bar.dart';
part 'mini_apps_search_field.dart';
part 'mini_apps_sort_button.dart';
part 'mini_apps_sort_menu.dart';
part 'sort_icon.dart';
part 'category_chips.dart';
part 'catalog_body.dart';
part 'catalog_toolbar.dart';
part 'catalog_filters.dart';
part 'recent_mini_apps.dart';
part 'catalog_section_label.dart';
part 'catalog_skeleton.dart';
part 'catalog_section_label_skeleton.dart';
part 'catalog_feedback.dart';
part 'catalog_results.dart';

class MiniAppsCatalog extends StatefulWidget {
  const MiniAppsCatalog({
    required this.state,
    required this.onRefresh,
    required this.onQueryChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onSearchToggled,
    required this.onOpen,
    required this.onActions,
    required this.onCreate,
    required this.onResetFilters,
    this.onBack,
    this.onModerate,
    super.key,
  });

  final MiniAppsCatalogState state;
  final AsyncCallback onRefresh;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<MiniAppCategory?> onCategoryChanged;
  final ValueChanged<MiniAppSort> onSortChanged;
  final VoidCallback onSearchToggled;
  final ValueChanged<MiniApp> onOpen;
  final ValueChanged<MiniApp> onActions;
  final VoidCallback onCreate;
  final VoidCallback onResetFilters;
  final VoidCallback? onBack;
  final VoidCallback? onModerate;

  @override
  State<MiniAppsCatalog> createState() => _MiniAppsCatalogState();
}

class _MiniAppsCatalogState extends State<MiniAppsCatalog> {
  late final _searchController = TextEditingController(
    text: widget.state.query,
  );
  final _searchFocus = FocusNode();
  late String _requestedQuery = widget.state.query;
  Timer? _queryDelay;
  Timer? _focusDelay;

  @override
  void initState() {
    super.initState();
    if (widget.state.isSearching) _scheduleFocus();
  }

  @override
  void didUpdateWidget(MiniAppsCatalog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.query != widget.state.query &&
        widget.state.query != _requestedQuery &&
        _searchController.text.trim() != widget.state.query) {
      _queryDelay?.cancel();
      _requestedQuery = widget.state.query;
      _searchController.value = TextEditingValue(
        text: widget.state.query,
        selection: TextSelection.collapsed(offset: widget.state.query.length),
      );
    }
    if (oldWidget.state.isSearching != widget.state.isSearching) {
      if (widget.state.isSearching) {
        _scheduleFocus();
      } else {
        _queryDelay?.cancel();
        _focusDelay?.cancel();
        _searchFocus.unfocus();
        _searchController.clear();
      }
    }
  }

  void _scheduleFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.state.isSearching) return;
      _focusDelay?.cancel();
      _focusDelay = Timer(NinjaMotion.of(context, NinjaMotion.fast), () {
        if (mounted && widget.state.isSearching) _searchFocus.requestFocus();
      });
    });
  }

  void _queryChanged(String value) {
    _queryDelay?.cancel();
    if (value.trim().isEmpty) {
      _dispatchQuery('');
      return;
    }
    _queryDelay = Timer(const Duration(milliseconds: 250), () {
      if (mounted && widget.state.isSearching) _dispatchQuery(value);
    });
  }

  void _submitQuery(String value) {
    _queryDelay?.cancel();
    _dispatchQuery(value);
  }

  void _dispatchQuery(String value) {
    _requestedQuery = value.trim();
    widget.onQueryChanged(value);
  }

  void _toggleSearch() {
    _queryDelay?.cancel();
    _focusDelay?.cancel();
    if (widget.state.isSearching) {
      _searchFocus.unfocus();
      _searchController.clear();
    }
    widget.onSearchToggled();
  }

  void _resetFilters() {
    _queryDelay?.cancel();
    _searchController.clear();
    _requestedQuery = '';
    widget.onResetFilters();
  }

  @override
  void dispose() {
    _queryDelay?.cancel();
    _focusDelay?.cancel();
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = widget.state;
    return PopScope(
      canPop: !state.isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && state.isSearching) _toggleSearch();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            if (widget.state.isSearching) _toggleSearch();
          },
        },
        child: Scaffold(
          backgroundColor: colors.canvas,
          body: AppAmbientBackground(
            child: SafeArea(
              top: false,
              bottom: false,
              child: RefreshIndicator(
                color: colors.accent,
                backgroundColor: colors.surface,
                onRefresh: widget.onRefresh,
                child: AppGlassBatch(
                  child: CustomScrollView(
                    key: const PageStorageKey('mini-apps-catalog'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverToBoxAdapter(
                        child: _MiniAppsAppBar(
                          count: state.apps.length,
                          subtitle: state.hasFilters
                              ? context.l10n.miniAppsSearchResultsCount(
                                  state.resultCount,
                                )
                              : null,
                          isSearching: state.isSearching,
                          onSearchToggled: _toggleSearch,
                          onBack: widget.onBack,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _CatalogToolbar(
                          state: state,
                          onSortChanged: widget.onSortChanged,
                          onCreate: widget.onCreate,
                          onModerate: widget.onModerate,
                        ),
                      ),
                      AppGlassBatch.exclude(
                        child: _CatalogFilters(
                          state: state,
                          controller: _searchController,
                          focusNode: _searchFocus,
                          onQueryChanged: _queryChanged,
                          onQuerySubmitted: _submitQuery,
                          onCategoryChanged: widget.onCategoryChanged,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _CatalogFeedback(
                          state: state,
                          onRetry: () => unawaited(widget.onRefresh()),
                        ),
                      ),
                      _CatalogBody(
                        state: state,
                        onOpen: widget.onOpen,
                        onActions: widget.onActions,
                        onCreate: widget.onCreate,
                        onResetFilters: _resetFilters,
                        onRetry: () => unawaited(widget.onRefresh()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

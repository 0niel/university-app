import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_action.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/config/marketplace_category.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_grid.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_grid_skeleton.dart';

class MarketplaceBody extends StatefulWidget {
  const MarketplaceBody({
    required this.onOpen,
    required this.onSell,
    super.key,
    this.onContact,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final ValueChanged<MarketListing> onOpen;
  final VoidCallback? onSell;
  final ValueChanged<MarketListing>? onContact;
  final Set<String> favoriteIds;
  final ValueChanged<String>? onToggleFavorite;

  @override
  State<MarketplaceBody> createState() => _MarketplaceBodyState();
}

class _MarketplaceBodyState extends State<MarketplaceBody> {
  final _searchController = TextEditingController();
  var _query = '';
  var _freeOnly = false;
  var _sortKey = 'new';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _showFilters() async {
    var freeOnly = _freeOnly;
    var sortKey = _sortKey;
    final l10n = context.l10n;
    final result = await showAppSheet<(bool, String)>(
      context,
      title: l10n.filtersTitle,
      child: StatefulBuilder(
        builder: (context, updateSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            AppSwitch(
              value: freeOnly,
              label: l10n.marketFree,
              onChanged: (value) => updateSheet(() => freeOnly = value),
            ),
            AppRadio<String>(
              value: 'new',
              groupValue: sortKey,
              label: l10n.marketSortNew,
              onChanged: (value) => updateSheet(() => sortKey = value),
            ),
            AppRadio<String>(
              value: 'cheap',
              groupValue: sortKey,
              label: l10n.marketSortCheap,
              onChanged: (value) => updateSheet(() => sortKey = value),
            ),
            AppButton.primary(
              label: l10n.apply,
              expanded: true,
              onPressed: () => Navigator.of(context).pop((freeOnly, sortKey)),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _freeOnly = result.$1;
      _sortKey = result.$2;
    });
  }

  List<MarketListing> _sorted(List<MarketListing> items) {
    final unsold = items.where((item) => !item.isSold).toList();
    final sold = items.where((item) => item.isSold).toList();
    if (_sortKey == 'cheap') {
      unsold.sort((a, b) => a.price.compareTo(b.price));
      sold.sort((a, b) => a.price.compareTo(b.price));
    }
    return [...unsold, ...sold];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<MarketplaceCubit>().state;
    return RefreshIndicator(
      color: context.colors.accent,
      backgroundColor: context.colors.surface,
      onRefresh: context.read<MarketplaceCubit>().load,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInnerHeader(
                  title: l10n.marketTitle,
                  onBack: () => Navigator.of(context).maybePop(),
                  backSemanticsLabel: l10n.back,
                  actions: [
                    accentHeaderAction(
                      semanticsLabel: l10n.marketSell,
                      onTap: widget.onSell,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.screen),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Expanded(
                        child: AppSearchField(
                          controller: _searchController,
                          hintText: l10n.searchPlaceholder,
                          onChanged: (value) =>
                              setState(() => _query = value.trim()),
                          onClear: _clearSearch,
                        ),
                      ),
                      AppIconButton(
                        icon: const AppLineIconWidget(AppLineIcon.filter),
                        tooltip: l10n.filtersTitle,
                        dot: _freeOnly || _sortKey != 'new',
                        onPressed: () => unawaited(_showFilters()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                AppChipRow<String>(
                  value: state.filterKey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  onChanged: (value) =>
                      context.read<MarketplaceCubit>().filterChanged(value),
                  items: [
                    for (final key in [
                      'all',
                      ...UniversityConfig.current.marketplaceCategoryKeys,
                    ])
                      AppChipRowItem(
                        value: key,
                        label: MarketplaceCategories.label(l10n, key),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionGap),
              ],
            ),
          ),
          if (state.status == .loading && state.items.isEmpty)
            const SliverToBoxAdapter(
              child: MarketplaceGridSkeleton(key: ValueKey('market-loading')),
            )
          else
            _result(context, state),
        ],
      ),
    );
  }

  Widget _result(BuildContext context, MarketplaceState state) {
    final l10n = context.l10n;
    if (state.status == .failure && state.items.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        sliver: SliverList.list(
          children: [
            AppErrorState(
              title: l10n.marketLoadError,
              message: l10n.marketLoadErrorSubtitle,
              primaryLabel: l10n.retry,
              onPrimary: () =>
                  unawaited(context.read<MarketplaceCubit>().load()),
            ).animateEmptyState(),
          ],
        ),
      );
    }
    final normalizedQuery = _query.toLowerCase();
    final items = _sorted([
      for (final item in state.filteredItems)
        if ((!_freeOnly || item.isFree) &&
            (normalizedQuery.isEmpty ||
                item.title.toLowerCase().contains(normalizedQuery) ||
                item.description.toLowerCase().contains(normalizedQuery) ||
                item.sellerName.toLowerCase().contains(normalizedQuery)))
          item,
    ]);
    if (items.isEmpty) {
      final searching = normalizedQuery.isNotEmpty;
      final filtered = state.filterKey != 'all' || _freeOnly;
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xxl,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        sliver: SliverList.list(
          children: [
            if (searching)
              AppEmptyState(
                lineIcon: AppLineIcon.search,
                title: l10n.searchNoResults,
                subtitle: l10n.searchNoResultsHint,
                actionLabel: l10n.clear,
                onAction: _clearSearch,
              ).animateEmptyState()
            else if (filtered)
              AppEmptyState(
                lineIcon: AppLineIcon.filter,
                title: l10n.searchNoResults,
                subtitle: l10n.searchNoResultsHint,
                actionLabel: l10n.resetFilter,
                onAction: () {
                  setState(() => _freeOnly = false);
                  context.read<MarketplaceCubit>().filterChanged('all');
                },
              ).animateEmptyState()
            else
              AppEmptyState(
                lineIcon: AppLineIcon.tag,
                title: l10n.marketEmptyTitle,
                subtitle: l10n.marketEmptySub,
                actionLabel: l10n.marketSell,
                onAction: widget.onSell,
              ).animateEmptyState(),
          ],
        ),
      );
    }
    return MarketplaceGrid(
      sliver: true,
      items: items,
      pendingIds: {...state.pendingSoldIds, ...state.pendingDeleteIds},
      onOpen: widget.onOpen,
      onContact: widget.onContact,
      favoriteIds: widget.favoriteIds,
      onToggleFavorite: widget.onToggleFavorite,
    );
  }
}

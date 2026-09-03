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
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: AppSearchField(
            controller: _searchController,
            hintText: l10n.searchPlaceholder,
            onChanged: (value) => setState(() => _query = value.trim()),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppChipRow<String>(
          value: state.filterKey,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Wrap(
            spacing: AppSpacing.gap,
            runSpacing: AppSpacing.gap,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppFilterChip(
                label: l10n.marketFree,
                isSelected: _freeOnly,
                onTap: () => setState(() => _freeOnly = !_freeOnly),
              ),
              AppSegmentedControl<String>(
                value: _sortKey,
                expanded: false,
                onChanged: (value) => setState(() => _sortKey = value),
                options: [
                  AppSegmentedOption(value: 'new', label: l10n.marketSortNew),
                  AppSegmentedOption(
                    value: 'cheap',
                    label: l10n.marketSortCheap,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: _content(context, state),
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, MarketplaceState state) {
    if (state.status == .loading && state.items.isEmpty) {
      return const MarketplaceGridSkeleton(key: ValueKey('market-loading'));
    }
    return RefreshIndicator(
      key: const ValueKey('market-content'),
      color: context.colors.accent,
      backgroundColor: context.colors.surface,
      onRefresh: context.read<MarketplaceCubit>().load,
      child: _result(context, state),
    );
  }

  Widget _result(BuildContext context, MarketplaceState state) {
    final l10n = context.l10n;
    if (state.status == .failure && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        children: [
          AppErrorState(
            title: l10n.marketLoadError,
            message: l10n.marketLoadErrorSubtitle,
            primaryLabel: l10n.retry,
            onPrimary: () => unawaited(context.read<MarketplaceCubit>().load()),
          ).animateEmptyState(),
        ],
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
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xxl,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
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
      );
    }
    return MarketplaceGrid(
      items: items,
      pendingIds: {...state.pendingSoldIds, ...state.pendingDeleteIds},
      onOpen: widget.onOpen,
      onContact: widget.onContact,
      favoriteIds: widget.favoriteIds,
      onToggleFavorite: widget.onToggleFavorite,
    );
  }
}

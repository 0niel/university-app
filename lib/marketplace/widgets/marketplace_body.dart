import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/config/marketplace_category.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_grid.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_grid_skeleton.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_hero.dart';

part 'marketplace_header.dart';

class MarketplaceBody extends StatefulWidget {
  const MarketplaceBody({
    required this.onOpen,
    required this.onToggleSold,
    required this.onDelete,
    required this.onSell,
    super.key,
  });

  final ValueChanged<MarketListing> onOpen;
  final ValueChanged<MarketListing> onToggleSold;
  final ValueChanged<MarketListing> onDelete;
  final VoidCallback? onSell;

  @override
  State<MarketplaceBody> createState() => _MarketplaceBodyState();
}

class _MarketplaceBodyState extends State<MarketplaceBody> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketplaceCubit>().state;
    final isColdLoad = state.status == .loading && state.items.isEmpty;
    final isColdFailure = state.status == .failure && state.items.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            14,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: _MarketplaceHeader(busy: state.status == .loading),
        ),
        if (!isColdFailure)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              16,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: MarketplaceHero(
              count: state.items.length,
              loading: isColdLoad,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            16,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: NinjaInput(
            controller: _searchController,
            placeholder: context.l10n.searchPlaceholder,
            leadingIcon: const AppLineIconWidget(AppLineIcon.search),
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value.trim()),
          ),
        ),
        const SizedBox(height: 12),
        NinjaChipRow(
          children: [
            for (final key in [
              'all',
              ...UniversityConfig.current.marketplaceCategoryKeys,
            ])
              NinjaChip(
                label: MarketplaceCategories.label(context.l10n, key),
                selected: state.filterKey == key,
                onTap: () =>
                    context.read<MarketplaceCubit>().filterChanged(key),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: NinjaStateSwitcher(child: _content(context, state)),
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
      color: context.ninja.brand,
      backgroundColor: context.ninja.surface,
      onRefresh: context.read<MarketplaceCubit>().load,
      child: _result(context, state),
    );
  }

  Widget _result(BuildContext context, MarketplaceState state) {
    if (state.status == .failure && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: NinjaMetrics.screenPadding,
        ),
        children: [
          NinjaErrorState(
            title: context.l10n.marketLoadError,
            message: context.l10n.marketLoadErrorSubtitle,
            retryLabel: context.l10n.retry,
            onRetry: () => unawaited(context.read<MarketplaceCubit>().load()),
          ).animateEmptyState(),
        ],
      );
    }
    final normalizedQuery = _query.toLowerCase();
    final items = [
      for (final item in state.filteredItems)
        if (normalizedQuery.isEmpty ||
            item.title.toLowerCase().contains(normalizedQuery) ||
            item.description.toLowerCase().contains(normalizedQuery) ||
            item.sellerName.toLowerCase().contains(normalizedQuery))
          item,
    ];
    if (items.isEmpty) {
      final searching = normalizedQuery.isNotEmpty;
      final filtered = state.filterKey != 'all';
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          32,
          NinjaMetrics.screenPadding,
          24,
        ),
        children: [
          if (searching)
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.search),
              title: context.l10n.searchNoResults,
              message: context.l10n.searchNoResultsHint,
              actionLabel: context.l10n.clear,
              onAction: _clearSearch,
              outlinedAction: true,
            ).animateEmptyState()
          else if (filtered)
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.filter),
              title: context.l10n.searchNoResults,
              message: context.l10n.searchNoResultsHint,
              actionLabel: context.l10n.resetFilter,
              onAction: () =>
                  context.read<MarketplaceCubit>().filterChanged('all'),
              outlinedAction: true,
            ).animateEmptyState()
          else
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.tag),
              title: context.l10n.marketEmptyTitle,
              message: context.l10n.marketEmptySub,
              actionLabel: context.l10n.marketSell,
              onAction: widget.onSell,
            ).animateEmptyState(),
        ],
      );
    }
    return MarketplaceGrid(
      items: items,
      pendingIds: {...state.pendingSoldIds, ...state.pendingDeleteIds},
      onOpen: widget.onOpen,
      onToggleSold: widget.onToggleSold,
      onDelete: widget.onDelete,
    );
  }
}

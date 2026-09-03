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
    required this.onToggleSold,
    required this.onDelete,
    required this.onSell,
    super.key,
    this.onContact,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final ValueChanged<MarketListing> onOpen;
  final ValueChanged<MarketListing> onToggleSold;
  final ValueChanged<MarketListing> onDelete;
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _search() => showAppSheet<void>(
    context,
    title: context.l10n.search,
    child: AppSearchBar(
      controller: _searchController,
      hintText: context.l10n.searchPlaceholder,
      autofocus: true,
      onChanged: (value) => setState(() => _query = value.trim()),
      onSubmitted: (_) => Navigator.of(context, rootNavigator: true).pop(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketplaceCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInnerHeader(
          title: context.l10n.marketTitle,
          onBack: () => Navigator.of(context).maybePop(),
          backSemanticsLabel: context.l10n.back,
          actions: [
            accentHeaderAction(
              semanticsLabel: context.l10n.marketSell,
              onTap: widget.onSell,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.screen),
        AppChipRow<String>(
          value: state.filterKey,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          onChanged: (value) => value == '__search'
              ? unawaited(_search())
              : context.read<MarketplaceCubit>().filterChanged(value),
          items: [
            for (final key in [
              'all',
              ...UniversityConfig.current.marketplaceCategoryKeys,
            ])
              AppChipRowItem(
                value: key,
                label: MarketplaceCategories.label(context.l10n, key),
              ),
            AppChipRowItem(
              value: '__search',
              label: context.l10n.search,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
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
      color: context.colors.accent,
      backgroundColor: context.colors.surface,
      onRefresh: context.read<MarketplaceCubit>().load,
      child: _result(context, state),
    );
  }

  Widget _result(BuildContext context, MarketplaceState state) {
    if (state.status == .failure && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
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
          AppSpacing.screen,
          AppSpacing.xxl,
          AppSpacing.screen,
          AppSpacing.xlg,
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
      onContact: widget.onContact,
      favoriteIds: widget.favoriteIds,
      onToggleFavorite: widget.onToggleFavorite,
    );
  }
}

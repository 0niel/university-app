import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_listing_card.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_layout.dart';

class MarketplaceGrid extends StatelessWidget {
  const MarketplaceGrid({
    required this.items,
    required this.pendingIds,
    required this.onOpen,
    super.key,
    this.onContact,
    this.sliver = false,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final bool sliver;
  final List<MarketListing> items;
  final Set<String> pendingIds;
  final ValueChanged<MarketListing> onOpen;
  final ValueChanged<MarketListing>? onContact;
  final Set<String> favoriteIds;
  final ValueChanged<String>? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final columns = MarketplaceLayout.columns(
      MediaQuery.sizeOf(context).width,
      scale,
    );
    final grid = SliverGrid.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.cardGap,
        mainAxisSpacing: AppSpacing.cardGap,
        mainAxisExtent: MarketplaceLayout.cardExtent(scale),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return MarketListingCard(
          item: item,
          now: DateTime.now(),
          isBusy: pendingIds.contains(item.id),
          onOpen: () => onOpen(item),
          onContact: () => (onContact ?? onOpen)(item),
          isFavorite: favoriteIds.contains(item.id),
          onToggleFavorite: onToggleFavorite == null
              ? null
              : () => onToggleFavorite!(item.id),
        ).animateListItem(index: index);
      },
    );
    final padded = SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.zero,
        AppSpacing.screen,
        ninjaBottomInset(context) + AppSpacing.lg,
      ),
      sliver: grid,
    );
    return sliver
        ? padded
        : CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [padded],
          );
  }
}

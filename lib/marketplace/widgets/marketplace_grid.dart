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
    required this.onToggleSold,
    required this.onDelete,
    super.key,
    this.onContact,
    this.favoriteIds = const {},
    this.onToggleFavorite,
  });

  final List<MarketListing> items;
  final Set<String> pendingIds;
  final ValueChanged<MarketListing> onOpen;
  final ValueChanged<MarketListing> onToggleSold;
  final ValueChanged<MarketListing> onDelete;
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
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.zero,
        AppSpacing.screen,
        AppSpacing.xxlg,
      ),
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
          onToggleSold: () => onToggleSold(item),
          onDelete: () => onDelete(item),
          onContact: () => (onContact ?? onOpen)(item),
          isFavorite: favoriteIds.contains(item.id),
          onToggleFavorite: onToggleFavorite == null
              ? null
              : () => onToggleFavorite!(item.id),
        ).animateListItem(index: index);
      },
    );
  }
}

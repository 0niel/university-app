import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_listing_card.dart';

class MarketplaceGrid extends StatelessWidget {
  const MarketplaceGrid({
    required this.items,
    required this.pendingIds,
    required this.onOpen,
    required this.onToggleSold,
    required this.onDelete,
    super.key,
  });

  final List<MarketListing> items;
  final Set<String> pendingIds;
  final ValueChanged<MarketListing> onOpen;
  final ValueChanged<MarketListing> onToggleSold;
  final ValueChanged<MarketListing> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        100,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return MarketListingCard(
          item: item,
          now: DateTime.now(),
          isBusy: pendingIds.contains(item.id),
          onOpen: () => onOpen(item),
          onToggleSold: () => onToggleSold(item),
          onDelete: () => onDelete(item),
        ).animateListItem(index: index);
      },
    );
  }
}

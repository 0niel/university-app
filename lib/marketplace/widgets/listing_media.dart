part of 'market_listing_card.dart';

class _ListingMedia extends StatelessWidget {
  const _ListingMedia({
    required this.item,
    required this.isBusy,
    required this.onOwnerActions,
  });

  final MarketListing item;
  final bool isBusy;
  final VoidCallback onOwnerActions;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ColoredBox(
        color: context.colors.surface2,
        child: Stack(
          children: [
            const Positioned.fill(child: AppStripePlaceholder()),
            if (item.isSold)
              PositionedDirectional(
                start: 8,
                top: 8,
                child: NinjaBadge(
                  context.l10n.marketSold,
                  tone: NinjaBadgeTone.ink,
                ),
              ),
            if (item.isMine)
              PositionedDirectional(
                start: 2,
                top: 6,
                child: Opacity(
                  opacity: isBusy ? 0.4 : 1,
                  child: NinjaIconButton(
                    tooltip: context.l10n.more,
                    icon: const AppLineIconWidget(AppLineIcon.more),
                    onPressed: isBusy ? null : onOwnerActions,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

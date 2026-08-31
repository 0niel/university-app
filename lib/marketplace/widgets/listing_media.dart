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
    final colors = context.ninja;
    return ClipRRect(
      borderRadius: BorderRadius.circular(NinjaRadius.control),
      child: ColoredBox(
        color: colors.surfaceAlt,
        child: Stack(
          children: [
            Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 36)),
            ),
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
                end: 6,
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

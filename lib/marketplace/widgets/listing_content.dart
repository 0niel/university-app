part of 'market_listing_card.dart';

class _ListingContent extends StatelessWidget {
  const _ListingContent({required this.item, required this.sellerMeta});

  final MarketListing item;
  final String sellerMeta;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          marketplacePrice(
            context.l10n,
            item.price,
            UniversityConfig.current.marketplaceCurrencyCode,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.tabular(
            NinjaText.title.copyWith(
              color: item.isFree ? colors.brandInk : colors.ink,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 10),
        Text(
          sellerMeta,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.subtext.copyWith(color: colors.muted, height: 1.35),
        ),
      ],
    );
  }
}

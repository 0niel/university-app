part of 'market_listing_card.dart';

class _ListingContent extends StatelessWidget {
  const _ListingContent({required this.item, required this.sellerMeta});

  final MarketListing item;
  final String sellerMeta;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
          style: AppText.tabular(
            AppText.sans(15, FontWeight.w800).copyWith(
              color: item.isFree ? colors.accent : colors.ink,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppText.label.copyWith(color: colors.ink, height: 1.3),
        ),
        const Spacer(),
        Text(
          sellerMeta,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppText.sans(11.5, FontWeight.w400).copyWith(
            color: colors.muted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

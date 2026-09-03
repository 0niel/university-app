part of 'market_listing_card.dart';

class _ListingMedia extends StatelessWidget {
  const _ListingMedia({required this.item});

  final MarketListing item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cover = item.cover;
    return ClipRect(
      child: ColoredBox(
        color: colors.surface2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (cover == null || cover.isVideo)
              const Positioned.fill(child: AppStripePlaceholder())
            else
              CachedNetworkImage(
                imageUrl: cover.url,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                placeholder: (context, url) => const AppStripePlaceholder(),
                errorWidget: (context, url, error) =>
                    const AppStripePlaceholder(),
              ),
            if (cover != null && cover.isVideo)
              Center(
                child: AppLineIconWidget(
                  AppLineIcon.video,
                  color: colors.ink,
                  size: AppIconSize.md,
                ),
              ),
            if (item.isSold)
              PositionedDirectional(
                start: 8,
                top: 8,
                child: AppBadge(
                  label: context.l10n.marketSold,
                  tone: .ink,
                ),
              ),
            if (cover != null && cover.isVideo && cover.duration > 0)
              PositionedDirectional(
                bottom: 6,
                end: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.ink.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 1,
                    ),
                    child: Text(
                      _duration(cover.duration),
                      style: AppText.sans(10, FontWeight.w700).copyWith(
                        color: colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _duration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }
}

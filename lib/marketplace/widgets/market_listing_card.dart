import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_layout.dart';

part 'listing_content.dart';
part 'listing_media.dart';

class MarketListingCard extends StatelessWidget {
  const MarketListingCard({
    required this.item,
    required this.now,
    required this.onOpen,
    super.key,
    this.isBusy = false,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.onContact,
  });

  final MarketListing item;
  final DateTime now;
  final VoidCallback onOpen;
  final bool isBusy;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final seller = item.sellerName.isEmpty
        ? l10n.marketSellerFallback
        : item.sellerName;
    final meta = [
      seller,
      if (item.createdAt case final createdAt?)
        relativeTime(l10n, createdAt, now: now),
    ].join(' · ');
    return Opacity(
      opacity: item.isSold ? .62 : 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: ColoredBox(
          color: colors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MarketplaceLayout.coverHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppPressable(
                      onTap: isBusy ? null : onOpen,
                      semanticsLabel: item.title,
                      child: _ListingMedia(item: item),
                    ),
                    if (onToggleFavorite != null)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: AppPressState(
                          onTap: isBusy ? null : onToggleFavorite,
                          semanticsLabel: isFavorite
                              ? l10n.marketFavoriteRemove
                              : l10n.marketFavoriteAdd,
                          semanticsButton: true,
                          semanticsToggled: isFavorite,
                          builder: (context, {required pressed}) =>
                              SizedBox.square(
                                dimension: 44,
                                child: Center(
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isFavorite
                                          ? colors.accent
                                          : colors.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: AppLineIconWidget(
                                      AppLineIcon.heart,
                                      size: 15,
                                      strokeWidth: 2.2,
                                      color: isFavorite
                                          ? colors.onAccent
                                          : colors.ink,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    if (isBusy)
                      Positioned.fill(
                        child: ColoredBox(
                          color: colors.canvas.withValues(alpha: .55),
                          child: Center(
                            child: AppSpinner(color: colors.accent),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: AppPressable(
                          onTap: isBusy ? null : onOpen,
                          semanticsLabel: item.title,
                          child: _ListingContent(item: item, sellerMeta: meta),
                        ),
                      ),
                      AppPressState(
                        onTap: isBusy ? null : (onContact ?? onOpen),
                        semanticsLabel: l10n.marketWrite,
                        semanticsButton: true,
                        builder: (context, {required pressed}) => SizedBox(
                          height: 44,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: pressed
                                    ? colors.canvas
                                    : colors.surface2,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Text(
                                l10n.marketWrite,
                                style: AppText.sans(
                                  12.5,
                                  FontWeight.w700,
                                ).copyWith(color: colors.ink),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

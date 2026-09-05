import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/config/marketplace_category.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_owner_actions.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_layout.dart';

class MarketListingDetailsSheet extends StatefulWidget {
  const MarketListingDetailsSheet({
    required this.item,
    required this.onContact,
    required this.onShare,
    super.key,
    this.onEdit,
    this.onToggleSold,
    this.onArchive,
    this.onDelete,
  });

  final MarketListing item;
  final VoidCallback onContact;
  final VoidCallback onShare;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleSold;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  State<MarketListingDetailsSheet> createState() =>
      _MarketListingDetailsSheetState();
}

class _MarketListingDetailsSheetState extends State<MarketListingDetailsSheet> {
  final _pageController = PageController();
  var _page = 0;
  final _heroScope = Object();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<MediaItem> get _mediaItems => [
    for (final (index, media) in widget.item.media.indexed)
      MediaItem(
        url: media.url,
        kind: media.isVideo ? .video : .image,
        heroTag: media.isVideo ? null : (_heroScope, index),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final item = widget.item;
    final seller = item.sellerName.isEmpty
        ? l10n.marketSellerFallback
        : item.sellerName;
    final canContact =
        item.showContact && (item.telegramHandle?.isNotEmpty ?? false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MediaCarousel(
            media: item.media,
            heroScope: _heroScope,
            page: _page,
            controller: _pageController,
            onPageChanged: (value) => setState(() => _page = value),
            onOpen: (index) => showMediaViewer(
              context,
              items: _mediaItems,
              initialIndex: index,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  marketplacePrice(
                    l10n,
                    item.price,
                    UniversityConfig.current.marketplaceCurrencyCode,
                  ),
                  style: AppText.tabular(
                    AppText.title.copyWith(
                      color: item.isFree ? colors.accent : colors.ink,
                    ),
                  ),
                ),
              ),
              AppTag(label: MarketplaceCategories.label(l10n, item.category)),
              if (item.isSold) ...[
                const SizedBox(width: AppSpacing.sm),
                AppBadge(label: l10n.marketSold, tone: .ink),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            item.description.isEmpty
                ? l10n.marketDescriptionEmpty
                : item.description,
            style: AppText.body.copyWith(height: 1.5, color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
                AppAvatar(name: seller, size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    seller,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                ),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.share),
                  tooltip: l10n.marketShare,
                  onPressed: widget.onShare,
                ),
              ],
            ),
          ),
          if (!item.isMine) ...[
            const SizedBox(height: AppSpacing.fieldGap),
            AppButton.primary(
              label: canContact
                  ? l10n.marketContactSeller
                  : l10n.marketContactUnavailable,
              icon: const AppLineIconWidget(AppLineIcon.send),
              size: .large,
              expanded: true,
              onPressed: canContact ? widget.onContact : null,
            ),
          ] else
            MarketOwnerActions(
              isSold: item.isSold,
              onToggleSold: widget.onToggleSold,
              onEdit: widget.onEdit,
              onArchive: widget.onArchive,
              onDelete: widget.onDelete,
            ),
        ],
      ),
    );
  }
}

class _MediaCarousel extends StatelessWidget {
  const _MediaCarousel({
    required this.media,
    required this.heroScope,
    required this.page,
    required this.controller,
    required this.onPageChanged,
    required this.onOpen,
  });

  final List<MarketMediaItem> media;
  final Object heroScope;
  final int page;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(
        height: MarketplaceLayout.detailsCoverHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (media.isEmpty)
              const Positioned.fill(child: AppStripePlaceholder())
            else
              PageView.builder(
                controller: controller,
                onPageChanged: onPageChanged,
                itemCount: media.length,
                itemBuilder: (context, index) {
                  final item = media[index];
                  return AppPressable(
                    onTap: () => onOpen(index),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (item.isVideo)
                          const AppStripePlaceholder()
                        else
                          Hero(
                            tag: (heroScope, index),
                            child: CachedNetworkImage(
                              imageUrl: item.url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const AppStripePlaceholder(),
                              errorWidget: (context, url, error) =>
                                  const AppStripePlaceholder(),
                            ),
                          ),
                        if (item.isVideo)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.ink.withValues(alpha: .28),
                            ),
                            child: Center(
                              child: AppLineIconWidget(
                                AppLineIcon.video,
                                color: colors.white,
                                size: AppIconSize.lg,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            if (media.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (index, _) in media.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: index == page
                                ? colors.white
                                : colors.white.withValues(alpha: .5),
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox.square(dimension: 6),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

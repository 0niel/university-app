import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/models/models.dart';

class MarketMediaThumbnail extends StatelessWidget {
  const MarketMediaThumbnail({
    required this.item,
    required this.isCover,
    required this.onRemove,
    super.key,
  });

  final MarketMediaDraftItem item;
  final bool isCover;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return SizedBox(
      width: 76,
      height: 76,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _MediaPreview(item: item),
            if (item.isVideo)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.ink.withValues(alpha: .32),
                ),
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.video,
                    color: colors.white,
                    size: AppIconSize.md,
                  ),
                ),
              ),
            if (item.isVideo && item.duration > 0)
              PositionedDirectional(
                bottom: 4,
                end: 4,
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
                      _duration(item.duration),
                      style: AppText.sans(10, FontWeight.w700).copyWith(
                        color: colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            if (isCover)
              PositionedDirectional(
                start: 4,
                top: 4,
                child: AppTag(
                  label: l10n.marketCoverBadge,
                  tone: AppTagTone.solid,
                ),
              ),
            if (item.uploading)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.ink.withValues(alpha: .45),
                ),
                child: Center(
                  child: AppSpinner(color: colors.white),
                ),
              ),
            if (item.failed)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.danger.withValues(alpha: .55),
                ),
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.alert,
                    color: colors.white,
                    size: AppIconSize.md,
                  ),
                ),
              ),
            PositionedDirectional(
              end: 2,
              top: 2,
              child: AppPressState(
                onTap: onRemove,
                pressedScale: 0.9,
                semanticsLabel: l10n.marketRemoveMediaItem,
                semanticsButton: true,
                builder: (context, {required pressed}) => Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.ink.withValues(alpha: .55),
                    shape: BoxShape.circle,
                  ),
                  child: AppLineIconWidget(
                    AppLineIcon.close,
                    size: AppIconSize.xs,
                    strokeWidth: 2.4,
                    color: colors.white,
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

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({required this.item});

  final MarketMediaDraftItem item;

  @override
  Widget build(BuildContext context) {
    final bytes = item.bytes;
    if (bytes != null) return Image.memory(bytes, fit: BoxFit.cover);
    final url = item.previewUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => const AppStripePlaceholder(),
        errorWidget: (context, url, error) => const AppStripePlaceholder(),
      );
    }
    return const AppStripePlaceholder();
  }
}

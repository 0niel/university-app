import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class MaterialThumbnail extends StatelessWidget {
  const MaterialThumbnail({
    required this.previewUrl,
    required this.mimeType,
    this.iconSize = 20,
    this.borderRadius,
    this.accent,
    this.heroTag,
    super.key,
  });

  final String? previewUrl;
  final String mimeType;
  final double iconSize;
  final BorderRadius? borderRadius;
  final Color? accent;
  final Object? heroTag;

  AppLineIcon get _icon {
    if (mimeType.startsWith('image/')) return AppLineIcon.image;
    if (mimeType.startsWith('video/')) return AppLineIcon.video;
    if (mimeType == 'application/pdf') return AppLineIcon.book;
    return AppLineIcon.clipboard;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = accent ?? colors.lecture;
    final url = previewUrl;
    final thumbnail = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.iconTile),
      child: SizedBox.expand(
        child: url == null || url.isEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(color: colors.tintOf(color)),
                child: Center(
                  child: AppLineIconWidget(
                    _icon,
                    size: iconSize,
                    color: color,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => DecoratedBox(
                  decoration: BoxDecoration(color: colors.surface2),
                ),
                errorWidget: (context, url, error) => DecoratedBox(
                  decoration: BoxDecoration(color: colors.tintOf(color)),
                  child: Center(
                    child: AppLineIconWidget(
                      _icon,
                      size: iconSize,
                      color: color,
                    ),
                  ),
                ),
              ),
      ),
    );
    final tag = heroTag;
    return tag == null ? thumbnail : Hero(tag: tag, child: thumbnail);
  }
}

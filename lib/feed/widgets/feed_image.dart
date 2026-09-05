import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FeedImage extends StatefulWidget {
  const FeedImage({
    required this.radius,
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.gallery = const [],
    this.previewImageUrl,
    this.enablePreview = true,
  });

  final String? imageUrl;
  final double radius;
  final double? width;
  final double? height;
  final List<String> gallery;
  final String? previewImageUrl;
  final bool enablePreview;

  @override
  State<FeedImage> createState() => _FeedImageState();
}

class _FeedImageState extends State<FeedImage> {
  final _heroTag = Object();

  @override
  Widget build(BuildContext context) {
    final url = widget.imageUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    final available =
        uri != null &&
        {'http', 'https'}.contains(uri.scheme) &&
        uri.host.isNotEmpty;
    final borderRadius = BorderRadius.circular(widget.radius);
    final placeholder = AppStripePlaceholder(borderRadius: borderRadius);
    final image = SizedBox(
      width: widget.width,
      height: widget.height,
      child: !available
          ? placeholder
          : ClipRRect(
              borderRadius: borderRadius,
              child: CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
            ),
    );
    if (!available || !widget.enablePreview) return image;
    return AppPressable(
      semanticsLabel: context.l10n.imageViewer,
      onTap: () {
        final target = widget.previewImageUrl ?? url!;
        final urls = widget.gallery.contains(target)
            ? widget.gallery.toSet().toList(growable: false)
            : [target];
        unawaited(
          showMediaViewer(
            context,
            items: [
              for (final item in urls)
                MediaItem(
                  url: item,
                  kind: MediaKind.image,
                  heroTag: item == target ? _heroTag : null,
                ),
            ],
            initialIndex: urls.indexOf(target),
          ),
        );
      },
      child: Hero(tag: _heroTag, child: image),
    );
  }
}

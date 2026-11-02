import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ratio = MediaQuery.devicePixelRatioOf(context);
                  final cacheWidth =
                      constraints.hasBoundedWidth && constraints.maxWidth > 0
                      ? (constraints.maxWidth * ratio).ceil()
                      : null;
                  final cacheHeight =
                      constraints.hasBoundedHeight && constraints.maxHeight > 0
                      ? (constraints.maxHeight * ratio).ceil()
                      : null;
                  final provider = CachedNetworkImageProvider(url!);
                  return Image(
                    image: cacheWidth != null || cacheHeight != null
                        ? FeedCoverImageProvider(
                            source: provider,
                            width: cacheWidth,
                            height: cacheHeight,
                          )
                        : provider,
                    fit: BoxFit.cover,
                    frameBuilder: (_, child, frame, _) =>
                        frame == null ? placeholder : child,
                    errorBuilder: (_, _, _) => placeholder,
                  );
                },
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

@immutable
class FeedCoverImageProvider extends ImageProvider<FeedCoverImageProvider> {
  const FeedCoverImageProvider({
    required this.source,
    required this.width,
    required this.height,
  }) : assert(width == null || width > 0, 'Width must be positive.'),
       assert(height == null || height > 0, 'Height must be positive.'),
       assert(width != null || height != null, 'A target size is required.');

  final CachedNetworkImageProvider source;
  final int? width;
  final int? height;

  @override
  Future<FeedCoverImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    FeedCoverImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return source.loadImage(
      source,
      (buffer, {getTargetSize}) => decode(
        buffer,
        getTargetSize: (intrinsicWidth, intrinsicHeight) {
          final scale = math.min(
            1,
            math.max(
              width == null ? 0.0 : width! / intrinsicWidth,
              height == null ? 0.0 : height! / intrinsicHeight,
            ),
          );
          return ui.TargetImageSize(
            width: math.max(1, (intrinsicWidth * scale).ceil()),
            height: math.max(1, (intrinsicHeight * scale).ceil()),
          );
        },
      ),
    )..addEphemeralErrorListener((exception, stackTrace) {
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(key));
    });
  }

  @override
  bool operator ==(Object other) =>
      other is FeedCoverImageProvider &&
      source == other.source &&
      width == other.width &&
      height == other.height;

  @override
  int get hashCode => Object.hash(source, width, height);
}

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// {@template inline_image}
/// A reusable image widget displayed inline with the content.
/// {@endtemplate}
class InlineImage extends StatelessWidget {
  /// {@macro inline_image}
  const InlineImage({
    required this.imageUrl,
    this.semanticLabel,
    this.progressIndicatorBuilder,
    super.key,
  });

  /// The aspect ratio of this image.
  static const double _aspectRatio = 3 / 2;

  /// The url of this image.
  final String imageUrl;

  /// Text announced by assistive technologies for this image.
  final String? semanticLabel;

  /// Widget displayed while the target [imageUrl] is loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    // Guard against accidental empty URLs to avoid HTTP errors
    if (imageUrl.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            progressIndicatorBuilder: progressIndicatorBuilder,
            placeholder:
                progressIndicatorBuilder == null
                    ? (context, url) => ColoredBox(color: colors.surfaceHigh)
                    : null,
            errorWidget:
                (context, url, error) => ColoredBox(color: colors.surfaceLow),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 150),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

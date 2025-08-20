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
    this.progressIndicatorBuilder,
    super.key,
  });

  /// The aspect ratio of this image.
  static const _aspectRatio = 3 / 2;

  /// The url of this image.
  final String imageUrl;

  /// Widget displayed while the target [imageUrl] is loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // Guard against accidental empty URLs to avoid HTTP errors
    if (imageUrl.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          progressIndicatorBuilder: progressIndicatorBuilder,
          placeholder: (context, url) => ColoredBox(color: colors.surfaceHigh),
          errorWidget: (context, url, error) =>
              ColoredBox(color: colors.surfaceLow),
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 150),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

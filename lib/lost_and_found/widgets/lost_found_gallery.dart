import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundGallery extends StatelessWidget {
  const LostFoundGallery({required this.images, super.key});

  final List<String> images;

  void _open(BuildContext context, int index, Object heroScope) {
    unawaited(
      showMediaViewer(
        context,
        initialIndex: index,
        items: [
          for (final (imageIndex, url) in images.indexed)
            MediaItem(url: url, kind: .image, heroTag: (heroScope, imageIndex)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final heroScope = context;
    return SizedBox(
      height: 180,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: images.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (context, index) {
            final url = images[index];
            return SizedBox(
              width: constraints.maxWidth * 0.88,
              child: AppPressable(
                onTap: () => _open(context, index, heroScope),
                semanticsButton: true,
                semanticsLabel:
                    '${context.l10n.lostFoundPhotosLabel} ${index + 1} / ${images.length}',
                child: Hero(
                  tag: (heroScope, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: .cover,
                      fadeInDuration:
                          (MediaQuery.disableAnimationsOf(context) ||
                              MediaQuery.accessibleNavigationOf(context))
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      placeholder: (_, _) => ColoredBox(color: colors.surface2),
                      errorWidget: (_, _, _) => ColoredBox(
                        color: colors.surface2,
                        child: AppLineIconWidget(
                          AppLineIcon.imageOff,
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

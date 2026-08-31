import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_viewer.dart';

class LostFoundGallery extends StatelessWidget {
  const LostFoundGallery({required this.images, super.key});

  final List<String> images;

  void _open(BuildContext context, String url) {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder<void>(
          opaque: false,
          barrierColor: Colors.black.withValues(alpha: 0.9),
          pageBuilder: (_, _, _) => LostFoundPhotoViewer(url: url),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
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
                onTap: () => _open(context, url),
                semanticsButton: true,
                semanticsLabel:
                    '${context.l10n.lostFoundPhotosLabel} ${index + 1} / ${images.length}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(NinjaRadius.card),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: .cover,
                    fadeInDuration:
                        (MediaQuery.disableAnimationsOf(context) ||
                            MediaQuery.accessibleNavigationOf(context))
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    placeholder: (_, _) => ColoredBox(color: colors.surfaceAlt),
                    errorWidget: (_, _, _) => ColoredBox(
                      color: colors.surfaceAlt,
                      child: AppLineIconWidget(
                        AppLineIcon.imageOff,
                        color: colors.muted,
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

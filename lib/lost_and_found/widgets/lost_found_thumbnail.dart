import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';

class LostFoundThumbnail extends StatelessWidget {
  const LostFoundThumbnail({required this.item, super.key});

  final LostFoundItem item;

  @override
  Widget build(BuildContext context) {
    const placeholder = AppStripePlaceholder();
    final image = item.images.firstOrNull;
    if (image == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      fadeInDuration:
          (MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context))
          ? Duration.zero
          : const Duration(milliseconds: 180),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

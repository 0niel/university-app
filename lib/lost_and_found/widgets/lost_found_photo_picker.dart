import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_add_photo_button.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_thumbnail.dart';

class LostFoundPhotoPicker extends StatelessWidget {
  const LostFoundPhotoPicker({
    required this.images,
    required this.onAddFromGallery,
    required this.onAddFromCamera,
    required this.onRemove,
    super.key,
  });

  final List<LostFoundImageUpload> images;
  final VoidCallback onAddFromGallery;
  final VoidCallback onAddFromCamera;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.lostFoundPhotosLabel,
          style: AppText.captionSmall.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.gap),
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final (index, image) in images.indexed)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: LostFoundPhotoThumbnail(
                    image: image,
                    onRemove: () => onRemove(index),
                  ),
                ),
              if (images.length < 5) ...[
                LostFoundAddPhotoButton(
                  icon: AppLineIcon.image,
                  onPressed: onAddFromGallery,
                ),
                const SizedBox(width: AppSpacing.sm),
                LostFoundAddPhotoButton(
                  icon: AppLineIcon.camera,
                  onPressed: onAddFromCamera,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

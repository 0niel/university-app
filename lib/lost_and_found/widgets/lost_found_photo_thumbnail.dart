import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundPhotoThumbnail extends StatelessWidget {
  const LostFoundPhotoThumbnail({
    required this.image,
    required this.onRemove,
    super.key,
  });

  final LostFoundImageUpload image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return SizedBox.square(
      dimension: 72,
      child: Stack(
        children: [
          Semantics(
            image: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(NinjaRadius.control),
              child: Image.memory(
                image.bytes,
                width: 72,
                height: 72,
                cacheWidth: 200,
                fit: BoxFit.cover,
                semanticLabel: context.l10n.lostFoundPhotosLabel,
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: SizedBox.square(
              dimension: NinjaMetrics.minTouchTarget,
              child: AppPressable(
                pressedScale: 0.9,
                onTap: onRemove,
                semanticsLabel: context.l10n.delete,
                semanticsButton: true,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.xs),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: AppLineIconWidget(
                      AppLineIcon.close,
                      size: 14,
                      color: colors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

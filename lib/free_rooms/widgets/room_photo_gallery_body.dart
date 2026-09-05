import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class RoomPhotoGalleryBody extends StatelessWidget {
  const RoomPhotoGalleryBody({
    required this.status,
    required this.photos,
    required this.index,
    required this.pageController,
    required this.uploadDone,
    required this.uploadTotal,
    required this.onIndexChanged,
    required this.onRetry,
    required this.onOpenPhoto,
    this.onAddPhoto,
    this.heroScope,
    this.onDeletePhoto,
    super.key,
  });

  static const double height = 190;

  final RoomPhotoGalleryStatus status;
  final List<RoomPhoto> photos;
  final int index;
  final PageController pageController;
  final int uploadDone;
  final int uploadTotal;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onRetry;
  final ValueChanged<int> onOpenPhoto;
  final VoidCallback? onAddPhoto;
  final Object? heroScope;
  final ValueChanged<RoomPhoto>? onDeletePhoto;

  bool get _uploading => uploadTotal > 0;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      RoomPhotoGalleryStatus.loading => const RoomPhotoLoadingStripe(
        height: height,
      ),
      RoomPhotoGalleryStatus.offline => AppErrorState(
        title: context.l10n.offline,
        message: context.l10n.roomPhotosOfflineMessage,
        primaryLabel: context.l10n.retry,
        onPrimary: onRetry,
        footnote: null,
      ),
      RoomPhotoGalleryStatus.error => AppErrorState(
        lineIcon: AppLineIcon.imageOff,
        title: context.l10n.loadingError,
        message: context.l10n.tryAgain,
        primaryLabel: context.l10n.retry,
        onPrimary: onRetry,
        footnote: null,
      ),
      RoomPhotoGalleryStatus.loaded => _buildLoaded(context),
    };
  }

  Widget _buildLoaded(BuildContext context) {
    if (photos.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RoomPhotoPlaceholder(),
          const SizedBox(height: AppSpacing.gap),
          if (_uploading)
            RoomPhotoUploadProgress(done: uploadDone, total: uploadTotal)
          else
            AppButton.secondary(
              label: context.l10n.roomPhotoAdd,
              icon: const AppLineIconWidget(AppLineIcon.plus),
              expanded: true,
              onPressed: onAddPhoto,
            ),
        ],
      );
    }
    final current = photos[index.clamp(0, photos.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: photos.length,
                  onPageChanged: onIndexChanged,
                  itemBuilder: (context, photoIndex) {
                    final photo = photos[photoIndex];
                    final tile = RoomPhotoTile(
                      photo: photo,
                      onTap: () => onOpenPhoto(photoIndex),
                      onDelete: photo.isMine && onDeletePhoto != null
                          ? () => onDeletePhoto!(photo)
                          : null,
                    );
                    final heroTag = heroScope == null
                        ? null
                        : (heroScope, photoIndex, photo.id);
                    return heroTag == null
                        ? tile
                        : Hero(tag: heroTag, child: tile);
                  },
                ),
                if (photos.length > 1)
                  Positioned(
                    bottom: AppSpacing.sm,
                    left: 0,
                    right: 0,
                    child: RoomPhotoDots(count: photos.length, index: index),
                  ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: AppIconButton(
                    icon: const AppLineIconWidget(AppLineIcon.plus),
                    tooltip: context.l10n.roomPhotoAdd,
                    tone: AppIconButtonTone.surface,
                    shape: AppIconButtonShape.circle,
                    size: AppIconButtonSize.compact,
                    onPressed: onAddPhoto,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        RoomPhotoCaption(photo: current),
        if (_uploading) ...[
          const SizedBox(height: AppSpacing.gap),
          RoomPhotoUploadProgress(done: uploadDone, total: uploadTotal),
        ],
      ],
    );
  }
}

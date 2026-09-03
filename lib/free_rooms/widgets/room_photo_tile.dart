import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/utils/relative_time.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class RoomPhotoLoadingStripe extends StatelessWidget {
  const RoomPhotoLoadingStripe({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: AppStripePlaceholder(
      borderRadius: BorderRadius.circular(AppRadius.card),
    ),
  );
}

class RoomPhotoUploadProgress extends StatelessWidget {
  const RoomPhotoUploadProgress({
    required this.done,
    required this.total,
    super.key,
  });

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.loadingContent,
    liveRegion: true,
    child: AppProgressBar(value: total == 0 ? 0 : done / total),
  );
}

class RoomPhotoTile extends StatelessWidget {
  const RoomPhotoTile({
    required this.photo,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final RoomPhoto photo;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      onLongPress: onDelete,
      pressedScale: 1,
      semanticsButton: true,
      semanticsLabel: context.l10n.roomPhotoPlaceholder,
      child: CachedNetworkImage(
        imageUrl: photo.url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, _) => AppStripePlaceholder(
          base: colors.surface,
          stripe: colors.surface2,
        ),
        errorWidget: (_, _, _) => ColoredBox(
          color: colors.surface2,
          child: Center(
            child: AppLineIconWidget(
              AppLineIcon.imageOff,
              color: colors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class RoomPhotoDots extends StatelessWidget {
  const RoomPhotoDots({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: NinjaMotion.of(context),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index
                  ? colors.white
                  : colors.white.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
      ],
    );
  }
}

class RoomPhotoCaption extends StatelessWidget {
  const RoomPhotoCaption({required this.photo, super.key});

  final RoomPhoto photo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final author = photo.authorName.isEmpty ? l10n.unknown : photo.authorName;
    return Row(
      children: [
        AppAvatar(name: author, size: 22),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            l10n.roomPhotoCaption(
              author,
              roomPhotoRelativeTime(l10n, photo.createdAt),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.sans(
              12.5,
              FontWeight.w500,
            ).copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}

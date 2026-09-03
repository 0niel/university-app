part of '../schedule_details_page.dart';

class _DropZone extends StatelessWidget {
  const _DropZone({required this.onTap});

  final VoidCallback onTap;

  static const double _height = 148;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.lessonDetailsPickFileOrPhoto,
      child: AppDashedBorder(
        color: colors.line,
        radius: AppRadius.card,
        child: SizedBox(
          width: double.infinity,
          height: _height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIconTile(
                icon: AppLineIcon.clipboard,
                background: colors.tint,
                foreground: colors.accent,
              ),
              const SizedBox(height: AppSpacing.gap),
              Text(
                context.l10n.lessonDetailsPickFileOrPhoto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body.copyWith(color: colors.ink),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.lessonDetailsDropHint,
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropZoneSkeleton extends StatelessWidget {
  const _DropZoneSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppSkeletonGroup(
      child: AppSkeletonMedia(
        height: _DropZone._height,
        radius: AppRadius.card,
      ),
    );
  }
}

class _PickedPreview extends StatelessWidget {
  const _PickedPreview({required this.picked, required this.onRemove});

  final _PickedMaterial picked;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final picked = this.picked;
    final isImage = picked.mimeType?.startsWith('image/') ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.gap),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.field),
              child: Image.memory(
                picked.bytes,
                width: AppControlSize.iconTileMedium,
                height: AppControlSize.iconTileMedium,
                fit: BoxFit.cover,
              ),
            )
          else
            AppIconTile(
              size: AppControlSize.iconTileMedium,
              background: colors.tintOf(colors.lecture),
              child: Text(
                fileTypeBadge(picked.name, picked.mimeType),
                style: AppText.sans(
                  10,
                  FontWeight.w800,
                ).copyWith(color: colors.lecture),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  picked.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtextBold.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatFileSize(context.l10n, picked.bytes.length),
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.close),
            tooltip: context.l10n.remove,
            size: AppIconButtonSize.compact,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

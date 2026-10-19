import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/models/models.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_media_thumbnail.dart';

class MarketMediaPicker extends StatelessWidget {
  const MarketMediaPicker({
    required this.items,
    required this.onReorder,
    required this.onRemove,
    super.key,
    this.onAddPhoto,
    this.onAddVideo,
  });

  final List<MarketMediaDraftItem> items;
  final void Function(int oldIndex, int newIndex) onReorder;
  final ValueChanged<int>? onRemove;
  final VoidCallback? onAddPhoto;
  final VoidCallback? onAddVideo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final entries = <Widget>[
      for (final (index, item) in items.indexed)
        Padding(
          key: ValueKey(item.key),
          padding: EdgeInsetsDirectional.only(
            end:
                index == items.length - 1 &&
                    onAddPhoto == null &&
                    onAddVideo == null
                ? 0
                : AppSpacing.sm,
          ),
          child: ReorderableDelayedDragStartListener(
            index: index,
            child: MarketMediaThumbnail(
              item: item,
              isCover: index == 0,
              onRemove: onRemove == null ? null : () => onRemove!(index),
            ),
          ),
        ),
      if (onAddPhoto case final addPhoto?)
        Padding(
          key: const ValueKey('market-add-photo'),
          padding: EdgeInsetsDirectional.only(
            end: onAddVideo == null ? 0 : AppSpacing.sm,
          ),
          child: _AddMediaButton(
            icon: AppLineIcon.image,
            semanticsLabel: l10n.marketAddPhotoAction,
            onPressed: addPhoto,
          ),
        ),
      if (onAddVideo case final addVideo?)
        Padding(
          key: const ValueKey('market-add-video'),
          padding: EdgeInsets.zero,
          child: _AddMediaButton(
            icon: AppLineIcon.video,
            semanticsLabel: l10n.marketAddVideoAction,
            onPressed: addVideo,
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Text(
            l10n.marketMediaLabel,
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        SizedBox(
          height: 76,
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            onReorderItem: (oldIndex, newIndex) {
              if (oldIndex >= items.length || items.length < 2) return;
              onReorder(oldIndex, newIndex.clamp(0, items.length - 1));
            },
            children: entries,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Text(
            l10n.marketMediaHint,
            style: AppText.caption.copyWith(color: colors.muted2),
          ),
        ),
      ],
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  const _AddMediaButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onPressed,
  });

  final AppLineIcon icon;
  final String semanticsLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      pressedScale: 0.95,
      onTap: onPressed,
      semanticsLabel: semanticsLabel,
      semanticsButton: true,
      child: Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: AppLineIconWidget(
          icon,
          size: AppIconSize.md,
          color: colors.accent,
        ),
      ),
    );
  }
}

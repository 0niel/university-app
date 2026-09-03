import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/utils.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_thumbnail.dart';

class LostFoundRow extends StatelessWidget {
  const LostFoundRow({
    required this.item,
    required this.onTap,
    required this.onContact,
    super.key,
  });

  final LostFoundItem item;
  final VoidCallback onTap;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isFound = item.status == .found;
    final author = item.authorDisplayName(l10n);
    final meta = [
      if (item.location.isNotEmpty) item.location,
      relativeTime(l10n, item.createdAt, compact: true),
      author,
    ].join(' · ');
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '${item.itemName}, $meta',
      semanticsButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.tile),
              child: SizedBox.square(
                dimension: 56,
                child: LostFoundThumbnail(item: item),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tag(
                    label: isFound
                        ? l10n.lostFoundTabFoundShort
                        : l10n.lostFoundTabLostShort,
                    background: isFound ? colors.lectureTint : colors.warnTint,
                    foreground: isFound ? colors.lecture : colors.warn,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.itemName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cell.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    meta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppPressState(
              onTap: onContact,
              semanticsLabel: l10n.lostFoundContactAuthor(author),
              semanticsButton: true,
              builder: (context, {required pressed}) => Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: pressed ? colors.canvas : colors.surface2,
                  shape: BoxShape.circle,
                ),
                child: AppLineIconWidget(
                  AppLineIcon.send,
                  size: 18,
                  color: colors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppText.sans(10, FontWeight.w800).copyWith(color: foreground),
      ),
    );
  }
}

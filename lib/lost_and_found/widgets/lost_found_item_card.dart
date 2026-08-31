import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/utils.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_thumbnail.dart';

class LostFoundItemCard extends StatelessWidget {
  const LostFoundItemCard({required this.item, required this.onTap, super.key});

  final LostFoundItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final meta = [
      if (item.location.isNotEmpty) item.location,
      relativeTime(l10n, item.createdAt),
    ].join(' · ');
    final statusColor = item.status == .found ? colors.green : colors.amberInk;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '${item.itemName}, $meta',
      semanticsButton: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NinjaRadius.card),
        child: ColoredBox(
          color: colors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LostFoundThumbnail(item: item),
                    PositionedDirectional(
                      top: AppSpacing.md,
                      start: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.gap,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(
                            NinjaRadius.pill,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.status == .found
                                  ? l10n.lostFoundTagFound
                                  : l10n.lostFoundTagSearching,
                              style: NinjaText.microLabel.copyWith(
                                color: colors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

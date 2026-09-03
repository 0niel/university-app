import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/communities/widgets/community_style.dart';
import 'package:rtu_mirea_app/communities/widgets/community_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SavedCommunityRow extends StatelessWidget {
  const SavedCommunityRow({
    required this.entry,
    required this.categoryTitle,
    required this.onTap,
    super.key,
  });

  final CommunityCatalogEntry entry;
  final String categoryTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: entry.title,
      semanticsButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 13,
        ),
        child: Row(
          children: [
            CommunityTile(
              name: entry.title,
              logoUrl: entry.logoUrl,
              size: 44,
              radius: AppRadius.tile,
              foreground: entry.isOfficial ? colors.lecture : colors.accent,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: AppText.sans(
                      15,
                      FontWeight.w700,
                    ).copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    communityMeta(
                      context.l10n,
                      entry,
                      categoryTitle: categoryTitle,
                      joined: true,
                    ),
                    style: AppText.sans(
                      12.5,
                      FontWeight.w400,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}

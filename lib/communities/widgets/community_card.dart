import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/communities/widgets/community_join_button.dart';
import 'package:rtu_mirea_app/communities/widgets/community_style.dart';
import 'package:rtu_mirea_app/communities/widgets/community_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    required this.entry,
    required this.categoryTitle,
    required this.joined,
    required this.onOpen,
    required this.onToggleJoin,
    super.key,
  });

  final CommunityCatalogEntry entry;
  final String categoryTitle;
  final bool joined;
  final VoidCallback onOpen;
  final VoidCallback onToggleJoin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final description = entry.description.trim();
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppPressState(
            onTap: onOpen,
            semanticsLabel: entry.title,
            semanticsButton: true,
            builder: (context, {required pressed}) => Opacity(
              opacity: pressed ? .7 : 1,
              child: Row(
                children: [
                  CommunityTile(
                    name: entry.title,
                    logoUrl: entry.logoUrl,
                    foreground: communityCategoryTone(colors, categoryTitle),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                            16,
                            FontWeight.w700,
                          ).copyWith(color: colors.ink),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          communityMeta(
                            l10n,
                            entry,
                            categoryTitle: categoryTitle,
                            joined: joined,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.subtext.copyWith(color: colors.muted),
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
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              description,
              style: AppText.sans(
                13.5,
                FontWeight.w400,
                height: 1.45,
              ).copyWith(color: colors.muted),
            ),
          ],
          const SizedBox(height: 11),
          CommunityJoinButton(
            joined: joined,
            label: joined ? l10n.communitiesSaved : l10n.communitiesSave,
            onTap: onToggleJoin,
          ),
        ],
      ),
    );
  }
}

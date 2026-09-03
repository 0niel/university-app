import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_list_group.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class ActionCardItem {
  const ActionCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.badge,
  });

  final String title;
  final String subtitle;
  final AppLineIcon icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? badge;
}

class ActionCardTile extends StatelessWidget {
  const ActionCardTile({required this.item, super.key});

  final ActionCardItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = item.iconColor ?? colors.accent;
    final badge = item.badge;

    return AppPressable(
      onTap: item.onTap,
      semanticsLabel: '${item.title}, ${item.subtitle}',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.actionInset,
        ),
        child: Row(
          children: [
            AppIconTile(
              icon: item.icon,
              size: AppControlSize.iconTileMedium,
              iconSize: AppIconSize.md,
              background: colors.tintOf(tone),
              foreground: tone,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyStrong.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.badgeInset,
                  vertical: AppSpacing.fine,
                ),
                decoration: BoxDecoration(
                  color: colors.tint,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  badge,
                  style: AppText.badge.copyWith(color: colors.accent),
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.xs,
              color: colors.muted2,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({required this.item, super.key});

  final ActionCardItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ActionCardTile(item: item),
    );
  }
}

class ActionCardGroup extends StatelessWidget {
  const ActionCardGroup({required this.items, super.key});

  final List<ActionCardItem> items;

  @override
  Widget build(BuildContext context) {
    return AppListGroup(
      dividerIndent: 68,
      children: [
        for (final item in items) ActionCardTile(item: item),
      ],
    );
  }
}

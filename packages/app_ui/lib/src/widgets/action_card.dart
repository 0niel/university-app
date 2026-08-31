import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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
  final HugeIcon icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? badge;
}

class ActionCardTile extends StatelessWidget {
  const ActionCardTile({
    required this.item,
    super.key,
  });

  final ActionCardItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final badge = item.badge;

    return AppPressable(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (item.iconColor ?? colors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppText.bodyStrong.copyWith(
                      color: colors.active,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: AppText.caption.copyWith(
                      color: colors.deactive,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: AppText.bodyStrong.copyWith(color: colors.primary),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colors.deactive,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.item,
    super.key,
  });

  final ActionCardItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ActionCardTile(item: item),
      ),
    );
  }
}

class ActionCardGroup extends StatelessWidget {
  const ActionCardGroup({
    required this.items,
    super.key,
  });

  final List<ActionCardItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.background03.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              ActionCardTile(item: items[i]),
              if (i < items.length - 1)
                Divider(height: 1, color: colors.background03),
            ],
          ],
        ),
      ),
    );
  }
}

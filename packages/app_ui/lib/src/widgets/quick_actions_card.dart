import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A card widget that displays a list of quick action tiles.
///
/// This widget provides a clean, consistent way to display multiple
/// quick actions in a card format with proper styling and dividers.
class QuickActionsCard extends StatelessWidget {
  /// Creates a [QuickActionsCard].
  const QuickActionsCard({
    required this.actions,
    super.key,
  });

  /// The list of quick action tiles to display.
  final List<QuickActionTile> actions;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: colors.background03.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            actions[i],
            if (i < actions.length - 1) Divider(height: 1, color: colors.background03),
          ],
        ],
      ),
    );
  }
}

/// A tile widget for displaying a quick action with icon, title, and subtitle.
///
/// This widget provides a consistent way to display actionable items
/// with proper styling, hover effects, and accessibility support.
class QuickActionTile extends StatelessWidget {
  /// Creates a [QuickActionTile].
  const QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    super.key,
  });

  /// The icon to display on the left side of the tile.
  final IconData icon;

  /// The main title text.
  final String title;

  /// The subtitle text displayed below the title.
  final String subtitle;

  /// The color used for the icon background and theming.
  final Color color;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodyBold.copyWith(color: colors.active),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyle.captionL.copyWith(color: colors.deactive),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colors.deactive),
          ],
        ),
      ),
    );
  }
}

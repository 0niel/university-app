import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaFindFriendsDiscoveryAction extends StatelessWidget {
  const NinjaFindFriendsDiscoveryAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accented = false,
    super.key,
  });

  final AppLineIcon icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accented;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = accented ? colors.ink : colors.ink;
    final mutedForeground = accented ? colors.muted : colors.muted;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$title, $subtitle',
      semanticsButton: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 124),
        padding: const .all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: accented ? colors.tint2 : colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: AppControlSize.iconButton,
              height: AppControlSize.iconButton,
              alignment: .center,
              decoration: BoxDecoration(
                color: accented
                    ? colors.ink.withValues(alpha: 0.12)
                    : colors.surface2,
                shape: .circle,
              ),
              child: AppLineIconWidget(icon, size: 20, color: foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppText.headline.copyWith(color: foreground),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 2,
              overflow: .ellipsis,
              style: AppText.subtext.copyWith(color: mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

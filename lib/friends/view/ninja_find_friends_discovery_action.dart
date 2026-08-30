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
    final colors = context.ninja;
    final foreground = accented ? colors.onAccentSoft : colors.ink;
    final mutedForeground = accented ? colors.onAccentSoftMuted : colors.muted;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$title, $subtitle',
      semanticsButton: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 124),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: accented ? colors.accentSoft : colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              alignment: .center,
              decoration: BoxDecoration(
                color: accented
                    ? colors.onAccentSoft.withValues(alpha: 0.12)
                    : colors.surfaceAlt,
                shape: .circle,
              ),
              child: AppLineIconWidget(icon, size: 20, color: foreground),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.headline.copyWith(color: foreground),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 2,
              overflow: .ellipsis,
              style: NinjaText.subtext.copyWith(color: mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

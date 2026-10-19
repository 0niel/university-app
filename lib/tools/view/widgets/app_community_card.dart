import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppCommunityCard extends StatelessWidget {
  const AppCommunityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.featured = false,
    super.key,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconTile = Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: .12),
        borderRadius: .circular(18),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: colors.accent, size: AppIconSize.md),
        child: icon,
      ),
    );
    final labels = Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 2,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: .ellipsis,
          style: AppText.sans(featured ? 24 : 19, FontWeight.w700, height: 1.15)
              .copyWith(
                color: colors.ink,
                fontWeight: .w600,
              ),
        ),
        Text(
          subtitle,
          maxLines: 2,
          overflow: .ellipsis,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
    return Semantics(
      button: true,
      label: title,
      child: AppPressable(
        onTap: onTap,
        child: AppGlassSurface(
          tone: featured ? AppGlassTone.accent : AppGlassTone.subtle,
          borderRadius: featured ? 30 : 26,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: featured ? 112 : 94),
            child: Padding(
              padding: const .all(20),
              child: Row(
                children: [
                  iconTile,
                  const SizedBox(width: AppSpacing.sectionGap),
                  Expanded(child: labels),
                  const SizedBox(width: AppSpacing.gap),
                  AppLineIconWidget(
                    .chevronR,
                    size: AppIconSize.sm,
                    color: colors.muted2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

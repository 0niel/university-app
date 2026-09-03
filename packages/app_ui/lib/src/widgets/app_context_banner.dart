import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppContextBanner extends StatelessWidget {
  const AppContextBanner({
    required this.title,
    required this.subtitle,
    super.key,
    this.emoji,
    this.icon,
    this.actionLabel,
    this.onTap,
  }) : assert(
          emoji != null || icon != null,
          'AppContextBanner requires either emoji or icon.',
        );

  final String? emoji;
  final AppLineIcon? icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = actionLabel;
    final emoji = this.emoji;
    final icon = this.icon;

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionGap,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: Row(
        children: [
          if (icon != null)
            AppIconTile(
              icon: icon,
              size: 32,
              radius: AppRadius.sm,
              background: colors.tint2,
              foreground: colors.accent,
              iconSize: AppIconSize.compact,
            )
          else
            AppIconTile(
              size: 32,
              radius: AppRadius.sm,
              background: colors.tint2,
              child: Text(
                emoji!,
                style: AppText.sans(17, FontWeight.w400, height: 1),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppText.subtextBold.copyWith(color: colors.accent),
            ),
          ] else if (onTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.xs,
              color: colors.accent,
              strokeWidth: 2.5,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;
    return AppPressable(onTap: onTap, semanticsLabel: title, child: content);
  }
}

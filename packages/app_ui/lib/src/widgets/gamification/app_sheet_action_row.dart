import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppSheetActionRow extends StatelessWidget {
  const AppSheetActionRow({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.isFirst = false,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final bool isFirst;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final foreground = isDestructive ? colors.danger : colors.ink;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: subtitleText == null ? title : '$title, $subtitleText',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFirst) const AppDivider(),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: AppSpacing.actionInset),
            child: Row(
              children: [
                AppIconTile(
                  background: isDestructive ? colors.dangerTint : null,
                  child:
                      Icon(icon, size: AppIconSize.compact, color: foreground),
                ),
                const SizedBox(width: AppSpacing.sectionGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppText.body.copyWith(color: foreground),
                      ),
                      if (subtitleText != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitleText,
                          style: AppText.caption.copyWith(color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
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
        ],
      ),
    );
  }
}

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppSettingsRow extends StatelessWidget {
  const AppSettingsRow({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.showChevron = true,
    this.isDestructive = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;
  final bool showChevron;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final leadingWidget = leading;
    final trailingWidget = trailing;
    final titleColor = isDestructive ? colors.danger : colors.ink;
    final dense = subtitleText != null || leadingWidget != null;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: subtitleText == null ? title : '$title, $subtitleText',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFirst)
            AppDivider(indent: leadingWidget != null ? 64 : AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: dense ? AppSpacing.actionInset : 15,
            ),
            child: Row(
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppText.body.copyWith(color: titleColor),
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
                if (trailingWidget != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trailingWidget,
                ] else if (showChevron && onTap != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppLineIconWidget(
                    AppLineIcon.chevronR,
                    size: AppIconSize.xs,
                    color: colors.muted2,
                    strokeWidth: 2.5,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

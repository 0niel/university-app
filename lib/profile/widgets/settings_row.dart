import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'settings_row_icon.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    super.key,
    this.subtitle,
    this.value,
    this.valueColor,
    this.trailing,
    this.icon,
    this.lineIcon,
    this.showChevron = true,
    this.danger = false,
    this.enabled = true,
    this.horizontalPadding = 16,
    this.verticalPadding = 15,
    this.minimumHeight = 50,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? value;
  final Color? valueColor;
  final Widget? trailing;
  final IconData? icon;
  final AppLineIcon? lineIcon;
  final bool showChevron;
  final bool danger;
  final bool enabled;

  final double horizontalPadding;
  final double verticalPadding;
  final double minimumHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lineIcon = this.lineIcon;
    final icon = this.icon;
    final row = Semantics(
      button: onTap != null,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? onTap : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minimumHeight),
          child: Padding(
            padding: .symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                if (lineIcon != null || icon != null) ...[
                  _SettingsRowIcon(
                    lineIcon: lineIcon,
                    icon: icon,
                    danger: danger,
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.sans(15, FontWeight.w600, height: 4 / 3)
                            .copyWith(
                              color: danger ? colors.danger : colors.ink,
                            ),
                      ),
                      if (subtitle case final subtitleText?) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitleText,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: AppText.sans(
                            12.5,
                            FontWeight.w500,
                            height: 1.28,
                          ).copyWith(color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing case final trailingWidget?) ...[
                  const SizedBox(width: AppSpacing.gap),
                  trailingWidget,
                ] else if (value case final valueText?) ...[
                  const SizedBox(width: AppSpacing.gap),
                  AppRowTrailing(
                    child: Text(
                      valueText,
                      maxLines: 2,
                      overflow: .ellipsis,
                      textAlign: .end,
                      style: AppText.sans(14, FontWeight.w500).copyWith(
                        color: valueColor ?? colors.muted,
                      ),
                    ),
                  ),
                ],
                if (showChevron && onTap != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppLineIconWidget(
                    .chevronR,
                    size: 16,
                    color: colors.muted2,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return enabled ? row : Opacity(opacity: 0.45, child: row);
  }
}

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
    this.horizontalPadding = 8,
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final lineIcon = this.lineIcon;
    final icon = this.icon;
    final row = Semantics(
      button: onTap != null,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? onTap : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 54),
          child: Padding(
            padding: .symmetric(horizontal: horizontalPadding, vertical: 7),
            child: Row(
              children: [
                if (lineIcon != null || icon != null) ...[
                  _SettingsRowIcon(
                    lineIcon: lineIcon,
                    icon: icon,
                    danger: danger,
                  ),
                  const SizedBox(width: 12),
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
                        style: NinjaText.body.copyWith(
                          fontWeight: .w600,
                          color: danger ? colors.scarlet : colors.ink,
                        ),
                      ),
                      if (subtitle case final subtitleText?) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitleText,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: NinjaText.helper.copyWith(color: colors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing case final trailingWidget?) ...[
                  const SizedBox(width: 10),
                  trailingWidget,
                ] else if (value case final valueText?) ...[
                  const SizedBox(width: 10),
                  AppRowTrailing(
                    child: Text(
                      valueText,
                      maxLines: 2,
                      overflow: .ellipsis,
                      textAlign: .end,
                      style: NinjaText.subtext.copyWith(
                        color: valueColor ?? colors.muted,
                      ),
                    ),
                  ),
                ],
                if (showChevron && onTap != null) ...[
                  const SizedBox(width: 8),
                  AppLineIconWidget(
                    .chevronR,
                    size: 16,
                    color: colors.chevron,
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

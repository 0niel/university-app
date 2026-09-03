import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 13,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppText.sans(
                      12.5,
                      FontWeight.w500,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppSwitch(value: value, onChanged: onChanged, semanticsLabel: title),
        ],
      ),
    );
  }
}

class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.destructive = false,
    this.leadingIcon,
    super.key,
  });

  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;
  final AppLineIcon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = this.value;
    final leadingIcon = this.leadingIcon;
    final fg = destructive ? colors.danger : colors.ink;
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 15,
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            AppLineIconWidget(leadingIcon, size: 18, color: fg),
            const SizedBox(width: AppSpacing.gap),
          ],
          Expanded(
            child: Text(
              title,
              style: (destructive ? AppText.headlineStrong : AppText.headline)
                  .copyWith(color: fg),
            ),
          ),
          if (trailing case final trailing?)
            trailing
          else ...[
            if (value != null)
              AppRowTrailing(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(color: colors.muted),
                ),
              ),
            if (showChevron && onTap != null) ...[
              const SizedBox(width: AppSpacing.xsm),
              AppLineIconWidget(
                AppLineIcon.chevronR,
                size: 16,
                color: colors.muted2,
              ),
            ],
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return AppPressState(
      onTap: onTap,
      semanticsLabel: title,
      semanticsButton: true,
      builder: (context, {required pressed}) => ColoredBox(
        color: pressed ? colors.canvas : colors.surface,
        child: row,
      ),
    );
  }
}

class ProfileLinkRow extends StatelessWidget {
  const ProfileLinkRow({
    required this.icon,
    required this.title,
    this.meta,
    this.onTap,
    this.showChevron = true,
    super.key,
  });

  final AppLineIcon icon;
  final String title;
  final String? meta;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final meta = this.meta;
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      child: Row(
        children: [
          AppIconTile(icon: icon, iconSize: 18, foreground: colors.ink),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppText.headline.copyWith(color: colors.ink),
            ),
          ),
          if (meta != null) ...[
            const SizedBox(width: AppSpacing.md),
            AppRowTrailing(
              child: Text(
                meta,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(
                  13,
                  FontWeight.w500,
                ).copyWith(color: colors.muted),
              ),
            ),
          ],
          if (showChevron) ...[
            const SizedBox(width: AppSpacing.md),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return AppPressState(
      onTap: onTap,
      semanticsLabel: title,
      semanticsButton: true,
      builder: (context, {required pressed}) => ColoredBox(
        color: pressed ? colors.canvas : colors.surface,
        child: row,
      ),
    );
  }
}

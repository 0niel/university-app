import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppListRow extends StatelessWidget {
  const AppListRow({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.meta,
    this.trailing,
    this.isFirst = false,
    this.dense = false,
    this.strong = false,
    this.destructive = false,
    this.showChevron,
    this.onTap,
    this.onDelete,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final String? meta;
  final Widget? trailing;
  final bool isFirst;
  final bool dense;
  final bool strong;
  final bool destructive;
  final bool? showChevron;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final metaText = meta;
    final trailingWidget = trailing;
    final tight = subtitleText != null || leading != null;
    final vertical = dense ? 10.0 : (tight ? 13.0 : 15.0);
    final withChevron = showChevron ??
        (!destructive && trailingWidget == null && onTap != null);
    final titleColor = destructive ? colors.danger : colors.ink;

    var leadingWidget = leading;
    if (leadingWidget != null && destructive) {
      leadingWidget = IconTheme.merge(
        data: IconThemeData(color: colors.danger),
        child: leadingWidget,
      );
    }

    Widget row = AppPressable(
      onTap: onTap,
      semanticsButton: onTap != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: vertical,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (strong ? AppText.bodyStrong : AppText.body)
                          .copyWith(color: titleColor),
                    ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitleText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (metaText != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  metaText,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
              if (trailingWidget != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailingWidget,
              ],
              if (withChevron) ...[
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
      ),
    );

    if (onDelete != null) {
      row = Dismissible(
        key: ValueKey<String>('app-list-row-$title'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete?.call(),
        background: ColoredBox(
          color: colors.danger,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 72,
              child: Center(
                child: AppLineIconWidget(
                  AppLineIcon.trash,
                  size: AppIconSize.compact,
                  color: colors.white,
                ),
              ),
            ),
          ),
        ),
        child: row,
      );
    }

    return row;
  }
}

class AppIconAvatar extends StatelessWidget {
  const AppIconAvatar({
    super.key,
    this.icon,
    this.emoji,
    this.color,
    this.size = 40,
    this.radius = AppRadius.iconTile,
  });

  final IconData? icon;
  final String? emoji;
  final Color? color;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = color ?? colors.accent;
    final emojiText = emoji;

    return AppIconTile(
      size: size,
      radius: radius,
      background: colors.tintOf(tone),
      foreground: tone,
      child: emojiText != null
          ? Text(
              emojiText,
              style: AppText.sans(size * .46, FontWeight.w500, height: 1),
            )
          : Icon(icon, size: size * .5, color: tone),
    );
  }
}

class AppSubjectCell extends StatelessWidget {
  const AppSubjectCell({
    required this.title,
    super.key,
    this.color,
    this.time,
    this.meta,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    this.onTap,
  });

  final String title;
  final Color? color;
  final String? time;
  final String? meta;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = color ?? colors.accent;
    final timeText = time;
    final metaText = meta;

    return AppPressable(
      onTap: onTap,
      semanticsButton: onTap != null,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                color: tone,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(AppRadius.bar),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodyStrong.copyWith(color: colors.ink),
                        ),
                      ),
                      if (timeText != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          timeText,
                          style: AppText.tabular(
                            AppText.captionStrong.copyWith(color: colors.muted),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (metaText != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      metaText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

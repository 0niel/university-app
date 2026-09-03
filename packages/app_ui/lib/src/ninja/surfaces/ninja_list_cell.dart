import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/app_row_trailing.dart';
import 'package:flutter/material.dart';

class NinjaListCell extends StatelessWidget {
  const NinjaListCell({
    required this.title,
    super.key,
    this.subtitle,
    this.trailingLabel,
    this.trailingColor,
    this.titleColor,
    this.leading,
    this.trailing,
    this.strong = false,
    this.destructive = false,
    this.showChevron = true,
    this.showDivider = true,
    this.horizontalPadding = AppSpacing.lg,
    this.onTap,
    this.onDelete,
    this.dismissibleKey,
  })  : _subject = false,
        time = null,
        meta = null,
        color = null;

  const NinjaListCell.subject({
    required this.title,
    required this.time,
    super.key,
    this.meta,
    this.color,
    this.showDivider = true,
    this.onTap,
    this.onDelete,
    this.dismissibleKey,
  })  : _subject = true,
        subtitle = null,
        trailingLabel = null,
        trailingColor = null,
        titleColor = null,
        leading = null,
        trailing = null,
        strong = false,
        destructive = false,
        horizontalPadding = 16,
        showChevron = false;

  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final Color? trailingColor;
  final Color? titleColor;
  final Widget? leading;
  final Widget? trailing;
  final bool strong;
  final bool destructive;
  final double horizontalPadding;
  final bool showChevron;
  final bool showDivider;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Key? dismissibleKey;
  final String? time;
  final String? meta;
  final Color? color;
  final bool _subject;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    var cell = _subject ? _buildSubject(colors) : _buildBase(colors);
    if (onTap != null) cell = AppPressable(onTap: onTap, child: cell);
    if (onDelete != null) {
      cell = Dismissible(
        key: dismissibleKey ?? ValueKey('ninja-list-cell-$title'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete!(),
        background: ColoredBox(
          color: colors.danger,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
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
        child: cell,
      );
    }
    return cell;
  }

  Widget _buildBase(AppColors colors) {
    final label = trailingLabel;
    final control = trailing;
    final subtitleText = subtitle;
    final lead = leading;
    final dense = subtitleText != null || lead != null;
    final foreground = destructive ? colors.danger : (titleColor ?? colors.ink);

    return Container(
      color: Colors.transparent,
      constraints: const BoxConstraints(minHeight: AppControlSize.touchTarget),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: dense ? AppSpacing.actionInset : 15,
      ),
      child: Row(
        children: [
          if (lead != null) ...[lead, const SizedBox(width: AppSpacing.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: (strong || destructive
                          ? AppText.bodyStrong
                          : AppText.body)
                      .copyWith(color: foreground),
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
          if (control != null) ...[
            const SizedBox(width: AppSpacing.gap),
            control,
          ] else if (label != null) ...[
            const SizedBox(width: AppSpacing.gap),
            AppRowTrailing(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppText.subtext.copyWith(
                  color: trailingColor ?? colors.muted,
                ),
              ),
            ),
          ],
          if (showChevron && !destructive) ...[
            const SizedBox(width: AppSpacing.xsm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.xs,
              color: colors.muted2,
              strokeWidth: 2.5,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubject(AppColors colors) {
    final metaText = meta;
    final timeText = time;

    return ColoredBox(
      color: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(13, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppText.bodyStrong.copyWith(color: colors.ink),
                      ),
                    ),
                    if (timeText != null) ...[
                      const SizedBox(width: AppSpacing.gap),
                      Text(
                        timeText,
                        style: AppText.tabular(AppText.captionStrong).copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
                if (metaText != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    metaText,
                    style: AppText.caption.copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            top: 14,
            bottom: 14,
            width: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? colors.accent,
                borderRadius: const BorderRadiusDirectional.horizontal(
                  end: Radius.circular(AppRadius.bar),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef AppListCell = NinjaListCell;

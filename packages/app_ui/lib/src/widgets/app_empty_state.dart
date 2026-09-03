import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pill_button.dart';
import 'package:flutter/widgets.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    super.key,
    this.emoji,
    this.icon,
    this.lineIcon = AppLineIcon.inbox,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.emojiSize = 26,
    this.subtitleMaxWidth = 260,
    this.child,
    this.compact = false,
  });

  const AppEmptyState.compact({
    required this.title,
    super.key,
    this.subtitle,
    this.subtitleMaxWidth = 260,
  })  : compact = true,
        emoji = null,
        icon = null,
        lineIcon = AppLineIcon.inbox,
        actionLabel = null,
        onAction = null,
        emojiSize = 26,
        child = null;

  final String title;
  final String? subtitle;
  final String? emoji;
  final Widget? icon;
  final AppLineIcon lineIcon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double emojiSize;
  final double subtitleMaxWidth;
  final Widget? child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final actionText = actionLabel;
    final extra = child;

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sheetBottom,
          horizontal: AppSpacing.fieldGap,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: colors.muted, height: 1.4),
            ),
            if (subtitleText != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitleText,
                textAlign: TextAlign.center,
                style: AppText.subtext.copyWith(
                  color: colors.muted2,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xlg,
        horizontal: AppSpacing.fieldGap,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmptyStateTile(
            emoji: emoji,
            emojiSize: emojiSize,
            icon: icon,
            lineIcon: lineIcon,
          ),
          const SizedBox(height: AppSpacing.gap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.sectionSmall.copyWith(color: colors.ink),
          ),
          if (subtitleText != null) ...[
            const SizedBox(height: AppSpacing.gap),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: subtitleMaxWidth),
              child: Text(
                subtitleText,
                textAlign: TextAlign.center,
                style: AppText.subtext.copyWith(
                  color: colors.muted,
                  height: 1.4,
                ),
              ),
            ),
          ],
          if (actionText != null) ...[
            const SizedBox(height: AppSpacing.gap),
            AppPillButton(
              label: actionText,
              background: colors.tint,
              foreground: colors.accent,
              onPressed: onAction,
            ),
          ],
          if (extra != null) ...[
            const SizedBox(height: AppSpacing.lg),
            extra,
          ],
        ],
      ),
    );
  }
}

class _EmptyStateTile extends StatelessWidget {
  const _EmptyStateTile({
    required this.emoji,
    required this.emojiSize,
    required this.icon,
    required this.lineIcon,
  });

  final String? emoji;
  final double emojiSize;
  final Widget? icon;
  final AppLineIcon lineIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconWidget = icon;
    final emojiText = emoji;

    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: iconWidget ??
          (emojiText != null
              ? Text(
                  emojiText,
                  style: TextStyle(fontSize: emojiSize, height: 1),
                )
              : AppLineIconWidget(
                  lineIcon,
                  size: AppIconSize.lg,
                  color: colors.accent,
                )),
    );
  }
}

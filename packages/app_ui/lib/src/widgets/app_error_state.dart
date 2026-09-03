import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pill_button.dart';
import 'package:flutter/widgets.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.icon,
    this.lineIcon = AppLineIcon.wifiOff,
    this.title = 'Нет соединения',
    this.message = 'Проверь интернет. Расписание и заметки доступны офлайн.',
    this.primaryLabel = 'Повторить',
    this.onPrimary,
    this.primaryIcon,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.footnote = 'Синхронизируем, когда сеть вернётся',
    this.messageMaxWidth = 260,
    this.compact = false,
  });

  const AppErrorState.compact({
    required this.title,
    super.key,
    this.message,
    this.messageMaxWidth = 260,
  })  : compact = true,
        icon = null,
        lineIcon = AppLineIcon.wifiOff,
        primaryLabel = '',
        onPrimary = null,
        primaryIcon = null,
        secondaryLabel = null,
        onSecondary = null,
        secondaryIcon = null,
        footnote = null;

  final IconData? icon;
  final AppLineIcon lineIcon;
  final String title;
  final String? message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? secondaryIcon;
  final String? footnote;
  final double messageMaxWidth;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final messageText = message;
    final secondary = secondaryLabel;
    final footnoteText = footnote;

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
            if (messageText != null && messageText.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                messageText,
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
          _ErrorStateTile(icon: icon, lineIcon: lineIcon),
          const SizedBox(height: AppSpacing.gap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.sectionSmall.copyWith(color: colors.ink),
          ),
          if (messageText != null && messageText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.gap),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: messageMaxWidth),
              child: Text(
                messageText,
                textAlign: TextAlign.center,
                style: AppText.subtext.copyWith(
                  color: colors.muted,
                  height: 1.4,
                ),
              ),
            ),
          ],
          if (primaryLabel.isNotEmpty || secondary != null) ...[
            const SizedBox(height: AppSpacing.gap),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.gap,
              runSpacing: AppSpacing.gap,
              children: [
                if (secondary != null)
                  AppPillButton(
                    label: secondary,
                    background: colors.tint,
                    foreground: colors.accent,
                    onPressed: onSecondary,
                  ),
                if (primaryLabel.isNotEmpty)
                  AppPillButton(
                    label: primaryLabel,
                    background: colors.surface2,
                    foreground: colors.ink,
                    onPressed: onPrimary,
                  ),
              ],
            ),
          ],
          if (footnoteText != null) ...[
            const SizedBox(height: AppSpacing.gap),
            Text(
              footnoteText,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: colors.muted2),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorStateTile extends StatelessWidget {
  const _ErrorStateTile({required this.icon, required this.lineIcon});

  final IconData? icon;
  final AppLineIcon lineIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconData = icon;

    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.examTint,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: iconData != null
          ? Icon(iconData, size: AppIconSize.lg, color: colors.danger)
          : AppLineIconWidget(
              lineIcon,
              size: AppIconSize.lg,
              color: colors.danger,
            ),
    );
  }
}

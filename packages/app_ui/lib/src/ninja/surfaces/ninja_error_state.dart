import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_pill_button.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class NinjaErrorState extends StatelessWidget {
  const NinjaErrorState({
    required this.title,
    super.key,
    this.message,
    this.tone = NinjaErrorTone.danger,
    this.icon,
    this.retryLabel,
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String? message;
  final NinjaErrorTone tone;
  final Widget? icon;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final messageText = message;
    final retry = retryLabel;
    final secondary = secondaryLabel;
    final accent = tone.accentOf(colors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.fieldGap,
        vertical: AppSpacing.xlg,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tone.tintOf(colors),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: IconTheme(
              data: IconThemeData(size: AppIconSize.lg, color: accent),
              child: icon ??
                  AppLineIconWidget(
                    tone.icon,
                    size: AppIconSize.lg,
                    color: accent,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.gap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.sectionSmall.copyWith(color: colors.ink),
          ),
          if (messageText != null) ...[
            const SizedBox(height: AppSpacing.gap),
            Text(
              messageText,
              textAlign: TextAlign.center,
              style: AppText.subtext.copyWith(
                color: colors.muted,
                height: 1.4,
              ),
            ),
          ],
          if (retry != null || secondary != null) ...[
            const SizedBox(height: AppSpacing.gap),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                if (retry != null)
                  NinjaPillButton(
                    label: retry,
                    onPressed: onRetry,
                    tone: NinjaPillTone.secondary,
                  ),
                if (secondary != null)
                  NinjaPillButton(
                    label: secondary,
                    onPressed: onSecondary,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

enum NinjaErrorTone {
  danger,
  warn,
  info;

  Color accentOf(AppColors colors) => switch (this) {
        NinjaErrorTone.danger => colors.danger,
        NinjaErrorTone.warn => colors.warn,
        NinjaErrorTone.info => colors.accent,
      };

  Color tintOf(AppColors colors) => switch (this) {
        NinjaErrorTone.danger => colors.examTint,
        NinjaErrorTone.warn => colors.warnTint,
        NinjaErrorTone.info => colors.tint,
      };

  AppLineIcon get icon => switch (this) {
        NinjaErrorTone.danger => AppLineIcon.cloudOff,
        NinjaErrorTone.warn => AppLineIcon.alert,
        NinjaErrorTone.info => AppLineIcon.info,
      };
}

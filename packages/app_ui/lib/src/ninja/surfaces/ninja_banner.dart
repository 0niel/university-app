import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_banner.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum NinjaBannerTone { danger, warn, success, info }

class NinjaBanner extends StatelessWidget {
  const NinjaBanner({
    required this.title,
    super.key,
    this.tone = NinjaBannerTone.info,
    this.body,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final String title;
  final NinjaBannerTone tone;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = tone.accentOf(colors);
    final bodyText = body;
    final action = actionLabel;
    if (bodyText == null && icon == null) {
      return AppBanner(
        message: title,
        tone: switch (tone) {
          NinjaBannerTone.info => AppBannerTone.accent,
          NinjaBannerTone.warn => AppBannerTone.warn,
          NinjaBannerTone.danger => AppBannerTone.danger,
          NinjaBannerTone.success => AppBannerTone.success,
        },
        actionLabel: actionLabel,
        onAction: onAction,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionGap,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: tone.tintOf(colors),
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: Row(
        crossAxisAlignment: bodyText == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (icon != null)
            IconTheme(
              data: IconThemeData(size: AppIconSize.compact, color: accent),
              child: icon!,
            )
          else
            Padding(
              padding: EdgeInsets.only(
                top: bodyText == null ? AppSpacing.zero : AppSpacing.xs,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 8),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.label.copyWith(color: colors.ink)),
                if (bodyText != null) ...[
                  const SizedBox(height: AppSpacing.micro),
                  Text(
                    bodyText,
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.md),
            AppPressable(
              onTap: onAction,
              semanticsLabel: action,
              semanticsButton: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                  child: Center(
                    child: Text(
                      action,
                      style: AppText.subtextBold.copyWith(color: accent),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

extension NinjaBannerToneX on NinjaBannerTone {
  Color accentOf(AppColors colors) => switch (this) {
        NinjaBannerTone.danger => colors.danger,
        NinjaBannerTone.warn => colors.warn,
        NinjaBannerTone.success => colors.lecture,
        NinjaBannerTone.info => colors.accent,
      };

  Color tintOf(AppColors colors) => switch (this) {
        NinjaBannerTone.danger => colors.examTint,
        NinjaBannerTone.warn => colors.warnTint,
        NinjaBannerTone.success => colors.lectureTint,
        NinjaBannerTone.info => colors.tint,
      };
}

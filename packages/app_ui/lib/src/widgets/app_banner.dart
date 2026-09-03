import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_badge.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum AppBannerTone { accent, warn, danger, success }

class AppBanner extends StatelessWidget {
  const AppBanner({
    required this.message,
    super.key,
    this.tone = AppBannerTone.accent,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final AppBannerTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (:bg, :fg) = _resolve(colors);
    final actionLabel = this.actionLabel;

    final content = Container(
      constraints: const BoxConstraints(minHeight: AppControlSize.touchTarget),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionGap,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            AppDot(size: 8, color: fg),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppText.label.copyWith(color: colors.ink),
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(width: AppSpacing.md),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: constraints.maxWidth * .45),
                child: Text(
                  actionLabel,
                  style: AppText.subtextBold.copyWith(color: fg),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onAction == null) return content;
    return AppPressable(
      onTap: onAction,
      semanticsLabel: actionLabel == null ? message : '$message, $actionLabel',
      semanticsButton: true,
      child: content,
    );
  }

  ({Color bg, Color fg}) _resolve(AppColors c) => switch (tone) {
        AppBannerTone.accent => (bg: c.tint, fg: c.accent),
        AppBannerTone.warn => (bg: c.warnTint, fg: c.warn),
        AppBannerTone.danger => (bg: c.examTint, fg: c.exam),
        AppBannerTone.success => (bg: c.lectureTint, fg: c.lecture),
      };
}

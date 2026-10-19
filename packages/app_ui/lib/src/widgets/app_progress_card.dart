import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppProgressCard extends StatelessWidget {
  const AppProgressCard({
    required this.title,
    required this.value,
    required this.progress,
    this.emblem,
    this.supporting,
    this.metadata,
    this.onTap,
    this.semanticsLabel,
    super.key,
  });

  final Widget title;
  final Widget value;
  final Widget progress;
  final Widget? emblem;
  final Widget? supporting;
  final Widget? metadata;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      semanticsButton: onTap != null,
      child: AppGlassSurface(
        padding: const EdgeInsets.all(AppSpacing.contentGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle.merge(
                        style: AppText.label.copyWith(color: colors.muted),
                        child: title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DefaultTextStyle.merge(
                        style: AppText.cardValue.copyWith(color: colors.ink),
                        child: value,
                      ),
                    ],
                  ),
                ),
                if (emblem case final emblemWidget?) ...[
                  const SizedBox(width: AppSpacing.md),
                  emblemWidget,
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            progress,
            if (supporting case final supportingWidget?) ...[
              const SizedBox(height: AppSpacing.md),
              DefaultTextStyle.merge(
                style: AppText.caption.copyWith(
                  color: colors.muted,
                  height: 1.4,
                ),
                child: supportingWidget,
              ),
            ],
            if (metadata case final metadataWidget?) ...[
              SizedBox(
                height: supporting == null ? AppSpacing.md : AppSpacing.sm,
              ),
              DefaultTextStyle.merge(
                style: AppText.captionStrong.copyWith(color: colors.accent),
                child: metadataWidget,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

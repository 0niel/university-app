import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_error_state.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaErrorCard extends StatelessWidget {
  const NinjaErrorCard({
    required this.title,
    required this.message,
    super.key,
    this.tone = NinjaErrorTone.danger,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final NinjaErrorTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = actionLabel;
    final accent = tone.accentOf(colors);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.fine),
            child: DecoratedBox(
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: const SizedBox.square(dimension: 8),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppText.label.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.micro),
                Text(
                  message,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
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

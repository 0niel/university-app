import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppRadioRow extends StatelessWidget {
  const AppRadioRow({
    required this.title,
    required this.selected,
    super.key,
    this.subtitle,
    this.emoji,
    this.leading,
    this.isFirst = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.card)),
    this.onTap,
  });

  final String title;
  final bool selected;
  final String? subtitle;
  final String? emoji;
  final Widget? leading;
  final bool isFirst;
  final BorderRadiusGeometry borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final leadingWidget = leading;
    final emojiText = emoji;
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);

    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: onTap != null,
      label: subtitleText == null ? title : '$title, $subtitleText',
      excludeSemantics: true,
      onTap: onTap,
      child: AppPressable(
        haptics: !selected,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.tint : colors.surface,
            borderRadius: borderRadius,
          ),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: AppSpacing.sectionGap),
              ] else if (emojiText != null) ...[
                SizedBox.square(
                  dimension: 38,
                  child: Center(
                    child: Text(
                      emojiText,
                      style: const TextStyle(fontSize: 20, height: 1),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sectionGap),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: selected
                          ? AppText.bodyBold.copyWith(color: colors.ink)
                          : AppText.bodyStrong.copyWith(color: colors.ink),
                    ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitleText,
                        style: AppText.subtext.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? colors.accent : colors.surface2,
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? AppLineIconWidget(
                        AppLineIcon.check,
                        size: AppIconSize.badge,
                        color: colors.onAccent,
                        strokeWidth: 2.6,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppRadioRow extends StatelessWidget {
  const AppRadioRow({
    required this.title,
    required this.selected,
    super.key,
    this.subtitle,
    this.emoji,
    this.leading,
    this.isFirst = false,
    this.onTap,
  });

  final String title;
  final bool selected;
  final String? subtitle;
  final String? emoji;
  final Widget? leading;
  final bool isFirst;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final subtitle = this.subtitle;
    final leading = this.leading;
    final emoji = this.emoji;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);
    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: onTap != null,
      label: subtitle == null ? title : '$title, $subtitle',
      excludeSemantics: true,
      onTap: onTap,
      child: AppPressable(
        haptics: !selected,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.brandTint : Colors.transparent,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading,
                const SizedBox(width: 14),
              ] else if (emoji != null) ...[
                SizedBox.square(
                  dimension: 38,
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 20, height: 1),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? colors.brand : colors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? NinjaCheckMark(size: 13, color: colors.onBrand)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

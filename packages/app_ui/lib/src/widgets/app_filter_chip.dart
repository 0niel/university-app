import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

enum AppChipStyle { tinted, filter }

abstract final class _ChipMetrics {
  static const double leadingIcon = 15;
  static const double gap = 7;
  static const double dotSize = 6;
  static const double removalGap = 3;
  static const double removalInset = AppSpacing.xs;
  static const double filterVerticalInset = 9;
}

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
    this.onRemove,
    this.removeSemanticLabel,
    this.count,
    this.showDot = false,
    this.dotColor,
    this.leadingIcon,
    this.leading,
    this.enabled = true,
    this.color,
  }) : style = AppChipStyle.tinted;

  const AppChip.filter({
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
    this.count,
    this.showDot = false,
    this.dotColor,
    this.leadingIcon,
    this.leading,
    this.enabled = true,
    this.color,
  })  : style = AppChipStyle.filter,
        onRemove = null,
        removeSemanticLabel = null;

  final String label;
  final AppChipStyle style;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final String? removeSemanticLabel;
  final int? count;
  final bool showDot;
  final Color? dotColor;
  final AppLineIcon? leadingIcon;
  final Widget? leading;
  final bool enabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final accent = color ?? colors.accent;
    final filter = style == AppChipStyle.filter;

    var background = filter
        ? (selected ? accent : colors.surface)
        : (selected ? colors.tintOf(accent) : colors.surface2);
    var foreground = filter
        ? (selected ? colors.onAccent : colors.ink)
        : (selected ? accent : colors.muted);
    if (!enabled) {
      background = colors.canvas;
      foreground = colors.muted2;
    }

    final removeLabel = removeSemanticLabel ??
        '${MaterialLocalizations.of(context).deleteButtonTooltip}: $label';
    final count = this.count;
    final leading = this.leading ??
        (leadingIcon == null
            ? null
            : AppLineIconWidget(
                leadingIcon!,
                size: _ChipMetrics.leadingIcon,
                color: foreground,
              ));

    return AppPressState(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      semanticsLabel: onRemove == null ? label : null,
      semanticsButton: true,
      semanticsSelected: selected,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        constraints: BoxConstraints(
          minHeight: filter ? 0 : AppControlSize.touchTarget,
        ),
        padding: filter
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.sectionGap,
                vertical: _ChipMetrics.filterVerticalInset,
              )
            : EdgeInsets.only(
                left: AppSpacing.lg,
                right: onRemove == null
                    ? AppSpacing.lg
                    : _ChipMetrics.removalInset,
              ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: _ChipMetrics.gap),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (filter ? AppText.chipStrong : AppText.chip).copyWith(
                  color: foreground,
                ),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: _ChipMetrics.gap),
              Opacity(
                opacity: .7,
                child: Text(
                  '$count',
                  style: AppText.chip.copyWith(color: foreground),
                ),
              ),
            ],
            if (showDot) ...[
              const SizedBox(width: _ChipMetrics.gap),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: enabled ? (dotColor ?? colors.danger) : colors.muted2,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: _ChipMetrics.dotSize),
              ),
            ],
            if (onRemove != null) ...[
              const SizedBox(width: _ChipMetrics.removalGap),
              AppPressState(
                onTap: enabled ? onRemove : null,
                enabled: enabled,
                pressedScale: 0.9,
                semanticsLabel: removeLabel,
                semanticsButton: true,
                builder: (context, {required pressed}) => SizedBox.square(
                  dimension: AppControlSize.touchTarget,
                  child: Center(
                    child: AppLineIconWidget(
                      AppLineIcon.close,
                      size: AppIconSize.xs,
                      color: foreground,
                      strokeWidth: 2.4,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    super.key,
    this.onTap,
    this.isSelected = false,
    this.color,
    this.icon,
    this.leadingIcon,
    this.count,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? color;
  final AppLineIcon? icon;
  final AppLineIcon? leadingIcon;
  final int? count;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppChip.filter(
      label: label,
      selected: isSelected,
      onTap: onTap,
      color: color,
      leadingIcon: leadingIcon ?? icon,
      count: count,
      enabled: enabled,
    );
  }
}

class AppChipGroup extends StatelessWidget {
  const AppChipGroup({
    required this.chips,
    super.key,
    this.spacing = AppSpacing.sm,
    this.runSpacing = AppSpacing.sm,
  });

  final List<Widget> chips;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, children: chips);
  }
}

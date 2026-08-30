import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';

class NinjaChip extends StatelessWidget {
  const NinjaChip({
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
    this.onRemove,
    this.removeSemanticLabel,
    this.showDot = false,
    this.dotColor,
    this.count,
    this.enabled = true,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final String? removeSemanticLabel;
  final bool showDot;
  final Color? dotColor;
  final int? count;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    var background = colors.surfaceAlt;
    var foreground = colors.mutedDark;
    if (selected) {
      background = colors.brandTint;
      foreground = colors.brandInk;
    }
    if (!enabled) {
      background = colors.surface;
      foreground = colors.disabled;
    }
    final removeLabel = removeSemanticLabel ??
        '${MaterialLocalizations.of(context).deleteButtonTooltip}: $label';

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: onRemove == null ? 16 : 0,
              top: onRemove == null ? 11 : 0,
              bottom: onRemove == null ? 11 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: NinjaText.body.copyWith(
                    fontSize: 13,
                    color: foreground,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    '$count',
                    style: NinjaText.body.copyWith(
                      fontSize: 13,
                      color: enabled ? foreground : colors.disabled,
                    ),
                  ),
                ],
                if (showDot) ...[
                  const SizedBox(width: 7),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: enabled
                          ? (dotColor ?? colors.scarlet)
                          : colors.disabled,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 6),
                  ),
                ],
                if (onRemove != null) ...[
                  const SizedBox(width: 4),
                  Semantics(
                    button: true,
                    enabled: enabled,
                    label: removeLabel,
                    child: AppPressable(
                      pressedScale: 0.9,
                      onTap: enabled ? onRemove : null,
                      child: SizedBox.square(
                        dimension: NinjaMetrics.minTouchTarget,
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: foreground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NinjaChipRow extends StatelessWidget {
  const NinjaChipRow({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: NinjaMetrics.screenPadding,
    ),
    this.spacing = 8,
    this.controller,
  });
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: padding,
      controller: controller,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) SizedBox(width: spacing),
            children[index],
          ],
        ],
      ),
    );
  }
}

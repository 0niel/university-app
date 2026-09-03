import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_filter_chip.dart';
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
    return AppChip(
      label: label,
      selected: selected,
      onTap: onTap,
      onRemove: onRemove,
      removeSemanticLabel: removeSemanticLabel,
      showDot: showDot,
      dotColor: dotColor,
      count: count,
      enabled: enabled,
    );
  }
}

class NinjaChipRow extends StatelessWidget {
  const NinjaChipRow({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    this.spacing = AppSpacing.sm,
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
          for (final (index, child) in children.indexed) ...[
            if (index > 0) SizedBox(width: spacing),
            child,
          ],
        ],
      ),
    );
  }
}

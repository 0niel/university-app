import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    super.key,
    this.onTap,
    this.isSelected = false,
    this.color,
    this.icon,
    this.leadingIcon,
    this.small = false,
  });

  final String label;

  final VoidCallback? onTap;

  final bool isSelected;

  final Color? color;

  final IconData? icon;

  final IconData? leadingIcon;

  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final chipColor = color ?? colors.primary;

    final decoration = AppTheme.chipDecoration(
      context,
      isSelected: isSelected,
      color: chipColor,
    );

    final horizontalPadding = small ? 10.0 : 12.0;
    final verticalPadding = small ? 4.0 : 6.0;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsSelected: isSelected,
      child: Container(
        constraints: BoxConstraints(minHeight: onTap == null ? 32 : 44),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: small ? 14 : 16,
                color: isSelected ? chipColor : colors.active,
              ),
              SizedBox(width: small ? 4 : 6),
            ],
            Flexible(
              child: Text(
                label,
                style: (small ? AppText.caption : AppText.body).copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? chipColor : colors.active,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: small ? 4 : 6),
              Icon(
                icon,
                size: small ? 14 : 16,
                color: isSelected ? chipColor : colors.active,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppChipGroup extends StatelessWidget {
  const AppChipGroup({
    required this.chips,
    super.key,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  final List<Widget> chips;

  final double spacing;

  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: chips,
    );
  }
}

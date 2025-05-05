import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A custom chip widget that can be used in various places in the app
/// with consistent styling.
class CustomChip extends StatelessWidget {
  /// Creates a custom chip widget with app-specific styling.
  const CustomChip.ChipButton({
    required this.label,
    super.key,
    this.onTap,
    this.isSelected = false,
    this.color,
    this.icon,
    this.leadingIcon,
    this.small = false,
  });

  /// The text to display inside the chip.
  final String label;

  /// Called when the chip is tapped.
  final VoidCallback? onTap;

  /// Whether the chip is in selected state.
  final bool isSelected;

  /// Optional custom color for the chip.
  /// If not provided, will use the theme's primary color for selected state.
  final Color? color;

  /// Optional trailing icon to display in the chip.
  final IconData? icon;

  /// Optional leading icon to display in the chip.
  final IconData? leadingIcon;

  /// Whether to use a smaller size for the chip.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final chipColor = color ?? colors.primary;

    final decoration = AppTheme.chipDecoration(
      context,
      isSelected: isSelected,
      color: chipColor,
    );

    final horizontalPadding = small ? 10.0 : 12.0;
    final verticalPadding = small ? 4.0 : 6.0;

    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final backgroundColor = isLightTheme ? colors.white : colors.background03;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
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
                style: (small ? AppTextStyle.captionL : AppTextStyle.body).copyWith(
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

/// A collection of chips that handles spacing and wrapping automatically.
class ChipGroup extends StatelessWidget {
  /// Creates a group of custom chips with proper spacing.
  const ChipGroup({
    required this.chips,
    super.key,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  /// The list of chip widgets to display.
  final List<Widget> chips;

  /// The horizontal spacing between chips.
  final double spacing;

  /// The vertical spacing between rows of chips.
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

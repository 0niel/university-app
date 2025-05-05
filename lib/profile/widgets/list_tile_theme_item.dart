import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ListTileThemeItem extends StatelessWidget {
  const ListTileThemeItem({
    super.key,
    required this.title,
    required this.onTap,
    this.trailing,
    this.isSelected = false,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary.withOpacity(0.15) : colors.background03,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? colors.primary : colors.background03, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: colors.primary.withOpacity(0.1),
          highlightColor: colors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTextStyle.bodyL.copyWith(
                    color: colors.active,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

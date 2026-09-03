import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchScopeChip extends StatelessWidget {
  const SearchScopeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: selected,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.iconButton,
        ),
        child: AnimatedContainer(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.gap,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.accent : colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.button.copyWith(
              color: selected ? colors.onAccent : colors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

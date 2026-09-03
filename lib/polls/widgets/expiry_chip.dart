part of 'poll_creator_sheet.dart';

class _ExpiryChip extends StatelessWidget {
  const _ExpiryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sectionGap,
          vertical: AppSpacing.gap,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.tint : colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: AppText.button.copyWith(
            color: selected ? colors.accent : colors.muted,
          ),
        ),
      ),
    );
  }
}

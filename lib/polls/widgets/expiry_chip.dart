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
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.brandTint : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(NinjaRadius.pill),
        ),
        child: Text(
          label,
          style: NinjaText.button.copyWith(
            color: selected ? colors.brand : colors.muted,
          ),
        ),
      ),
    );
  }
}

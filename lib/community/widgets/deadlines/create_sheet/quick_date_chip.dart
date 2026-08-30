part of '../../create_deadline_sheet.dart';

class _QuickDateChip extends StatelessWidget {
  const _QuickDateChip({
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
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: selected,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.brandTint : colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.pill),
        ),
        child: Text(
          label,
          style: NinjaText.helper.copyWith(
            color: selected ? colors.brandInk : colors.mutedDark,
          ),
        ),
      ),
    );
  }
}

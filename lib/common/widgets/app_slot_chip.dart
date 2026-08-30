part of 'app_time_picker.dart';

class AppSlotChip extends StatelessWidget {
  const AppSlotChip({
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
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsSelected: selected,
      semanticsLabel: label,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        padding: const .symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? colors.ink : colors.surface,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Text(
          label,
          style: NinjaText.tabular(
            NinjaText.subtext.copyWith(
              color: selected ? colors.onInk : colors.muted,
              fontWeight: .w600,
            ),
          ),
        ),
      ),
    );
  }
}

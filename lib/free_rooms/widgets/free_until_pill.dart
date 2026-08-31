part of 'free_room_row.dart';

class _FreeUntilPill extends StatelessWidget {
  const _FreeUntilPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          maxLines: 2,
          overflow: .ellipsis,
          textAlign: .center,
          style: NinjaText.tabular(
            NinjaText.microLabel.copyWith(color: colors.mutedDark),
          ),
        ),
      ),
    );
  }
}
